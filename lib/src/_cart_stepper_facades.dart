part of 'cart_stepper.dart';

// =============================================================================
// CartStepper - Simple synchronous facade
// =============================================================================

/// A simple, animated cart quantity stepper widget.
///
/// Use this widget for synchronous quantity management with a clean, minimal API.
/// For async operations (API calls, loading states), use [AsyncCartStepper] instead.
///
/// The type parameter [T] defaults to `int` and is inferred from [quantity].
/// Pass a `double` quantity to use `CartStepper<double>` for decimal quantities.
///
/// ## Example
/// ```dart
/// CartStepper(
///   quantity: itemQuantity,
///   onQuantityChanged: (qty) => setState(() => itemQuantity = qty),
///   onRemove: () => removeFromCart(),
/// )
/// ```
///
/// ## With double quantities
/// ```dart
/// CartStepper<double>(
///   quantity: weightKg,
///   step: 0.5,
///   onQuantityChanged: (qty) => setState(() => weightKg = qty),
/// )
/// ```
///
/// See also:
/// - [AsyncCartStepper] for async operations with loading indicators
/// - [CartStepperController] for external state management
/// - [CartStepperTheme] for theming multiple steppers
class CartStepper<T extends num> extends StatelessWidget {
  /// Current quantity value.
  ///
  /// Must be >= 0. The widget reacts to changes in this value.
  /// The type [T] is inferred from this value (int or double).
  final T quantity;

  /// Synchronous callback when quantity changes.
  ///
  /// Called with the new quantity value.
  final QuantityChangedCallback<T>? onQuantityChanged;

  /// Detailed callback with change type metadata.
  ///
  /// Provides old value, new value, and the type of change for analytics
  /// or conditional behavior.
  final DetailedQuantityChangedCallback<T>? onDetailedQuantityChanged;

  /// Callback when item should be removed (quantity goes below min).
  final VoidCallback? onRemove;

  /// Callback when add button is pressed (from collapsed state).
  ///
  /// If null, defaults to calling [onQuantityChanged] with [minQuantity] + [step].
  final VoidCallback? onAdd;

  /// Minimum allowed quantity.
  ///
  /// Must be >= 0. Defaults to 0.
  final num minQuantity;

  /// Maximum allowed quantity.
  ///
  /// Must be > [minQuantity]. Defaults to 99.
  final num maxQuantity;

  /// Step value for increment/decrement operations.
  ///
  /// Must be > 0. Defaults to 1.
  final num step;

  /// Size variant controlling dimensions.
  ///
  /// Defaults to [CartStepperSize.normal].
  final CartStepperSize size;

  /// Visual style configuration.
  ///
  /// Defaults to [CartStepperStyle.defaultOrange].
  final CartStepperStyle style;

  /// Animation configuration.
  ///
  /// Controls timing and curves for all animations.
  final CartStepperAnimation animation;

  /// Configuration for the "Add to Cart" button appearance.
  final AddToCartButtonConfig addToCartConfig;

  /// Whether the stepper is enabled.
  ///
  /// When `false`, all interactions are disabled.
  final bool enabled;

  /// Whether to show delete icon when at minimum quantity.
  final bool showDeleteAtMin;

  /// Whether to auto-collapse when quantity reaches 0.
  ///
  /// Defaults to `true`.
  final bool autoCollapse;

  /// Semantic label for accessibility.
  ///
  /// When null, a default label is generated based on the quantity.
  final String? semanticLabel;

  /// Text direction for RTL/LTR layout.
  ///
  /// When null, uses [Directionality.of(context)].
  /// When RTL, the increment/decrement buttons are swapped.
  final TextDirection? textDirection;

  /// Layout direction for stepper controls.
  ///
  /// Defaults to [CartStepperDirection.horizontal].
  final CartStepperDirection direction;

  /// Callback when the stepper finishes expanding.
  final VoidCallback? onExpanded;

  /// Callback when the stepper finishes collapsing.
  final VoidCallback? onCollapsed;

  /// External controller for programmatic state management.
  ///
  /// When provided, [quantity] and [onQuantityChanged] are ignored.
  /// The widget automatically syncs with the controller's state.
  final CartStepperController<T>? controller;

  /// Stream of quantity values for reactive updates.
  ///
  /// When provided, the widget subscribes and updates quantity automatically.
  /// Mutually exclusive with [controller].
  final Stream<T>? quantityStream;

