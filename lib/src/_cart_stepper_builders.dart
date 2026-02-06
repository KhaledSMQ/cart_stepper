part of 'cart_stepper.dart';

// =============================================================================
// Builders Mixin - All UI building methods for the cart stepper
// =============================================================================

/// Mixin providing all `build` and `_build*` methods for [_CartStepperCoreState]:
/// - Main `build` method
/// - Animated stepper container
/// - Add / undo button
/// - Expanded controls (increment, quantity, decrement)
/// - Quantity display (animated counter, manual input, loading)
/// - Button style content
/// - Loading indicators
mixin _CartStepperBuildersMixin<T extends num>
    on _CartStepperStateBase<T>, _CartStepperOperationsMixin<T> {
  // ============================================================================
  // Main Build
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    _ensureColorsInitialized();
    final qty = _displayQuantity;
    final canInc = _canIncrement(checkValidator: false);
    final canDec = _canDecrement(checkValidator: false);

    final addButton = _isInUndoState ? _buildUndoButton() : _buildAddButton();
    final expandedControls = _buildExpandedControls();

    Widget stepper = RepaintBoundary(
      child: Semantics(
        label: widget.semanticLabel ??
            'Quantity: $qty. Tap to ${qty == 0 ? 'add' : 'adjust'}',
        value: qty.toString(),
        increasedValue: canInc ? '${qty + widget.step}' : null,
        decreasedValue: canDec ? '${qty - widget.step}' : null,
        onIncrease: canInc ? () => _increment() : null,
        onDecrease: canDec ? () => _decrement() : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return _buildAnimatedStepper(addButton, expandedControls);
          },
          child: const SizedBox.shrink(),
        ),
      ),
    );

    if (widget.textDirection != null) {
      stepper = Directionality(
        textDirection: widget.textDirection!,
        child: stepper,
      );
    }

    if (_lastError != null && widget.errorBuilder != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          stepper,
          widget.errorBuilder!(context, _lastError!, _retryLastOperation),
        ],
      );
    }

    return stepper;
  }

  // ============================================================================
  // Undo Button
  // ============================================================================
  Widget _buildUndoButton() {
    final undoConfig = widget.undoConfig!;
    if (undoConfig.builder != null) {
      return undoConfig.builder!(context, _undoRemoval);
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _undoRemoval,
        customBorder: const CircleBorder(),
        splashColor: _splColor,
        highlightColor: _hlColor,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.undo,
                  size: widget.size.iconSize * 0.9, color: _fgColor),
              const SizedBox(width: 4),
              Text(
                'Undo',
                style: TextStyle(
                  color: _fgColor,
                  fontSize: widget.size.fontSize * 0.9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Animated Stepper Container
  // ============================================================================
  Widget _buildAnimatedStepper(Widget addButton, Widget expandedControls) {
    final sizeConfig = widget.size;
    final isVertical = widget.direction == CartStepperDirection.vertical;
    final expandedWidth =
        isVertical ? sizeConfig.height : sizeConfig.expandedWidth;
    final expandedHeight =
        isVertical ? sizeConfig.expandedWidth : sizeConfig.height;
    final collapsedHeight = widget.collapsedHeight ??
        (isVertical ? sizeConfig.collapsedSize : sizeConfig.height);

    final collapsedSize = _calculateCollapsedSize(sizeConfig);

    final currentWidth = isVertical
        ? (widget.collapsedWidth ?? sizeConfig.collapsedSize) +
            (expandedWidth -
                    (widget.collapsedWidth ?? sizeConfig.collapsedSize)) *
                _expandAnimation.value
        : collapsedSize +
            (expandedWidth - collapsedSize) * _expandAnimation.value;

    final height = isVertical
        ? collapsedSize +
            (expandedHeight - collapsedSize) * _expandAnimation.value
        : collapsedHeight +
            (expandedHeight - collapsedHeight) * _expandAnimation.value;

    final borderRadius =
        _getCollapsedBorderRadius(isVertical ? currentWidth : height);

    final isButtonStyle =
        widget.addToCartConfig.style == AddToCartButtonStyle.button;
    final qty = _displayQuantity;
    final showFilledBackground = _isExpanded ||
        _expandAnimation.value > 0 ||
        (isButtonStyle && qty == 0) ||
        _isInUndoState;

    // Build content based on current state.
    // Determine how expanded controls should appear/disappear.
    Widget expandedContent;
    if (widget.animation.transitionBuilder != null) {
      // Custom transition builder controls how expanded controls animate.
      // The add button always uses the default opacity fade.
      expandedContent = widget.animation.transitionBuilder!(
        context,
        _expandAnimation,
        expandedControls,
      );
    } else {
      expandedContent = Opacity(
        opacity: _opacityAnimation.value,
        child: expandedControls,
      );
    }

    final normalContent = Stack(
      children: [
        if (_expandAnimation.value < 1)
          Positioned.fill(
            child: Opacity(
              opacity: 1 - _expandAnimation.value,
              child: addButton,
            ),
          ),
        if (_expandAnimation.value > 0)
          // OverflowBox lets the controls lay out at full expanded size
          // even during early animation when the container is still
          // narrower than the controls' minimum intrinsic width — this
          // prevents RenderFlex overflow without distorting the layout.
          // Aligned to the start edge so the controls reveal naturally
          // from the same side as the add button.
          // The parent ClipRRect clips the visual overflow.
          Positioned.fill(
            child: OverflowBox(
              alignment: isVertical
                  ? Alignment.topCenter
                  : AlignmentDirectional.centerStart,
              maxWidth: expandedWidth,
              maxHeight: expandedHeight,
              child: expandedContent,
            ),
          ),
      ],
    );

    // Use AnimatedSwitcher to smoothly cross-fade between the undo button
    // and the normal expanded controls when entering/leaving undo state.
    final Widget content = AnimatedSwitcher(
      duration: widget.animation.expandDuration,
      child: _isInUndoState
          ? KeyedSubtree(key: const ValueKey('undo'), child: addButton)
          : KeyedSubtree(key: const ValueKey('controls'), child: normalContent),
    );

    return Container(
      width: currentWidth,
      height: height,
      decoration: BoxDecoration(
        color: showFilledBackground ? _bgColor : Colors.transparent,
        borderRadius: borderRadius,
        border: (!showFilledBackground || _expandAnimation.value < 1)
            ? Border.all(
                color: _bdColor,
                width: widget.style.borderWidth,
              )
            : null,
        boxShadow: widget.style.elevation > 0 &&
                (showFilledBackground || _expandAnimation.value > 0.5)
            ? [
                BoxShadow(
                  color: _shColor,
                  blurRadius: widget.style.elevation * 2,
                  offset: Offset(0, widget.style.elevation),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: content,
      ),
    );
  }

  double _calculateCollapsedSize(CartStepperSize sizeConfig) {
    if (widget.collapsedWidth != null) {
      return widget.collapsedWidth!;
    }

    final config = widget.addToCartConfig;

    if (config.style == AddToCartButtonStyle.circleIcon) {
      return config.buttonWidth ?? sizeConfig.collapsedSize;
    }

    if (config.buttonWidth != null) {
      return config.buttonWidth!;
    }

    final hasText = config.buttonText != null && config.buttonText!.isNotEmpty;
    final hasIcon = config.showIcon;

    if (!hasText && hasIcon) {
      return sizeConfig.collapsedSize + 16;
    } else if (hasText && !hasIcon) {
      return (config.buttonText!.length * 8.0 + 24).clamp(60.0, 200.0);
    } else {
      return (config.buttonText!.length * 8.0 + 48).clamp(80.0, 200.0);
    }
  }

  BorderRadiusGeometry _getCollapsedBorderRadius(double height) {
    if (widget.style.borderRadius != null) {
      return widget.style.borderRadius!;
    }

    final config = widget.addToCartConfig;
    if (config.borderRadius != null) {
      if (_expandAnimation.value > 0) {
        return BorderRadius.circular(height / 2);
      }
      return config.borderRadius!;
    }

    return BorderRadius.circular(height / 2);
  }

  // ============================================================================
  // Add Button
  // ============================================================================
  Widget _buildAddButton() {
    if (widget.collapsedBuilder != null) {
      return widget.collapsedBuilder!(
        context,
        _displayQuantity,
        _isLoading,
        (widget.enabled && !_isLoading) ? _onAddPressed : () {},
      );
    }

    final iconSize = widget.size.iconSize * widget.style.iconScale;
    final loadingConfig = widget.loadingConfig;
    final loadingSize = iconSize * loadingConfig.sizeMultiplier;
    final buttonConfig = widget.addToCartConfig;

    final isButtonStyle = buttonConfig.style == AddToCartButtonStyle.button;
    final iconColor = isButtonStyle
        ? _fgColor
        : (widget.enabled ? _bdColor : _disabledBdColor);
    final loadingColor = loadingConfig.color ?? iconColor;

    final qty = _displayQuantity;
    Widget content;
    if (_isLoading && !widget.optimisticUpdate) {
      content =
          _buildSpinKitIndicator(loadingConfig.type, loadingSize, loadingColor);
    } else if (qty > 0) {
      content = CartBadge(
        count: qty,
        size: 14,
        badgeColor: _bgColor,
        textColor: _fgColor,
        child: Icon(
          widget.collapsedBadgeIcon ?? Icons.shopping_cart,
          size: iconSize,
          color: widget.enabled ? _bdColor : _disabledBdColor,
        ),
      );
    } else if (isButtonStyle) {
      content = _buildButtonStyleContent(buttonConfig, iconSize, iconColor);
    } else {
      content = Transform.rotate(
        angle: _rotationAnimation.value * 2 * math.pi,
        child: Icon(
          buttonConfig.icon ?? widget.addIcon,
          size: iconSize,
          color: iconColor,
        ),
      );
    }

    final inkShape = (isButtonStyle && qty == 0)
        ? RoundedRectangleBorder(
            borderRadius: buttonConfig.borderRadius ??
                BorderRadius.circular(widget.size.height / 2),
          )
        : const CircleBorder();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (widget.enabled && !_isLoading) ? _onAddPressed : null,
        customBorder: inkShape,
        splashColor: _splColor,
        highlightColor: _hlColor,
        child: Center(
          child: content,
        ),
      ),
    );
  }

  Widget _buildButtonStyleContent(
    AddToCartButtonConfig config,
    double iconSize,
    Color iconColor,
  ) {
    final hasText = config.buttonText != null && config.buttonText!.isNotEmpty;
    final hasIcon = config.showIcon;
    final icon = config.icon ?? Icons.add_shopping_cart;

    final textStyle = TextStyle(
      color: _fgColor,
      fontSize: widget.size.fontSize,
      fontWeight: widget.style.fontWeight,
    ).merge(widget.style.textStyle);

    if (!hasText && hasIcon) {
      return Icon(icon, size: iconSize, color: iconColor);
    }

    if (hasText && !hasIcon) {
      return Padding(
        padding: config.padding ?? const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          config.buttonText!,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    }

    final iconWidget = Icon(icon, size: iconSize * 0.9, color: iconColor);
    final textWidget = Flexible(
      child: Text(
        config.buttonText!,
        style: textStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );

    final children = config.iconLeading
        ? [iconWidget, const SizedBox(width: 4), textWidget]
        : [textWidget, const SizedBox(width: 4), iconWidget];

    return Padding(
      padding: config.padding ?? const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  // ============================================================================
  // Expanded Controls
  // ============================================================================
  Widget _buildExpandedControls() {
    if (widget.expandedBuilder != null) {
      return widget.expandedBuilder!(
        context,
        _asT(_displayQuantity),
        () => _increment(),
        () => _decrement(),
        _isLoading,
      );
    }

    final iconSize = widget.size.iconSize * widget.style.iconScale;
    final fontSize = widget.size.fontSize;
    final qty = _displayQuantity;
    final isAtMin = qty <= widget.minQuantity;
    final hasRemoveAction = widget.onRemove != null ||
        widget.onRemoveAsync != null ||
        (widget.deleteViaQuantityChange &&
            (widget.onQuantityChanged != null ||
                widget.onQuantityChangedAsync != null));
    final showDelete = widget.showDeleteAtMin && isAtMin && hasRemoveAction;
    final buttonsDisabled =
        _isLoading && widget.loadingConfig.disableButtonsDuringLoading;
    final allowInteraction =
        widget.optimisticUpdate || !_isLoading || !buttonsDisabled;

    final canInc = _canIncrement(checkValidator: false);
    final canDec = _canDecrement(checkValidator: false);

    final effectiveDirection =
        widget.textDirection ?? Directionality.maybeOf(context);
    final isRtl = effectiveDirection == TextDirection.rtl;

    final decrementButton = StepperButton(
      icon: showDelete ? widget.deleteIcon : widget.decrementIcon,
      iconSize: iconSize,
      iconColor: _fgColor,
      enabled: widget.enabled && canDec && allowInteraction,
      onTap: () => _decrement(),
      onLongPressStart: () => _startLongPress(false),
      onLongPressEnd: _stopLongPress,
      size: widget.size.buttonTapSize,
      splashColor: _splColor,
      highlightColor: _hlColor,
    );

    final incrementButton = StepperButton(
      icon: widget.incrementIcon,
      iconSize: iconSize,
      iconColor: _fgColor,
      enabled: widget.enabled && canInc && allowInteraction,
      onTap: () => _increment(),
      onLongPressStart: () => _startLongPress(true),
      onLongPressEnd: _stopLongPress,
      size: widget.size.buttonTapSize,
      splashColor: _splColor,
      highlightColor: _hlColor,
    );

    final quantityDisplay = Expanded(
      child: Center(
        child: _buildQuantityDisplay(qty, fontSize),
      ),
    );

    if (widget.direction == CartStepperDirection.vertical) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          incrementButton,
          quantityDisplay,
          decrementButton,
        ],
      );
    }

    final firstButton = isRtl ? incrementButton : decrementButton;
    final lastButton = isRtl ? decrementButton : incrementButton;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        firstButton,
        quantityDisplay,
        lastButton,
      ],
    );
  }

  // ============================================================================
  // Quantity Display
  // ============================================================================
  Widget _buildQuantityDisplay(num qty, double fontSize) {
    if (_isLoading && !widget.optimisticUpdate) {
      return _buildLoadingIndicator();
    }

    if (_isEditingManually && widget.enableManualInput) {
      if (widget.manualInputBuilder != null) {
        return widget.manualInputBuilder!(
          context,
          qty,
          _submitManualInput,
          _cancelManualInput,
        );
      }
      return _buildManualInputField(fontSize);
    }

    final textStyle = TextStyle(
      color: _fgColor,
      fontSize: fontSize,
      fontWeight: widget.style.fontWeight,
    ).merge(widget.style.textStyle);

    final counter = AnimatedCounter(
      value: qty,
      style: textStyle,
      duration: widget.animation.countChangeDuration,
      curve: widget.animation.countChangeCurve,
      formatter: widget.quantityFormatter,
    );

    if (widget.enableManualInput && widget.enabled && !_isLoading) {
      return GestureDetector(
        onTap: _startManualInput,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _fgColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              bottom: BorderSide(
                color: _fgColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          child: counter,
        ),
      );
    }

    return counter;
  }

  // ============================================================================
  // Manual Input Field
  // ============================================================================
  Widget _buildManualInputField(double fontSize) {
    final textStyle = TextStyle(
      color: _fgColor,
      fontSize: fontSize,
      fontWeight: widget.style.fontWeight,
    ).merge(widget.style.textStyle);

    final decoration = widget.manualInputDecoration ??
        InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        );

    return Container(
      width: widget.size.expandedWidth * 0.35,
      decoration: BoxDecoration(
        color: _fgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border(
          bottom: BorderSide(
            color: _fgColor,
            width: 2,
          ),
        ),
      ),
      child: TextField(
        controller: _manualInputController,
        focusNode: _manualInputFocusNode,
        keyboardType: widget.manualInputKeyboardType,
        textAlign: TextAlign.center,
        style: textStyle,
        decoration: decoration,
        cursorColor: _fgColor,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          LengthLimitingTextInputFormatter(
            widget.maxQuantity.toString().length + 2,
          ),
        ],
        onSubmitted: _submitManualInput,
        onTapOutside: (_) {
          if (_isEditingManually) {
            _submitManualInput(_manualInputController?.text ?? '');
          }
        },
      ),
    );
  }

  // ============================================================================
  // Loading Indicators
  // ============================================================================
  Widget _buildLoadingIndicator() {
    final config = widget.loadingConfig;
    final size = widget.size.iconSize * config.sizeMultiplier;
    final color = config.color ?? _fgColor;

    if (config.customIndicator != null) {
      return SizedBox(
        width: size,
        height: size,
        child: config.customIndicator,
      );
    }

    return _buildSpinKitIndicator(config.type, size, color);
  }

  Widget _buildSpinKitIndicator(
    CartStepperLoadingType type,
    double size,
    Color color,
  ) {
    switch (type) {
      case CartStepperLoadingType.threeBounce:
        return SpinKitThreeBounce(color: color, size: size);
      case CartStepperLoadingType.fadingCircle:
        return SpinKitFadingCircle(color: color, size: size);
      case CartStepperLoadingType.pulse:
        return SpinKitPulse(color: color, size: size);
      case CartStepperLoadingType.dualRing:
        return SpinKitDualRing(color: color, size: size);
      case CartStepperLoadingType.spinningCircle:
        return SpinKitSpinningCircle(color: color, size: size);
      case CartStepperLoadingType.wave:
        return SpinKitWave(color: color, size: size, itemCount: 5);
      case CartStepperLoadingType.chasingDots:
        return SpinKitChasingDots(color: color, size: size);
      case CartStepperLoadingType.threeInOut:
        return SpinKitThreeInOut(color: color, size: size);
      case CartStepperLoadingType.ring:
        return SpinKitRing(color: color, size: size, lineWidth: 2);
      case CartStepperLoadingType.ripple:
        return SpinKitRipple(color: color, size: size);
      case CartStepperLoadingType.fadingFour:
        return SpinKitFadingFour(color: color, size: size);
      case CartStepperLoadingType.pianoWave:
        return SpinKitPianoWave(color: color, size: size, itemCount: 5);
      case CartStepperLoadingType.dancingSquare:
        return SpinKitDancingSquare(color: color, size: size);
      case CartStepperLoadingType.cubeGrid:
        return SpinKitCubeGrid(color: color, size: size);
      case CartStepperLoadingType.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      case CartStepperLoadingType.linear:
        return SizedBox(
          width: size * 2,
          height: size * 0.3,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: color.withValues(alpha: 0.2),
          ),
        );
    }
  }
}
