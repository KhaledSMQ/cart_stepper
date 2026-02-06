part of 'cart_stepper.dart';

// =============================================================================
// Operations Mixin - All business logic for the cart stepper
// =============================================================================

/// Mixin providing all business logic for [_CartStepperCoreState]:
/// - Validation (sync and async)
/// - Increment / decrement / removal / add operations
/// - Throttle / debounce / async execution
/// - Long press handling
/// - Manual input handling
/// - Undo state management
/// - Haptic feedback
/// - Collapse timer management
mixin _CartStepperOperationsMixin<T extends num> on _CartStepperStateBase<T> {
  // ============================================================================
  // External State Change Handling
  // ============================================================================
  @override
  void _handleExternalQuantityChange(num oldQty, num newQty) {
    if (newQty == 0) {
      if (_isExpanded && widget.autoCollapse) {
        _isExpanded = false;
        _controller.reverse();
        _collapseTimer?.cancel();
      }
    } else if (oldQty == 0) {
      _isExpanded = true;
      _controller.forward();
    }

    if (_isExpanded) {
      _resetCollapseTimer();
    }
  }

  // ============================================================================
  // Timer Management
  // ============================================================================
  void _resetCollapseTimer() {
    _collapseTimer?.cancel();
    if (widget.autoCollapseDelay != null && _isExpanded) {
      _collapseTimer = Timer(widget.autoCollapseDelay!, () {
        if (!mounted || !_isExpanded) return;
        setState(() => _isExpanded = false);
        _controller.reverse();
      });
    }
  }

  // ============================================================================
  // Manual Input
  // ============================================================================
  void _startManualInput() {
    if (!widget.enableManualInput || _isLoading || !widget.enabled) return;

    _resetCollapseTimer();
    _triggerHaptic();

    _manualInputController ??= TextEditingController();
    if (_manualInputFocusNode == null) {
      _manualInputFocusNode = FocusNode();
      _manualInputFocusNode!.addListener(_onManualInputFocusChange);
    }

    _manualInputController!.text = _displayQuantity.toString();
    _manualInputController!.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _manualInputController!.text.length,
    );

    setState(() {
      _isEditingManually = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isEditingManually) {
        _manualInputFocusNode?.requestFocus();
      }
    });
  }

  void _submitManualInput(String value) {
    if (!_isEditingManually || _isSubmittingManualInput) return;
    _isSubmittingManualInput = true;

    final currentQty = _displayQuantity;
    num? parsedValue = num.tryParse(value.trim());
    parsedValue ??= currentQty;

    final clampedValue =
        parsedValue.clamp(widget.minQuantity, widget.maxQuantity);

    setState(() {
      _isEditingManually = false;
    });

    if (clampedValue != currentQty) {
      if (!_validateChange(currentQty, clampedValue)) {
        _isSubmittingManualInput = false;
        _resetCollapseTimer();
        return;
      }

      _triggerHaptic();
      widget.onManualInputSubmitted?.call(clampedValue);

      if (widget.onQuantityChangedAsync != null) {
        if (_isDebounceMode) {
          _debouncedOperation(
            clampedValue,
            widget.onQuantityChangedAsync!,
            operationType: CartStepperOperationType.setQuantity,
          );
        } else {
          _throttledOperation(
            clampedValue,
            () => widget.onQuantityChangedAsync!(_asT(clampedValue)),
            operationType: CartStepperOperationType.setQuantity,
          );
        }
      } else {
        widget.onQuantityChanged?.call(_asT(clampedValue));
      }

      widget.onDetailedQuantityChanged?.call(
        _asT(clampedValue),
        _asT(currentQty),
        QuantityChangeType.manualInput,
      );

      if (clampedValue >= widget.maxQuantity) {
        widget.onMaxReached?.call();
      } else if (clampedValue == widget.minQuantity) {
        widget.onMinReached?.call();
      }
    }

    _isSubmittingManualInput = false;
    _resetCollapseTimer();
  }

  void _cancelManualInput() {
    if (!_isEditingManually) return;
    setState(() {
      _isEditingManually = false;
    });
    _resetCollapseTimer();
  }

  void _onManualInputFocusChange() {
    if (!mounted) return;
    if (_manualInputFocusNode != null &&
        !_manualInputFocusNode!.hasFocus &&
        _isEditingManually) {
      _submitManualInput(_manualInputController?.text ?? '');
    }
  }

  // ============================================================================
  // Haptic Feedback
  // ============================================================================
  void _triggerHaptic() {
    if (widget.animation.enableHaptics) {
      HapticFeedback.selectionClick();
    }
  }

  void _triggerErrorHaptic() {
    if (widget.animation.enableHaptics) {
      HapticFeedback.heavyImpact();
    }
  }

  // ============================================================================
  // Validation & Capability Checks
  // ============================================================================
  bool _canIncrement({bool checkValidator = true}) {
    if (!widget.enabled) return false;
    if (_isLoading && !widget.optimisticUpdate) return false;

    final currentQty = _displayQuantity;
    final newQty = currentQty + widget.step;
    if (newQty > widget.maxQuantity) return false;

    if (checkValidator && widget.validator != null) {
      return widget.validator!(_asT(currentQty), _asT(newQty));
    }
    return true;
  }

  bool _canDecrement({bool checkValidator = true}) {
    if (!widget.enabled) return false;
    if (_isLoading && !widget.optimisticUpdate) return false;

    final currentQty = _displayQuantity;
    final newQty = currentQty - widget.step;

    if (newQty < widget.minQuantity) {
      return widget.onRemove != null ||
          widget.onRemoveAsync != null ||
          (widget.deleteViaQuantityChange &&
              (widget.onQuantityChanged != null ||
                  widget.onQuantityChangedAsync != null));
    }

    if (checkValidator && widget.validator != null) {
      return widget.validator!(_asT(currentQty), _asT(newQty));
    }
    return true;
  }

  bool _validateChange(num currentQty, num newQty) {
    if (widget.validator == null) return true;

    final isValid = widget.validator!(_asT(currentQty), _asT(newQty));
    if (!isValid) {
      _triggerErrorHaptic();
      widget.onValidationRejected?.call(_asT(currentQty), _asT(newQty));
    }
    return isValid;
  }

  Future<bool> _performAsyncValidation(num currentQty, num newQty) async {
    if (!_validateChange(currentQty, newQty)) return false;
    if (widget.asyncValidator == null) return true;

    setState(() => _internalLoading = true);
    try {
      final isValid =
          await widget.asyncValidator!(_asT(currentQty), _asT(newQty));
      if (!mounted) return false;
      if (!isValid) {
        _triggerErrorHaptic();
        widget.onValidationRejected?.call(_asT(currentQty), _asT(newQty));
      }
      return isValid;
    } catch (error, stackTrace) {
      widget.onError?.call(error, stackTrace);
      return false;
    } finally {
      if (mounted) {
        setState(() => _internalLoading = false);
      }
    }
  }

  // ============================================================================
  // Operation Cancellation
  // ============================================================================
  void _cancelAllOperations() {
    _cancelLongPress();
    _throttleTimer?.cancel();
    _throttledQuantity = null;
    _cancelDebounce();

    if (_pendingQuantity != null) {
      widget.onOperationCancelled?.call(_asT(_pendingQuantity!));
    }
    _pendingQuantity = null;
  }

  void _cancelLongPress() {
    _isLongPressing = false;
    if (_longPressCompleter != null && !_longPressCompleterCompleted) {
      _longPressCompleterCompleted = true;
      _longPressCompleter!.complete();
    }
    _longPressCompleter = null;
  }

  // ============================================================================
  // Throttled Operation
  // ============================================================================
  void _throttledOperation(
    num targetQty,
    Future<void> Function() operation, {
    CartStepperOperationType operationType =
        CartStepperOperationType.setQuantity,
  }) {
    final now = DateTime.now();
    final throttleInterval = widget.throttleInterval;

    if (_lastOperationTime != null &&
        now.difference(_lastOperationTime!) < throttleInterval) {
      _throttledQuantity = targetQty;

      // When optimistic update is enabled, immediately show the throttled
      // value so the user sees instant feedback even though the actual
      // API call is deferred until the throttle interval passes.
      if (widget.optimisticUpdate) {
        setState(() {
          _pendingQuantity = targetQty;
          if (_lastError != null) {
            _lastError = null;
          }
        });
      }

      _throttleTimer?.cancel();
      _throttleTimer = Timer(throttleInterval, () {
        if (!mounted) return;
        final qty = _throttledQuantity;
        _throttledQuantity = null;
        if (qty != null) {
          _executeAsyncOperation(qty, operation, operationType: operationType);
        }
      });
      return;
    }

    _lastOperationTime = now;
    _executeAsyncOperation(targetQty, operation, operationType: operationType);
  }

  // ============================================================================
  // Debounced Operation
  // ============================================================================
  void _debouncedOperation(
    num targetQty,
    Future<void> Function(T qty) asyncCallback, {
    CartStepperOperationType operationType =
        CartStepperOperationType.setQuantity,
  }) {
    _debounceStartQuantity ??= _effectiveQuantity;

    setState(() {
      _debouncedQuantity = targetQty;
      if (_lastError != null) {
        _lastError = null;
      }
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay!, () {
      if (!mounted) return;
      _executeDebouncedCallback(targetQty, asyncCallback, operationType);
    });
  }

  Future<void> _executeDebouncedCallback(
    num targetQty,
    Future<void> Function(T qty) asyncCallback,
    CartStepperOperationType operationType,
  ) async {
    final myOperationId = ++_operationId;
    _loadingStartTime = DateTime.now();

    if (widget.loadingConfig.showDelay > Duration.zero) {
      await Future.delayed(widget.loadingConfig.showDelay);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = true);

    try {
      await asyncCallback(_asT(targetQty));
      if (!mounted || _operationId != myOperationId) return;

      setState(() {
        _debouncedQuantity = null;
        _debounceStartQuantity = null;
        _lastError = null;
      });

      if (targetQty >= widget.maxQuantity) {
        widget.onMaxReached?.call();
      } else if (targetQty == widget.minQuantity) {
        widget.onMinReached?.call();
      }
    } catch (error, stackTrace) {
      if (!mounted || _operationId != myOperationId) return;

      final typedError = CartStepperOperationError(
        operationType: operationType,
        targetQuantity: targetQty,
        cause: error,
        stackTrace: stackTrace,
      );

      _lastError = typedError;
      _lastOperationType = operationType;

      if (widget.onError != null) {
        widget.onError!(error, stackTrace);
      } else {
        assert(() {
          debugPrint('CartStepper: Unhandled async error - $error');
          debugPrint('Stack trace: $stackTrace');
          debugPrint('Tip: Provide an onError callback to handle this error.');
          return true;
        }());
      }

      if (widget.revertOnError) {
        setState(() {
          _debouncedQuantity = null;
        });
      }
      _debounceStartQuantity = null;
    }

    if (!mounted || _operationId != myOperationId) return;

    final elapsed = DateTime.now().difference(_loadingStartTime!);
    if (elapsed < widget.loadingConfig.minimumDuration) {
      await Future.delayed(widget.loadingConfig.minimumDuration - elapsed);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = false);
  }

  void _cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _debouncedQuantity = null;
    _debounceStartQuantity = null;
  }

  // ============================================================================
  // Async Operation Execution
  // ============================================================================
  Future<void> _executeAsyncOperation(
    num targetQty,
    Future<void> Function() operation, {
    CartStepperOperationType operationType =
        CartStepperOperationType.setQuantity,
  }) async {
    if (_pendingQuantity != null && _pendingQuantity != targetQty) {
      widget.onOperationCancelled?.call(_asT(_pendingQuantity!));
    }

    // Run async validation if present
    if (widget.asyncValidator != null) {
      final currentQty = _displayQuantity;
      final isValid = await _performAsyncValidation(currentQty, targetQty);
      if (!isValid || !mounted) return;
    }

    final myOperationId = ++_operationId;
    _lastOperationType = operationType;

    setState(() {
      _pendingQuantity = targetQty;
      if (_lastError != null) {
        _lastError = null;
      }
    });

    _loadingStartTime = DateTime.now();

    if (widget.loadingConfig.showDelay > Duration.zero) {
      await Future.delayed(widget.loadingConfig.showDelay);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = true);

    try {
      await operation();
      if (!mounted || _operationId != myOperationId) return;

      setState(() {
        _pendingQuantity = null;
        _lastError = null;
      });
    } catch (error, stackTrace) {
      if (!mounted || _operationId != myOperationId) return;

      final typedError = CartStepperOperationError(
        operationType: operationType,
        targetQuantity: targetQty,
        cause: error,
        stackTrace: stackTrace,
      );

      _lastError = typedError;

      if (widget.onError != null) {
        widget.onError!(error, stackTrace);
      } else {
        assert(() {
          debugPrint('CartStepper: Unhandled async error - $error');
          debugPrint('Stack trace: $stackTrace');
          debugPrint('Tip: Provide an onError callback to handle this error.');
          return true;
        }());
      }

      if (widget.optimisticUpdate && widget.revertOnError) {
        setState(() {
          _pendingQuantity = null;
        });
      }
    }

    if (!mounted || _operationId != myOperationId) return;

    final elapsed = DateTime.now().difference(_loadingStartTime!);
    if (elapsed < widget.loadingConfig.minimumDuration) {
      await Future.delayed(widget.loadingConfig.minimumDuration - elapsed);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = false);
  }

  // ============================================================================
  // Retry
  // ============================================================================
  void _retryLastOperation() {
    if (_lastError == null || _lastOperationType == null) return;

    final operationType = _lastOperationType!;
    setState(() {
      _lastError = null;
    });

    switch (operationType) {
      case CartStepperOperationType.increment:
        _increment();
        break;
      case CartStepperOperationType.decrement:
        _decrement();
        break;
      case CartStepperOperationType.add:
        _onAddPressed();
        break;
      case CartStepperOperationType.remove:
        final newQty = (_displayQuantity - widget.step);
        _handleRemoval(newQty, false);
        break;
      case CartStepperOperationType.setQuantity:
      case CartStepperOperationType.reset:
        break;
    }
  }

  // ============================================================================
  // Increment
  // ============================================================================
  void _increment({bool isLongPress = false}) {
    _resetCollapseTimer();

    if (!_canIncrement(checkValidator: false)) return;

    final currentQty = _displayQuantity;
    final newQty = (currentQty + widget.step)
        .clamp(widget.minQuantity, widget.maxQuantity);

    if (!_validateChange(currentQty, newQty)) return;

    _triggerHaptic();

    final changeType = isLongPress
        ? QuantityChangeType.longPressIncrement
        : QuantityChangeType.increment;

    final isMax = newQty >= widget.maxQuantity;

    if (widget.onQuantityChangedAsync != null) {
      if (_isDebounceMode) {
        _debouncedOperation(
          newQty,
          widget.onQuantityChangedAsync!,
          operationType: CartStepperOperationType.increment,
        );
      } else {
        if (isLongPress && !widget.allowLongPressForAsync) {
          if (_hasOperation) return;
        }

        _throttledOperation(
          newQty,
          () async {
            await widget.onQuantityChangedAsync!(_asT(newQty));
            if (isMax) widget.onMaxReached?.call();
          },
          operationType: CartStepperOperationType.increment,
        );
      }
    } else {
      widget.onQuantityChanged?.call(_asT(newQty));
      if (isMax) widget.onMaxReached?.call();
    }

    widget.onDetailedQuantityChanged?.call(
      _asT(newQty),
      _asT(currentQty),
      changeType,
    );
  }

  // ============================================================================
  // Decrement
  // ============================================================================
  void _decrement({bool isLongPress = false}) {
    _resetCollapseTimer();

    if (!_canDecrement(checkValidator: false)) return;

    final currentQty = _displayQuantity;
    final newQty = currentQty - widget.step;

    if (newQty < widget.minQuantity) {
      _handleRemoval(newQty, isLongPress);
      return;
    }

    if (!_validateChange(currentQty, newQty)) return;

    _triggerHaptic();

    final changeType = isLongPress
        ? QuantityChangeType.longPressDecrement
        : QuantityChangeType.decrement;

    final isMin = newQty == widget.minQuantity;

    if (widget.onQuantityChangedAsync != null) {
      if (_isDebounceMode) {
        _debouncedOperation(
          newQty,
          widget.onQuantityChangedAsync!,
          operationType: CartStepperOperationType.decrement,
        );
      } else {
        if (isLongPress && !widget.allowLongPressForAsync) {
          if (_hasOperation) return;
        }

        _throttledOperation(
          newQty,
          () async {
            await widget.onQuantityChangedAsync!(_asT(newQty));
            if (isMin) widget.onMinReached?.call();
          },
          operationType: CartStepperOperationType.decrement,
        );
      }
    } else {
      widget.onQuantityChanged?.call(_asT(newQty));
      if (isMin) widget.onMinReached?.call();
    }

    widget.onDetailedQuantityChanged?.call(
      _asT(newQty),
      _asT(currentQty),
      changeType,
    );
  }

  // ============================================================================
  // Removal
  // ============================================================================
  void _handleRemoval(num newQty, bool isLongPress) {
    _triggerHaptic();

    if (widget.undoConfig != null && widget.undoConfig!.enabled) {
      _startUndoState();
      return;
    }

    _executeRemoval(newQty, isLongPress);
  }

  void _executeRemoval(num newQty, bool isLongPress) {
    if (widget.onRemoveAsync != null) {
      if (isLongPress && !widget.allowLongPressForAsync && _hasOperation) {
        return;
      }
      _throttledOperation(
        newQty,
        () => widget.onRemoveAsync!(),
        operationType: CartStepperOperationType.remove,
      );
    } else if (widget.onRemove != null) {
      widget.onRemove!();
    } else if (widget.deleteViaQuantityChange) {
      if (widget.onQuantityChangedAsync != null) {
        if (isLongPress && !widget.allowLongPressForAsync && _hasOperation) {
          return;
        }
        _throttledOperation(
          newQty,
          () => widget.onQuantityChangedAsync!(_asT(newQty)),
          operationType: CartStepperOperationType.remove,
        );
      } else {
        widget.onQuantityChanged?.call(_asT(newQty));
      }
    }

    widget.onDetailedQuantityChanged?.call(
      _asT(newQty),
      _asT(_displayQuantity),
      QuantityChangeType.remove,
    );
  }

  // ============================================================================
  // Undo
  // ============================================================================
  void _startUndoState() {
    _undoPreviousQuantity = _displayQuantity;
    setState(() => _isInUndoState = true);
    _undoTimer?.cancel();
    _undoTimer = Timer(widget.undoConfig!.duration, () {
      if (!mounted) return;
      _finalizeRemoval();
    });
  }

  void _undoRemoval() {
    _undoTimer?.cancel();
    setState(() {
      _isInUndoState = false;
      _undoPreviousQuantity = null;
    });
  }

  void _finalizeRemoval() {
    _undoTimer?.cancel();
    final prevQty = _undoPreviousQuantity ?? _displayQuantity;
    setState(() {
      _isInUndoState = false;
      _undoPreviousQuantity = null;
    });
    final newQty = prevQty - widget.step;
    _executeRemoval(newQty, false);
  }

  // ============================================================================
  // Add Button
  // ============================================================================
  void _onAddPressed() {
    final currentQty = _displayQuantity;
    if (currentQty > 0 && !_isExpanded) {
      _triggerHaptic();
      setState(() => _isExpanded = true);
      _controller.forward();
      _resetCollapseTimer();
      return;
    }

    if (!widget.enabled || (_isLoading && !widget.optimisticUpdate)) return;
    _triggerHaptic();

    final newQty =
        widget.minQuantity.clamp(widget.minQuantity, widget.maxQuantity);

    if (widget.onAddAsync != null) {
      _throttledOperation(
        newQty,
        () async {
          await widget.onAddAsync!();
          if (mounted) {
            setState(() => _isExpanded = true);
            _controller.forward();
          }
        },
        operationType: CartStepperOperationType.add,
      );
    } else if (widget.onAdd != null) {
      widget.onAdd!();
      setState(() => _isExpanded = true);
      _controller.forward();
    } else if (widget.onQuantityChangedAsync != null) {
      _throttledOperation(
        newQty,
        () async {
          await widget.onQuantityChangedAsync!(_asT(newQty));
          if (mounted) {
            setState(() => _isExpanded = true);
            _controller.forward();
          }
        },
        operationType: CartStepperOperationType.add,
      );
    } else {
      widget.onQuantityChanged?.call(_asT(newQty));
      setState(() => _isExpanded = true);
      _controller.forward();
    }

    widget.onDetailedQuantityChanged?.call(
      _asT(newQty),
      _asT(currentQty),
      QuantityChangeType.add,
    );
  }

  // ============================================================================
  // Long Press
  // ============================================================================
  void _startLongPress(bool isIncrement) {
    if (!widget.enableLongPress) return;

    if (_isAsync && !widget.allowLongPressForAsync && !_isDebounceMode) {
      return;
    }

    _isLongPressing = true;
    _longPressCompleter = Completer<void>();
    _longPressCompleterCompleted = false;
    _longPressLoop(isIncrement);
  }

  void _stopLongPress() {
    _cancelLongPress();
  }

  Future<void> _longPressLoop(bool isIncrement) async {
    try {
      await Future.any([
        Future.delayed(widget.initialLongPressDelay),
        if (_longPressCompleter != null) _longPressCompleter!.future,
      ]);
    } catch (_) {
      return;
    }

    if (!_isLongPressing || !mounted) return;

    while (_isLongPressing && mounted) {
      if (isIncrement) {
        if (_canIncrement()) {
          _increment(isLongPress: true);
        } else {
          _cancelLongPress();
          break;
        }
      } else {
        if (_canDecrement() && _displayQuantity > widget.minQuantity) {
          _decrement(isLongPress: true);
        } else {
          _cancelLongPress();
          break;
        }
      }

      try {
        await Future.any([
          Future.delayed(widget.longPressInterval),
          if (_longPressCompleter != null) _longPressCompleter!.future,
        ]);
      } catch (_) {
        break;
      }

      if (!_isLongPressing || !mounted) break;
    }
  }
}
