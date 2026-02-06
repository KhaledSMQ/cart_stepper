part of 'cart_stepper.dart';

// =============================================================================
// _CartStepperCore - Internal StatefulWidget
// =============================================================================

/// Internal implementation widget for the cart stepper.
///
/// This is the full-featured implementation with all parameters.
/// Use [CartStepper] (simple) or [AsyncCartStepper] (async) instead.
class _CartStepperCore<T extends num> extends StatefulWidget {
  final T quantity;
  final QuantityChangedCallback<T>? onQuantityChanged;
  final DetailedQuantityChangedCallback<T>? onDetailedQuantityChanged;
  final AsyncQuantityChangedCallback<T>? onQuantityChangedAsync;
  final VoidCallback? onRemove;
  final Future<void> Function()? onRemoveAsync;
  final VoidCallback? onAdd;
  final Future<void> Function()? onAddAsync;
  final num minQuantity;
  final num maxQuantity;
  final CartStepperSize size;
  final CartStepperStyle style;
  final CartStepperAnimation animation;
  final CartStepperLoadingConfig loadingConfig;
  final bool? isLoading;
  final QuantityValidator<T>? validator;
  final AsyncQuantityValidator<T>? asyncValidator;
  final bool enabled;
  final bool showDeleteAtMin;
  final bool deleteViaQuantityChange;
  final IconData addIcon;
  final IconData incrementIcon;
  final IconData decrementIcon;
  final IconData deleteIcon;
  final String? semanticLabel;
  final bool autoCollapse;
  final num step;
  final bool enableLongPress;
  final Duration longPressInterval;
  final Duration initialLongPressDelay;
  final String Function(num quantity)? quantityFormatter;
  final Duration? autoCollapseDelay;
  final IconData? collapsedBadgeIcon;
  final bool? initiallyExpanded;
  final AsyncErrorCallback? onError;
  final Widget Function(BuildContext, CartStepperError, VoidCallback)?
      errorBuilder;
  final AddToCartButtonConfig addToCartConfig;
  final VoidCallback? onMaxReached;
  final VoidCallback? onMinReached;
  final ValidationRejectedCallback<T>? onValidationRejected;
  final OperationCancelledCallback<T>? onOperationCancelled;
  final bool optimisticUpdate;
  final bool revertOnError;
  final bool allowLongPressForAsync;
  final Duration throttleInterval;
  final Duration? debounceDelay;
  final bool enableManualInput;
  final TextInputType manualInputKeyboardType;
  final InputDecoration? manualInputDecoration;
  final ValueChanged<num>? onManualInputSubmitted;
  final Widget Function(BuildContext, num, ValueChanged<String>, VoidCallback)?
      manualInputBuilder;
  final CollapsedButtonBuilder? collapsedBuilder;
  final double? collapsedWidth;
  final double? collapsedHeight;

  // New feature params
  final TextDirection? textDirection;
  final CartStepperDirection direction;
  final VoidCallback? onExpandedCallback;
  final VoidCallback? onCollapsedCallback;
  final ExpandedWidgetBuilder<T>? expandedBuilder;
  final CartStepperUndoConfig? undoConfig;
  final CartStepperController<T>? controller;
  final Stream<T>? quantityStream;