  /// Creates a simple cart stepper widget.
  const CartStepper({
    super.key,
    required this.quantity,
    this.onQuantityChanged,
    this.onDetailedQuantityChanged,
    this.onRemove,
    this.onAdd,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.step = 1,
    this.size = CartStepperSize.normal,
    this.style = CartStepperStyle.defaultOrange,
    this.animation = const CartStepperAnimation(),
    this.addToCartConfig = const AddToCartButtonConfig(),
    this.enabled = true,
    this.showDeleteAtMin = true,
    this.autoCollapse = true,
    this.semanticLabel,
    this.textDirection,
    this.direction = CartStepperDirection.horizontal,
    this.onExpanded,
    this.onCollapsed,
    this.controller,
    this.quantityStream,
  }) : assert(
          controller == null || (onQuantityChanged == null),
          'Cannot provide both controller and onQuantityChanged',
        );

  @override
  Widget build(BuildContext context) {
    return _CartStepperCore<T>(
      quantity: quantity,
      onQuantityChanged: onQuantityChanged,
      onDetailedQuantityChanged: onDetailedQuantityChanged,
      onRemove: onRemove,
      onAdd: onAdd,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
      step: step,
      size: size,
      style: style,
      animation: animation,
      addToCartConfig: addToCartConfig,
      enabled: enabled,
      showDeleteAtMin: showDeleteAtMin,
      autoCollapse: autoCollapse,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      direction: direction,
      onExpandedCallback: onExpanded,
      onCollapsedCallback: onCollapsed,
      controller: controller,
      quantityStream: quantityStream,
    );
  }
}

// =============================================================================
// AsyncCartStepper - Full-featured async facade
// =============================================================================

/// An async-capable cart quantity stepper widget with full feature set.
///
/// Use this widget when quantity changes involve API calls or async operations.
/// It supports loading indicators, optimistic updates, debouncing, error handling,
/// and many other advanced features organized into config objects.
///
/// For simple synchronous use cases, prefer [CartStepper] instead.
///
/// ## Example
/// ```dart
/// AsyncCartStepper(
///   quantity: itemQuantity,
///   onQuantityChangedAsync: (qty) async {
///     await api.updateCart(itemId, qty);
///     setState(() => itemQuantity = qty);
///   },
///   onError: (error, stack) => showErrorSnackbar(error),
/// )
/// ```
///
/// ## With Optimistic Updates
/// ```dart
/// AsyncCartStepper(
///   quantity: itemQuantity,
///   onQuantityChangedAsync: (qty) async {
///     await api.updateCart(itemId, qty);
///     setState(() => itemQuantity = qty);
///   },
///   asyncBehavior: CartStepperAsyncBehavior(
///     optimisticUpdate: true,
///     debounceDelay: Duration(milliseconds: 500),
///   ),
/// )
/// ```
///
/// See also:
/// - [CartStepper] for simple synchronous use cases
/// - [CartStepperController] for external state management
/// - [CartStepperTheme] for theming multiple steppers
class AsyncCartStepper<T extends num> extends StatelessWidget {
  /// Current quantity value.
  ///
  /// Must be >= 0. The widget reacts to changes in this value.
  final T quantity;

  /// Asynchronous callback when quantity changes.
  ///
  /// When provided, the stepper shows a loading indicator while the future completes.
  final AsyncQuantityChangedCallback<T>? onQuantityChangedAsync;

  /// Async callback when item should be removed.
  ///
  /// Shows loading indicator while the removal completes.
  final Future<void> Function()? onRemoveAsync;

  /// Async callback when add button is pressed.
  ///
  /// Shows loading indicator while the add operation completes.
  final Future<void> Function()? onAddAsync;

  /// Synchronous callback when quantity changes.
  ///
  /// Used alongside async callbacks for local state updates.
  final QuantityChangedCallback<T>? onQuantityChanged;

  /// Detailed callback with change type metadata.
  final DetailedQuantityChangedCallback<T>? onDetailedQuantityChanged;

  /// Synchronous callback when item should be removed.
  final VoidCallback? onRemove;

  /// Synchronous callback when add button is pressed.
  final VoidCallback? onAdd;