  const _CartStepperCore({
    required this.quantity,
    this.onQuantityChanged,
    this.onDetailedQuantityChanged,
    this.onQuantityChangedAsync,
    this.onRemove,
    this.onRemoveAsync,
    this.onAdd,
    this.onAddAsync,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.size = CartStepperSize.normal,
    this.style = CartStepperStyle.defaultOrange,
    this.animation = const CartStepperAnimation(),
    this.loadingConfig = const CartStepperLoadingConfig(),
    this.isLoading,
    this.validator,
    this.asyncValidator,
    this.enabled = true,
    this.showDeleteAtMin = true,
    this.deleteViaQuantityChange = false,
    this.addIcon = Icons.add,
    this.incrementIcon = Icons.add,
    this.decrementIcon = Icons.remove,
    this.deleteIcon = Icons.delete_outline,
    this.semanticLabel,
    this.autoCollapse = true,
    this.step = 1,
    this.enableLongPress = true,
    this.longPressInterval = const Duration(milliseconds: 100),
    this.initialLongPressDelay = const Duration(milliseconds: 400),
    this.quantityFormatter,
    this.autoCollapseDelay,
    this.collapsedBadgeIcon,
    this.initiallyExpanded,
    this.onError,
    this.errorBuilder,
    this.addToCartConfig = const AddToCartButtonConfig(),
    this.onMaxReached,
    this.onMinReached,
    this.onValidationRejected,
    this.onOperationCancelled,
    this.optimisticUpdate = false,
    this.revertOnError = true,
    this.allowLongPressForAsync = false,
    this.throttleInterval = const Duration(milliseconds: 80),
    this.debounceDelay,
    this.enableManualInput = false,
    this.manualInputKeyboardType = TextInputType.number,
    this.manualInputDecoration,
    this.onManualInputSubmitted,
    this.manualInputBuilder,
    this.collapsedBuilder,
    this.collapsedWidth,
    this.collapsedHeight,
    this.textDirection,
    this.direction = CartStepperDirection.horizontal,
    this.onExpandedCallback,
    this.onCollapsedCallback,
    this.expandedBuilder,
    this.undoConfig,
    this.controller,
    this.quantityStream,
  })  : assert(minQuantity > 0, 'minQuantity must be > 0'),
        assert(maxQuantity > minQuantity, 'maxQuantity must be > minQuantity'),
        assert(step > 0, 'step must be > 0'),
        assert(quantity >= 0, 'quantity cannot be negative');

  @override
  State<_CartStepperCore<T>> createState() => _CartStepperCoreState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<num>('quantity', quantity));
    properties.add(DiagnosticsProperty<num>('minQuantity', minQuantity));
    properties.add(DiagnosticsProperty<num>('maxQuantity', maxQuantity));
    properties.add(DiagnosticsProperty<num>('step', step));
    properties.add(EnumProperty<CartStepperSize>('size', size));
    properties.add(DiagnosticsProperty<CartStepperStyle>('style', style));
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties
        .add(FlagProperty('isLoading', value: isLoading, ifTrue: 'loading'));
    properties.add(FlagProperty('enableManualInput',
        value: enableManualInput, ifTrue: 'manualInputEnabled'));
    properties.add(EnumProperty<CartStepperDirection>('direction', direction));
  }
}

// =============================================================================
// _CartStepperStateBase - Abstract base with all state fields
// =============================================================================