  /// Minimum allowed quantity.
  ///
  /// Must be >= 0. Defaults to 0.
  final num minQuantity;

  /// Maximum allowed quantity.
  ///
  /// Must be > [minQuantity]. Defaults to 99.
  final num maxQuantity;

  /// Step value for increment/decrement operations.
  ///
  /// Must be > 0. Defaults to 1.
  final num step;

  /// Size variant controlling dimensions.
  ///
  /// Defaults to [CartStepperSize.normal].
  final CartStepperSize size;

  /// Visual style configuration.
  ///
  /// Defaults to [CartStepperStyle.defaultOrange].
  final CartStepperStyle style;

  /// Animation configuration.
  final CartStepperAnimation animation;

  /// Configuration for the "Add to Cart" button appearance.
  final AddToCartButtonConfig addToCartConfig;

  /// Loading indicator configuration.
  final CartStepperLoadingConfig loadingConfig;

  /// External loading state for manual control.
  ///
  /// When provided, overrides the internal loading state.
  final bool? isLoading;

  /// Whether the stepper is enabled.
  final bool enabled;

  /// Whether to show delete icon when at minimum quantity.
  final bool showDeleteAtMin;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// When true, pressing delete at min calls onQuantityChanged instead of onRemove.
  final bool deleteViaQuantityChange;

  /// Async operation behavior configuration.
  final CartStepperAsyncBehavior? asyncBehavior;

  /// Custom icon configuration.
  final CartStepperIconConfig? iconConfig;

  /// Collapse/badge behavior configuration.
  final CartStepperCollapseConfig? collapseConfig;

  /// Long-press rapid quantity change configuration.
  final CartStepperLongPressConfig? longPressConfig;

  /// Manual input configuration.
  final CartStepperManualInputConfig? manualInputConfig;

  /// Callback for handling async operation errors.
  final AsyncErrorCallback? onError;

  /// Builder for displaying inline error UI.
  final Widget Function(
    BuildContext context,
    CartStepperError error,
    VoidCallback retry,
  )? errorBuilder;

  /// Custom synchronous validator for quantity changes.
  ///
  /// Return `false` to prevent a quantity change from occurring.
  final QuantityValidator<T>? validator;

  /// Async validator for quantity changes.
  ///
  /// Shows loading indicator during validation. Takes precedence
  /// over synchronous [validator] when both are provided.
  final AsyncQuantityValidator<T>? asyncValidator;

  /// Callback when quantity reaches [maxQuantity].
  final VoidCallback? onMaxReached;

  /// Callback when quantity reaches [minQuantity].
  final VoidCallback? onMinReached;

  /// Callback when a quantity change is rejected by the validator.
  final ValidationRejectedCallback<T>? onValidationRejected;

  /// Callback when an async operation is cancelled.
  final OperationCancelledCallback<T>? onOperationCancelled;

  /// Custom quantity formatter for display.
  final String Function(num quantity)? quantityFormatter;

  /// Text direction for RTL/LTR layout.
  final TextDirection? textDirection;

  /// Layout direction for stepper controls.
  final CartStepperDirection direction;

  /// Builder for fully custom expanded controls.
  ///
  /// Replaces the default `[- qty +]` layout with custom UI.
  final ExpandedWidgetBuilder<T>? expandedBuilder;

  /// Undo-after-delete configuration.
  ///
  /// When provided, shows an undo prompt after delete/remove actions.
  final CartStepperUndoConfig? undoConfig;

  /// External controller for programmatic state management.
  final CartStepperController<T>? controller;

  /// Stream of quantity values for reactive updates.
  final Stream<T>? quantityStream;