/// Abstract base class holding all state fields and lifecycle methods.
///
/// The operations and UI building logic are provided by mixins:
/// - [_CartStepperOperationsMixin] for business logic
/// - [_CartStepperBuildersMixin] for UI construction
abstract class _CartStepperStateBase<T extends num>
    extends State<_CartStepperCore<T>> with SingleTickerProviderStateMixin {
  // ============================================================================
  // Animation State
  // ============================================================================
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  // ============================================================================
  // UI State
  // ============================================================================
  bool _isExpanded = false;

  // ============================================================================
  // Operation State
  // ============================================================================
  bool _isLongPressing = false;
  bool _internalLoading = false;
  num? _pendingQuantity;
  int _operationId = 0;
  DateTime? _loadingStartTime;
  Timer? _collapseTimer;
  Completer<void>? _longPressCompleter;
  bool _longPressCompleterCompleted = false;

  // ============================================================================
  // Throttle State
  // ============================================================================
  DateTime? _lastOperationTime;
  Timer? _throttleTimer;
  num? _throttledQuantity;

  // ============================================================================
  // Debounce State
  // ============================================================================
  Timer? _debounceTimer;
  num? _debouncedQuantity;
  num? _debounceStartQuantity;

  // ============================================================================
  // Error State
  // ============================================================================
  CartStepperError? _lastError;
  CartStepperOperationType? _lastOperationType;

  // ============================================================================
  // Manual Input State
  // ============================================================================
  bool _isEditingManually = false;
  bool _isSubmittingManualInput = false;
  TextEditingController? _manualInputController;
  FocusNode? _manualInputFocusNode;

  // ============================================================================
  // Undo State
  // ============================================================================
  bool _isInUndoState = false;
  num? _undoPreviousQuantity;
  Timer? _undoTimer;

  // ============================================================================
  // Stream State
  // ============================================================================
  StreamSubscription<T>? _streamSubscription;
  T? _streamQuantity;

  // ============================================================================
  // Cached Colors
  // ============================================================================
  Color? _backgroundColor;
  Color? _foregroundColor;
  Color? _borderColor;
  Color? _shadowColor;
  Color? _disabledBorderColor;
  Color? _splashColor;
  Color? _highlightColor;
  bool _colorsInitialized = false;

  // ============================================================================
  // Generic Type Helper
  // ============================================================================
  T _asT(num value) {
    if (value is T) return value;
    if (T == int) return value.toInt() as T;
    if (T == double) return value.toDouble() as T;
    return value as T;
  }

  // ============================================================================
  // Computed Properties
  // ============================================================================
  bool get _isLoading => widget.isLoading ?? _internalLoading;

  bool get _isAsync =>
      widget.onQuantityChangedAsync != null ||
      widget.onRemoveAsync != null ||
      widget.onAddAsync != null;

  bool get _hasOperation => _pendingQuantity != null || _internalLoading;

  T get _effectiveQuantity {
    if (widget.controller != null) return widget.controller!.quantity;
    if (_streamQuantity != null) return _streamQuantity!;
    return widget.quantity;
  }

  num get _displayQuantity {
    if (_isInUndoState) return widget.minQuantity;
    if (_debouncedQuantity != null) return _debouncedQuantity!;
    if (widget.optimisticUpdate && _pendingQuantity != null) {
      return _pendingQuantity!;
    }
    return _effectiveQuantity;
  }

  bool get _isDebounceMode => widget.debounceDelay != null;

  // ============================================================================
  // Abstract methods implemented by mixins
  // ============================================================================
  /// Handles expand/collapse when quantity changes externally.
  /// Implemented by [_CartStepperOperationsMixin].
  void _handleExternalQuantityChange(num oldQty, num newQty);

  // ============================================================================
  // Color Accessors
  // ============================================================================
  Color get _bgColor => _backgroundColor!;

  Color get _fgColor => _foregroundColor!;

  Color get _bdColor => _borderColor!;

  Color get _shColor => _shadowColor!;

  Color get _disabledBdColor => _disabledBorderColor!;

  Color get _splColor => _splashColor!;

  Color get _hlColor => _highlightColor!;

  // ============================================================================
  // Setup Helpers
  // ============================================================================
  void _setupAnimations() {
    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.animation.expandCurve,
        reverseCurve: widget.animation.collapseCurve,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: widget.animation.expandCurve),
        reverseCurve: Interval(0.0, 0.5, curve: widget.animation.collapseCurve),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _computeColors() {
    final theme = Theme.of(context);
    final bgColor = widget.style.backgroundColor ?? theme.primaryColor;
    final fgColor = widget.style.foregroundColor ?? theme.colorScheme.onPrimary;
    final bdColor = widget.style.borderColor ?? bgColor;

    _backgroundColor = bgColor;
    _foregroundColor = fgColor;
    _borderColor = bdColor;
    _shadowColor = widget.style.shadowColor ?? bgColor.withValues(alpha: 0.3);
    _disabledBorderColor = bdColor.withValues(alpha: 0.5);
    _splashColor = fgColor.withValues(alpha: 0.2);
    _highlightColor = fgColor.withValues(alpha: 0.1);
    _colorsInitialized = true;
  }

  void _ensureColorsInitialized() {
    if (!_colorsInitialized) {
      _computeColors();
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onExpandedCallback?.call();
    } else if (status == AnimationStatus.dismissed) {
      widget.onCollapsedCallback?.call();
    }
  }

  void _attachController(CartStepperController<T>? controller) {
    if (controller == null) return;
    controller.addListener(_onControllerChanged);
  }

  void _detachController(CartStepperController<T>? controller) {
    if (controller == null) return;
    controller.removeListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _subscribeToStream(Stream<T>? stream) {
    if (stream == null) return;
    _streamSubscription = stream.listen(
      (value) {
        if (!mounted) return;
        final oldQty = _streamQuantity ?? widget.quantity;
        setState(() {
          _streamQuantity = value;
        });
        if (value != oldQty) {
          _handleExternalQuantityChange(oldQty, value);
          widget.onDetailedQuantityChanged?.call(
            value,
            _asT(oldQty),
            QuantityChangeType.stream,
          );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        widget.onError?.call(error, stackTrace);
      },
    );
  }
}

// =============================================================================
// _CartStepperCoreState - Final state class composing all mixins
// =============================================================================

/// The complete state class, composed from:
/// - [_CartStepperStateBase] (fields + setup)
/// - [_CartStepperOperationsMixin] (business logic)
/// - [_CartStepperBuildersMixin] (UI building)
class _CartStepperCoreState<T extends num> extends _CartStepperStateBase<T>
    with _CartStepperOperationsMixin<T>, _CartStepperBuildersMixin<T> {
  @override
  void initState() {
    super.initState();

    final qty = _effectiveQuantity;

    if (widget.initiallyExpanded != null) {
      _isExpanded = widget.initiallyExpanded!;
    } else {
      _isExpanded = qty > 0 && widget.autoCollapseDelay == null;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.animation.expandDuration,
    );

    _setupAnimations();
    _controller.addStatusListener(_onAnimationStatusChanged);

    if (_isExpanded) {
      _controller.value = 1.0;
      _resetCollapseTimer();
    }

    _attachController(widget.controller);
    _subscribeToStream(widget.quantityStream);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _computeColors();
  }

  @override
  void didUpdateWidget(_CartStepperCore<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.style != widget.style) {
      _computeColors();
    }

    if (oldWidget.animation.expandDuration != widget.animation.expandDuration) {
      _controller.duration = widget.animation.expandDuration;
    }

    if (widget.controller != oldWidget.controller) {
      _detachController(oldWidget.controller);
      _attachController(widget.controller);
    }

    if (widget.quantityStream != oldWidget.quantityStream) {
      _streamSubscription?.cancel();
      _subscribeToStream(widget.quantityStream);
    }

    final oldQty = oldWidget.controller?.quantity ?? oldWidget.quantity;
    final newQty = _effectiveQuantity;
    if (newQty != oldQty && _pendingQuantity == null) {
      _handleExternalQuantityChange(oldQty, newQty);
    }

    if (_pendingQuantity != null && newQty != oldQty) {
      // Only clear the optimistic pending value when the server has confirmed
      // it (server value matches pending). If they don't match, a newer
      // operation is still in flight — keep the optimistic value to prevent
      // the display from flickering between stale server responses and the
      // current optimistic target.
      if (newQty == _pendingQuantity) {
        setState(() {
          _pendingQuantity = null;
        });
      }
    }

    if (widget.autoCollapseDelay != oldWidget.autoCollapseDelay) {
      _resetCollapseTimer();
    }

    if (!widget.enableManualInput && _isEditingManually) {
      _cancelManualInput();
    }
  }

  @override
  void dispose() {
    _cancelAllOperations();
    _collapseTimer?.cancel();
    _throttleTimer?.cancel();
    _debounceTimer?.cancel();
    _undoTimer?.cancel();
    _streamSubscription?.cancel();
    _detachController(widget.controller);
    _manualInputController?.dispose();
    _manualInputFocusNode?.removeListener(_onManualInputFocusChange);
    _manualInputFocusNode?.dispose();
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _controller.dispose();
    super.dispose();
  }
}