  /// Creates an async cart stepper widget.
  const AsyncCartStepper({
    super.key,
    required this.quantity,
    this.onQuantityChangedAsync,
    this.onRemoveAsync,
    this.onAddAsync,
    this.onQuantityChanged,
    this.onDetailedQuantityChanged,
    this.onRemove,
    this.onAdd,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.step = 1,
    this.size = CartStepperSize.normal,
    this.style = CartStepperStyle.defaultOrange,
    this.animation = const CartStepperAnimation(),
    this.addToCartConfig = const AddToCartButtonConfig(),
    this.loadingConfig = const CartStepperLoadingConfig(),
    this.isLoading,
    this.enabled = true,
    this.showDeleteAtMin = true,
    this.deleteViaQuantityChange = false,
    this.semanticLabel,
    this.asyncBehavior,
    this.iconConfig,
    this.collapseConfig,
    this.longPressConfig,
    this.manualInputConfig,
    this.onError,
    this.errorBuilder,
    this.validator,
    this.asyncValidator,
    this.onMaxReached,
    this.onMinReached,
    this.onValidationRejected,
    this.onOperationCancelled,
    this.quantityFormatter,
    this.textDirection,
    this.direction = CartStepperDirection.horizontal,
    this.expandedBuilder,
    this.undoConfig,
    this.controller,
    this.quantityStream,
  }) : assert(
          controller == null || (onQuantityChanged == null),
          'Cannot provide both controller and onQuantityChanged',
        );

  @override
  Widget build(BuildContext context) {
    final asyncCfg = asyncBehavior;
    final icons = iconConfig;
    final collapse = collapseConfig;
    final longPress = longPressConfig;
    final manualInput = manualInputConfig;

    return _CartStepperCore<T>(
      quantity: quantity,
      onQuantityChanged: onQuantityChanged,
      onDetailedQuantityChanged: onDetailedQuantityChanged,
      onQuantityChangedAsync: onQuantityChangedAsync,
      onRemove: onRemove,
      onRemoveAsync: onRemoveAsync,
      onAdd: onAdd,
      onAddAsync: onAddAsync,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
      step: step,
      size: size,
      style: style,
      animation: animation,
      addToCartConfig: addToCartConfig,
      loadingConfig: loadingConfig,
      isLoading: isLoading,
      enabled: enabled,
      showDeleteAtMin: showDeleteAtMin,
      deleteViaQuantityChange: deleteViaQuantityChange,
      semanticLabel: semanticLabel,
      // Unpack async behavior
      optimisticUpdate: asyncCfg?.optimisticUpdate ?? false,
      revertOnError: asyncCfg?.revertOnError ?? true,
      allowLongPressForAsync: asyncCfg?.allowLongPressForAsync ?? false,
      throttleInterval:
          asyncCfg?.throttleInterval ?? const Duration(milliseconds: 80),
      debounceDelay: asyncCfg?.debounceDelay,
      // Unpack icon config
      addIcon: icons?.addIcon ?? Icons.add,
      incrementIcon: icons?.incrementIcon ?? Icons.add,
      decrementIcon: icons?.decrementIcon ?? Icons.remove,
      deleteIcon: icons?.deleteIcon ?? Icons.delete_outline,
      collapsedBadgeIcon: icons?.collapsedBadgeIcon,
      // Unpack collapse config
      autoCollapse: collapse?.autoCollapse ?? true,
      autoCollapseDelay: collapse?.autoCollapseDelay,
      initiallyExpanded: collapse?.initiallyExpanded,
      collapsedBuilder: collapse?.collapsedBuilder,
      collapsedWidth: collapse?.collapsedWidth,
      collapsedHeight: collapse?.collapsedHeight,
      onExpandedCallback: collapse?.onExpanded,
      onCollapsedCallback: collapse?.onCollapsed,
      // Unpack long press config
      enableLongPress: longPress?.enabled ?? true,
      longPressInterval:
          longPress?.interval ?? const Duration(milliseconds: 100),
      initialLongPressDelay:
          longPress?.initialDelay ?? const Duration(milliseconds: 400),
      // Unpack manual input config
      enableManualInput: manualInput?.enabled ?? false,
      manualInputKeyboardType:
          manualInput?.keyboardType ?? TextInputType.number,
      manualInputDecoration: manualInput?.decoration,
      onManualInputSubmitted: manualInput?.onSubmitted,
      manualInputBuilder: manualInput?.builder,
      // Error handling
      onError: onError,
      errorBuilder: errorBuilder,
      // Event callbacks
      validator: validator,
      asyncValidator: asyncValidator,
      onMaxReached: onMaxReached,
      onMinReached: onMinReached,
      onValidationRejected: onValidationRejected,
      onOperationCancelled: onOperationCancelled,
      quantityFormatter: quantityFormatter,
      // New features
      textDirection: textDirection,
      direction: direction,
      expandedBuilder: expandedBuilder,
      undoConfig: undoConfig,
      controller: controller,
      quantityStream: quantityStream,
    );
  }
}
