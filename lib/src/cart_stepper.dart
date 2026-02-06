import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'animated_counter.dart';
import 'cart_badge.dart';
import 'cart_stepper_config.dart';
import 'cart_stepper_enums.dart';
import 'cart_stepper_errors.dart';
import 'cart_stepper_types.dart';
import 'stepper_button.dart';

// Note: Public API exports are managed in lib/cart_stepper.dart
// Internal imports only - no re-exports to avoid duplication

/// A highly customizable, animated cart quantity stepper widget.
///
/// The CartStepper provides an elegant way to adjust quantities with smooth
/// animations, loading states, and extensive customization options.
///
/// ## Features
/// - Smooth expand/collapse animation between add button and stepper
/// - Configurable min/max quantity limits
/// - Delete action when quantity reaches minimum
/// - Multiple size variants (compact, normal, large)
/// - Customizable styling and animations
/// - Async operation support with loading indicators
/// - State-agnostic design - works with any state management
/// - High-performance with minimal rebuilds
/// - Full accessibility support
///
/// ## Basic Example
/// ```dart
/// CartStepper(
///   quantity: itemQuantity,
///   onQuantityChanged: (qty) => setState(() => itemQuantity = qty),
///   onRemove: () => removeFromCart(),
/// )
/// ```
///
/// ## Async Example
/// ```dart
/// CartStepper(
///   quantity: itemQuantity,
///   onQuantityChangedAsync: (qty) async {
///     await api.updateCart(itemId, qty);
///     setState(() => itemQuantity = qty);
///   },
///   onError: (error, stack) => showErrorSnackbar(error),
/// )
/// ```
///
/// See also:
/// - [CartStepperController] for external state management
/// - [CartStepperTheme] for theming multiple steppers
/// - [CartBadge] for displaying cart count badges
class CartStepper extends StatefulWidget {
  /// Current quantity value.
  ///
  /// Must be >= 0. The widget reacts to changes in this value.
  final int quantity;

  /// Synchronous callback when quantity changes.
  ///
  /// Called with the new quantity value. Either this or [onQuantityChangedAsync]
  /// should be provided for the stepper to be functional.
  final QuantityChangedCallback? onQuantityChanged;

  /// Asynchronous callback when quantity changes.
  ///
  /// When provided, the stepper shows a loading indicator while the future completes.
  /// Takes precedence over [onQuantityChanged] if both are provided.
  final AsyncQuantityChangedCallback? onQuantityChangedAsync;

  /// Callback when item should be removed (quantity goes below min).
  ///
  /// Called when decrementing would result in a value below [minQuantity].
  /// If null and [deleteViaQuantityChange] is false, the delete button
  /// won't trigger any action.
  final VoidCallback? onRemove;

  /// Async callback when item should be removed.
  ///
  /// Shows loading indicator while the removal completes.
  final Future<void> Function()? onRemoveAsync;

  /// Callback when add button is pressed (from collapsed state).
  ///
  /// If null, defaults to calling [onQuantityChanged] with [minQuantity] + [step].
  final VoidCallback? onAdd;

  /// Async callback when add button is pressed.
  ///
  /// Shows loading indicator while the add operation completes.
  final Future<void> Function()? onAddAsync;

  /// Minimum allowed quantity.
  ///
  /// Must be >= 0. Defaults to 0.
  final int minQuantity;

  /// Maximum allowed quantity.
  ///
  /// Must be > [minQuantity]. Defaults to 99.
  final int maxQuantity;

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

  /// Loading indicator configuration.
  ///
  /// Controls appearance and behavior during async operations.
  final CartStepperLoadingConfig loadingConfig;

  /// External loading state for manual control.
  ///
  /// When provided, overrides the internal loading state.
  /// Useful for coordinating loading across multiple widgets.
  final bool? isLoading;

  /// Custom validator for quantity changes.
  ///
  /// Return `false` to prevent a quantity change from occurring.
  final QuantityValidator? validator;

  /// Whether the stepper is enabled.
  ///
  /// When `false`, all interactions are disabled.
  final bool enabled;

  /// Whether to show delete icon when at minimum quantity.
  ///
  /// The delete action requires [onRemove] or [onRemoveAsync] to be set,
  /// or [deleteViaQuantityChange] to be enabled.
  final bool showDeleteAtMin;

  /// When true, pressing delete at min quantity calls onQuantityChanged instead of onRemove.
  ///
  /// Useful when you want delete functionality without a separate onRemove callback.
  /// The callback receives a value below minQuantity (quantity - step).
  final bool deleteViaQuantityChange;

  /// Custom icon for add button (collapsed state).
  final IconData addIcon;

  /// Custom icon for increment button.
  final IconData incrementIcon;

  /// Custom icon for decrement button.
  final IconData decrementIcon;

  /// Custom icon for delete/remove button.
  final IconData deleteIcon;

  /// Semantic label for accessibility.
  ///
  /// When null, a default label is generated based on the quantity.
  final String? semanticLabel;

  /// Whether to auto-collapse when quantity reaches 0.
  ///
  /// Defaults to `true`.
  final bool autoCollapse;

  /// Step value for increment/decrement operations.
  ///
  /// Must be > 0. Defaults to 1.
  final int step;

  /// Whether long-press enables rapid quantity changes.
  ///
  /// Defaults to `true`.
  final bool enableLongPress;

  /// Interval between quantity changes during long-press.
  ///
  /// Defaults to 100 milliseconds.
  final Duration longPressInterval;

  /// Initial delay before long-press repeat starts.
  ///
  /// Prevents accidental rapid changes from brief presses.
  /// Defaults to 400 milliseconds.
  final Duration initialLongPressDelay;

  /// Custom quantity formatter for display.
  ///
  /// Use [QuantityFormatters] for built-in options like abbreviation.
  final String Function(int quantity)? quantityFormatter;

  /// Duration after which the stepper auto-collapses if inactive.
  ///
  /// When null, the stepper stays expanded indefinitely.
  final Duration? autoCollapseDelay;

  /// Icon to show when collapsed but having items (badge mode).
  ///
  /// Defaults to [Icons.shopping_cart].
  final IconData? separateIcon;

  /// Background color when the stepper is collapsed.
  final Color? collapsedBackgroundColor;

  /// Icon/Text color when the stepper is collapsed.
  final Color? collapsedForegroundColor;

  /// Custom size for the increment icon.
  ///
  /// If null, uses [CartStepperSize.iconSize] * [CartStepperStyle.iconScale].
  final double? incrementIconSize;

  /// Custom size for the decrement icon.
  ///
  /// If null, uses [CartStepperSize.iconSize] * [CartStepperStyle.iconScale].
  final double? decrementIconSize;

  /// Custom size for the delete icon.
  ///
  /// If null, uses [CartStepperSize.iconSize] * [CartStepperStyle.iconScale].
  final double? deleteIconSize;

  /// Custom size for the separate icon (collapsed badge mode).
  ///
  /// If null, uses [CartStepperSize.iconSize] * [CartStepperStyle.iconScale].
  final double? separateIconSize;

  /// Custom size for the add icon (collapsed mode).
  ///
  /// If null, uses [CartStepperSize.iconSize] * [CartStepperStyle.iconScale].
  final double? addIconSize;

  /// Force initial expanded state.
  ///
  /// When null, auto-determines based on quantity and [autoCollapseDelay]:
  /// - With autoCollapseDelay: starts collapsed to show badge view
  /// - Without autoCollapseDelay: starts expanded if quantity > 0
  ///
  /// Set to `true` for cart pages, `false` for product lists.
  final bool? initiallyExpanded;

  /// Callback for handling async operation errors.
  ///
  /// If provided, errors are passed to this callback instead of being silently swallowed.
  /// The loading state is cleaned up regardless of whether this is provided.
  final AsyncErrorCallback? onError;

  /// Builder for displaying inline error UI.
  ///
  /// When provided and an error occurs, this builder is called to create
  /// an error widget that displays instead of or alongside the stepper.
  /// The error is automatically cleared on the next successful operation.
  ///
  /// Example:
  /// ```dart
  /// errorBuilder: (context, error, retry) => Text(
  ///   error.message,
  ///   style: TextStyle(color: Colors.red),
  /// )
  /// ```
  final Widget Function(
    BuildContext context,
    CartStepperError error,
    VoidCallback retry,
  )?
  errorBuilder;

  /// Configuration for the "Add to Cart" button appearance.
  final AddToCartButtonConfig addToCartConfig;

  /// Callback when quantity reaches [maxQuantity].
  ///
  /// Called after the quantity change that resulted in reaching the maximum.
  /// Useful for showing feedback like "Maximum quantity reached".
  final VoidCallback? onMaxReached;

  /// Callback when quantity reaches [minQuantity].
  ///
  /// Called after the quantity change that resulted in reaching the minimum.
  /// Note: This is different from [onRemove] which is called when attempting
  /// to go below the minimum. This callback fires when landing exactly on min.
  final VoidCallback? onMinReached;

  /// Callback when a quantity change is rejected by the validator.
  ///
  /// Provides feedback when the validator prevents a change.
  /// Useful for showing messages like "Cannot add more items".
  final ValidationRejectedCallback? onValidationRejected;

  /// Callback when an async operation is cancelled.
  ///
  /// Called when a new operation starts before the previous one completes.
  final OperationCancelledCallback? onOperationCancelled;

  /// Whether to update the UI optimistically before async operations complete.
  ///
  /// When `true`, the quantity display updates immediately when the user
  /// interacts, and reverts if the async operation fails.
  /// When `false` (default), the UI waits for the operation to complete.
  final bool optimisticUpdate;

  /// Whether to revert to previous value on async error when using optimistic updates.
  ///
  /// Only applies when [optimisticUpdate] is `true`.
  /// Defaults to `true`.
  final bool revertOnError;

  /// Whether long-press rapid-fire is allowed for async operations.
  ///
  /// When `false` (default), long-press rapid-fire is disabled when using
  /// async callbacks to prevent queuing multiple concurrent operations.
  /// When `true`, long-press works normally but may queue operations.
  final bool allowLongPressForAsync;

  /// Throttle interval for rapid operations.
  ///
  /// Prevents rapid-fire operations from overwhelming the system.
  /// Operations within this interval are queued and only the last value is executed.
  /// Defaults to 80 milliseconds.
  final Duration throttleInterval;

  /// Debounce delay for async operations.
  ///
  /// When set, enables debounce mode for a better user experience:
  /// - User can freely adjust quantity without waiting for each API call
  /// - UI updates immediately (locally)
  /// - After user stops interacting for this duration, one API call is made
  /// - Long press works smoothly without blocking
  ///
  /// This is ideal for shopping carts where you want responsive UI
  /// and efficient network usage.
  ///
  /// When null (default), async operations are executed immediately
  /// (with optional throttling via [throttleInterval]).
  ///
  /// Example:
  /// ```dart
  /// CartStepper(
  ///   quantity: quantity,
  ///   debounceDelay: Duration(milliseconds: 500),
  ///   onQuantityChangedAsync: (qty) async {
  ///     await api.updateCart(itemId, qty);
  ///     setState(() => quantity = qty);
  ///   },
  /// )
  /// ```
  final Duration? debounceDelay;

  /// Whether tapping the quantity enables manual input via keyboard.
  ///
  /// When `true`, users can tap on the quantity number in the expanded stepper
  /// to open a text field for direct value entry. The entered value is
  /// automatically clamped to [minQuantity] and [maxQuantity].
  ///
  /// Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// CartStepper(
  ///   quantity: quantity,
  ///   enableManualInput: true,
  ///   onQuantityChanged: (qty) => setState(() => quantity = qty),
  /// )
  /// ```
  final bool enableManualInput;

  /// Keyboard type for manual input.
  ///
  /// Only applies when [enableManualInput] is `true`.
  /// Defaults to [TextInputType.number].
  final TextInputType manualInputKeyboardType;

  /// Input decoration for the manual input TextField.
  ///
  /// When null, uses a minimal decoration that blends with the stepper.
  /// Only applies when [enableManualInput] is `true`.
  final InputDecoration? manualInputDecoration;

  /// Callback when manual input is submitted.
  ///
  /// Called with the new value after clamping to min/max.
  /// This is called in addition to [onQuantityChanged] or [onQuantityChangedAsync].
  /// Only applies when [enableManualInput] is `true`.
  final ValueChanged<int>? onManualInputSubmitted;

  /// Builder for custom manual input widget.
  ///
  /// When provided, this builder is used instead of the default TextField
  /// when the user taps on the quantity to edit it manually.
  ///
  /// The builder receives:
  /// - `context`: The build context
  /// - `currentValue`: The current quantity value
  /// - `onSubmit`: Callback to submit a new value (will be clamped to min/max)
  /// - `onCancel`: Callback to cancel editing without changing the value
  ///
  /// Example:
  /// ```dart
  /// CartStepper(
  ///   quantity: quantity,
  ///   enableManualInput: true,
  ///   manualInputBuilder: (context, currentValue, onSubmit, onCancel) {
  ///     return MyCustomNumberPicker(
  ///       value: currentValue,
  ///       onConfirm: (value) => onSubmit(value.toString()),
  ///       onCancel: onCancel,
  ///     );
  ///   },
  /// )
  /// ```
  final Widget Function(
    BuildContext context,
    int currentValue,
    ValueChanged<String> onSubmit,
    VoidCallback onCancel,
  )?
  manualInputBuilder;

  /// Creates a cart stepper widget.
  const CartStepper({
    super.key,
    required this.quantity,
    this.onQuantityChanged,
    this.onQuantityChangedAsync,
    this.onRemove,
    this.onRemoveAsync,
    this.onAdd,
    this.onAddAsync,
    this.minQuantity = 0,
    this.maxQuantity = 99,
    this.size = CartStepperSize.normal,
    this.style = CartStepperStyle.defaultOrange,
    this.animation = const CartStepperAnimation(),
    this.loadingConfig = const CartStepperLoadingConfig(),
    this.isLoading,
    this.validator,
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
    this.separateIcon,
    this.initiallyExpanded,
    this.collapsedBackgroundColor,
    this.collapsedForegroundColor,
    this.incrementIconSize,
    this.decrementIconSize,
    this.deleteIconSize,
    this.separateIconSize,
    this.addIconSize,
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
  }) : assert(minQuantity >= 0, 'minQuantity must be >= 0'),
       assert(maxQuantity > minQuantity, 'maxQuantity must be > minQuantity'),
       assert(step > 0, 'step must be > 0'),
       assert(quantity >= 0, 'quantity cannot be negative');

  @override
  State<CartStepper> createState() => _CartStepperState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('quantity', quantity));
    properties.add(IntProperty('minQuantity', minQuantity));
    properties.add(IntProperty('maxQuantity', maxQuantity));
    properties.add(IntProperty('step', step));
    properties.add(EnumProperty<CartStepperSize>('size', size));
    properties.add(DiagnosticsProperty<CartStepperStyle>('style', style));
    properties.add(
      FlagProperty('enabled', value: enabled, ifFalse: 'disabled'),
    );
    properties.add(
      FlagProperty('isLoading', value: isLoading, ifTrue: 'loading'),
    );
    properties.add(
      FlagProperty(
        'enableManualInput',
        value: enableManualInput,
        ifTrue: 'manualInputEnabled',
      ),
    );
  }
}

class _CartStepperState extends State<CartStepper>
    with SingleTickerProviderStateMixin {
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
  // Operation State - Core logic for managing async operations
  // ============================================================================
  bool _isLongPressing = false;
  bool _internalLoading = false;
  int? _pendingQuantity; // Tracks quantity during async operation
  int _operationId = 0; // Unique ID for each operation to detect cancellation
  DateTime? _loadingStartTime;
  Timer? _collapseTimer;
  Completer<void>? _longPressCompleter;
  bool _longPressCompleterCompleted = false;

  // ============================================================================
  // Throttle State - Prevents rapid operations
  // ============================================================================
  DateTime? _lastOperationTime;
  Timer? _throttleTimer;
  int? _throttledQuantity;

  // ============================================================================
  // Debounce State - Batches rapid operations into one async call
  // ============================================================================
  Timer? _debounceTimer;
  int? _debouncedQuantity; // Local quantity during debounce
  int? _debounceStartQuantity; // Quantity when debounce started (for revert)

  // ============================================================================
  // Error State - For typed error handling and error builder
  // ============================================================================
  CartStepperError? _lastError;
  CartStepperOperationType? _lastOperationType;

  // ============================================================================
  // Manual Input State - For inline quantity editing
  // ============================================================================
  bool _isEditingManually = false;
  bool _isSubmittingManualInput = false; // Guard against concurrent submissions
  TextEditingController? _manualInputController;
  FocusNode? _manualInputFocusNode;

  // ============================================================================
  // Cached Colors - Avoids recreating on each build
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
  // Computed Properties
  // ============================================================================
  bool get _isLoading => widget.isLoading ?? _internalLoading;
  bool get _isAsync =>
      widget.onQuantityChangedAsync != null ||
      widget.onRemoveAsync != null ||
      widget.onAddAsync != null;
  bool get _hasOperation => _pendingQuantity != null || _internalLoading;

  // Effective quantity - shows pending value during optimistic updates or debounce
  int get _displayQuantity {
    // Debounce mode - show local debounced quantity
    if (_debouncedQuantity != null) {
      return _debouncedQuantity!;
    }
    // Optimistic update mode - show pending quantity
    if (widget.optimisticUpdate && _pendingQuantity != null) {
      return _pendingQuantity!;
    }
    return widget.quantity;
  }

  // Check if debounce mode is active
  bool get _isDebounceMode => widget.debounceDelay != null;

  // ============================================================================
  // Lifecycle
  // ============================================================================
  @override
  void initState() {
    super.initState();

    // Determine initial expanded state
    if (widget.initiallyExpanded != null) {
      _isExpanded = widget.initiallyExpanded!;
    } else {
      _isExpanded = widget.quantity > 0 && widget.autoCollapseDelay == null;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.animation.expandDuration,
    );

    _setupAnimations();

    if (_isExpanded) {
      _controller.value = 1.0;
      _resetCollapseTimer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _computeColors();
  }

  @override
  void didUpdateWidget(CartStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Recompute colors if style changed
    if (oldWidget.style != widget.style) {
      _computeColors();
    }

    // Update animation duration if changed
    if (oldWidget.animation.expandDuration != widget.animation.expandDuration) {
      _controller.duration = widget.animation.expandDuration;
    }

    // Handle quantity changes from external state
    // Only respond if NOT during our own operation (prevents race condition)
    if (widget.quantity != oldWidget.quantity && _pendingQuantity == null) {
      _handleExternalQuantityChange(oldWidget.quantity, widget.quantity);
    }

    // Handle pending state resolution
    if (_pendingQuantity != null && widget.quantity != oldWidget.quantity) {
      // External quantity changed - clear pending state
      // Whether it matches our expected value or not, accept the new value
      setState(() {
        _pendingQuantity = null;
      });
    }

    if (widget.autoCollapseDelay != oldWidget.autoCollapseDelay) {
      _resetCollapseTimer();
    }

    // Cancel manual input if enableManualInput is disabled
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
    _manualInputController?.dispose();
    _manualInputFocusNode?.removeListener(_onManualInputFocusChange);
    _manualInputFocusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ============================================================================
  // Animation Setup
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

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  // ============================================================================
  // Color Management
  // ============================================================================
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

  Color get _bgColor => _backgroundColor!;
  Color get _fgColor => _foregroundColor!;
  Color get _bdColor => _borderColor!;
  Color get _shColor => _shadowColor!;
  Color get _disabledBdColor => _disabledBorderColor!;
  Color get _splColor => _splashColor!;
  Color get _hlColor => _highlightColor!;

  // ============================================================================
  // External State Change Handling
  // ============================================================================
  void _handleExternalQuantityChange(int oldQty, int newQty) {
    if (newQty == 0) {
      if (_isExpanded && widget.autoCollapse) {
        _isExpanded = false;
        _controller.reverse();
        _collapseTimer?.cancel();
      }
    } else if (oldQty == 0) {
      // Always expand when going from 0 to something
      _isExpanded = true;
      _controller.forward();
    }

    // Reset collapse timer on any quantity change
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
  // Manual Input Handling
  // ============================================================================

  /// Starts manual input mode, showing a TextField for direct value entry.
  void _startManualInput() {
    if (!widget.enableManualInput || _isLoading || !widget.enabled) return;

    _resetCollapseTimer();
    _triggerHaptic();

    // Initialize controller and focus node if not already created
    _manualInputController ??= TextEditingController();
    if (_manualInputFocusNode == null) {
      _manualInputFocusNode = FocusNode();
      _manualInputFocusNode!.addListener(_onManualInputFocusChange);
    }

    // Set current value and select all text
    _manualInputController!.text = _displayQuantity.toString();
    _manualInputController!.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _manualInputController!.text.length,
    );

    setState(() {
      _isEditingManually = true;
    });

    // Request focus after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isEditingManually) {
        _manualInputFocusNode?.requestFocus();
      }
    });
  }

  /// Submits the manual input value, clamping it to min/max range.
  void _submitManualInput(String value) {
    // Guard against concurrent submissions from focus change + onSubmitted
    if (!_isEditingManually || _isSubmittingManualInput) return;
    _isSubmittingManualInput = true;

    final currentQty = _displayQuantity;
    int? parsedValue = int.tryParse(value.trim());

    // Handle invalid input - keep current value
    parsedValue ??= currentQty;

    // Clamp to min/max range
    final clampedValue = parsedValue.clamp(
      widget.minQuantity,
      widget.maxQuantity,
    );

    setState(() {
      _isEditingManually = false;
    });

    // Only trigger callback if value actually changed
    if (clampedValue != currentQty) {
      // Run validator if present - reject the change if validation fails
      if (!_validateChange(currentQty, clampedValue)) {
        _isSubmittingManualInput = false;
        _resetCollapseTimer();
        return;
      }

      _triggerHaptic();

      // Call the manual input submitted callback
      widget.onManualInputSubmitted?.call(clampedValue);

      // Trigger the quantity change through the appropriate callback
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
            () => widget.onQuantityChangedAsync!(clampedValue),
            operationType: CartStepperOperationType.setQuantity,
          );
        }
      } else {
        widget.onQuantityChanged?.call(clampedValue);
      }

      // Trigger min/max callbacks if applicable
      if (clampedValue >= widget.maxQuantity) {
        widget.onMaxReached?.call();
      } else if (clampedValue == widget.minQuantity) {
        widget.onMinReached?.call();
      }
    }

    _isSubmittingManualInput = false;
    _resetCollapseTimer();
  }

  /// Cancels manual input without changing the value.
  void _cancelManualInput() {
    if (!_isEditingManually) return;

    setState(() {
      _isEditingManually = false;
    });

    _resetCollapseTimer();
  }

  /// Handles focus changes for the manual input field.
  void _onManualInputFocusChange() {
    // Ensure widget is still mounted before processing focus change
    if (!mounted) return;

    if (_manualInputFocusNode != null &&
        !_manualInputFocusNode!.hasFocus &&
        _isEditingManually) {
      // Submit when focus is lost
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
    // Allow during loading only for optimistic updates
    if (_isLoading && !widget.optimisticUpdate) return false;

    final currentQty = _displayQuantity;
    final newQty = currentQty + widget.step;
    if (newQty > widget.maxQuantity) return false;

    if (checkValidator && widget.validator != null) {
      return widget.validator!(currentQty, newQty);
    }
    return true;
  }

  bool _canDecrement({bool checkValidator = true}) {
    if (!widget.enabled) return false;
    if (_isLoading && !widget.optimisticUpdate) return false;

    final currentQty = _displayQuantity;
    final newQty = currentQty - widget.step;

    if (newQty < widget.minQuantity) {
      // Allow decrement via onRemove, or via onQuantityChanged when deleteViaQuantityChange is enabled
      return widget.onRemove != null ||
          widget.onRemoveAsync != null ||
          (widget.deleteViaQuantityChange &&
              (widget.onQuantityChanged != null ||
                  widget.onQuantityChangedAsync != null));
    }

    if (checkValidator && widget.validator != null) {
      return widget.validator!(currentQty, newQty);
    }
    return true;
  }

  /// Validates a quantity change and calls onValidationRejected if rejected.
  /// Returns true if valid, false if rejected.
  bool _validateChange(int currentQty, int newQty) {
    if (widget.validator == null) return true;

    final isValid = widget.validator!(currentQty, newQty);
    if (!isValid) {
      _triggerErrorHaptic();
      widget.onValidationRejected?.call(currentQty, newQty);
    }
    return isValid;
  }

  // ============================================================================
  // Operation Cancellation
  // ============================================================================
  void _cancelAllOperations() {
    _cancelLongPress();
    _throttleTimer?.cancel();
    _throttledQuantity = null;

    // Cancel debounce operations
    _cancelDebounce();

    // Notify about cancelled operation if one was pending
    if (_pendingQuantity != null) {
      widget.onOperationCancelled?.call(_pendingQuantity!);
    }
    _pendingQuantity = null;
  }

  void _cancelLongPress() {
    _isLongPressing = false;
    // Safely complete the completer only if not already completed
    if (_longPressCompleter != null && !_longPressCompleterCompleted) {
      _longPressCompleterCompleted = true;
      _longPressCompleter!.complete();
    }
    _longPressCompleter = null;
  }

  // ============================================================================
  // Throttled Operation Handling
  // ============================================================================
  /// Throttles rapid operations and executes the last value after interval.
  void _throttledOperation(
    int targetQty,
    Future<void> Function() operation, {
    CartStepperOperationType operationType =
        CartStepperOperationType.setQuantity,
  }) {
    final now = DateTime.now();
    final throttleInterval = widget.throttleInterval;

    // If within throttle interval, queue the operation
    if (_lastOperationTime != null &&
        now.difference(_lastOperationTime!) < throttleInterval) {
      _throttledQuantity = targetQty;
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
  // Debounced Operation Handling - User-friendly async with batching
  // ============================================================================
  /// Updates local quantity immediately and debounces the async callback.
  ///
  /// This provides a smooth UX where:
  /// 1. User sees immediate feedback
  /// 2. User can rapidly adjust quantity
  /// 3. Only one async call is made after user stops interacting
  void _debouncedOperation(
    int targetQty,
    Future<void> Function(int qty) asyncCallback, {
    CartStepperOperationType operationType =
        CartStepperOperationType.setQuantity,
  }) {
    // Store start quantity if this is first debounced operation
    _debounceStartQuantity ??= widget.quantity;

    // Update local quantity immediately for UI responsiveness
    setState(() {
      _debouncedQuantity = targetQty;
      // Clear any previous error when user interacts
      if (_lastError != null) {
        _lastError = null;
      }
    });

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Start new debounce timer
    _debounceTimer = Timer(widget.debounceDelay!, () {
      if (!mounted) return;
      _executeDebouncedCallback(targetQty, asyncCallback, operationType);
    });
  }

  /// Executes the async callback after debounce delay.
  Future<void> _executeDebouncedCallback(
    int targetQty,
    Future<void> Function(int qty) asyncCallback,
    CartStepperOperationType operationType,
  ) async {
    // Note: _debounceStartQuantity is already set by _debouncedOperation
    final myOperationId = ++_operationId;

    // Set loading state
    _loadingStartTime = DateTime.now();

    // Apply show delay if configured
    if (widget.loadingConfig.showDelay > Duration.zero) {
      await Future.delayed(widget.loadingConfig.showDelay);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = true);

    try {
      await asyncCallback(targetQty);

      // Check if this operation was superseded
      if (!mounted || _operationId != myOperationId) return;

      // Success - clear debounce state
      setState(() {
        _debouncedQuantity = null;
        _debounceStartQuantity = null;
        _lastError = null;
      });

      // Call min/max callbacks if applicable
      if (targetQty >= widget.maxQuantity) {
        widget.onMaxReached?.call();
      } else if (targetQty == widget.minQuantity) {
        widget.onMinReached?.call();
      }
    } catch (error, stackTrace) {
      // Check if this operation was superseded
      if (!mounted || _operationId != myOperationId) return;

      // Create typed error
      final typedError = CartStepperOperationError(
        operationType: operationType,
        targetQuantity: targetQty,
        cause: error,
        stackTrace: stackTrace,
      );

      // Store the error for error builder
      _lastError = typedError;
      _lastOperationType = operationType;

      // Handle error via callback
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

      // Revert to start quantity on error if revertOnError is true
      if (widget.revertOnError) {
        setState(() {
          _debouncedQuantity = null;
        });
      }
      _debounceStartQuantity = null;
    }

    // Cleanup loading state
    if (!mounted || _operationId != myOperationId) return;

    // Ensure minimum loading duration for visual feedback
    final elapsed = DateTime.now().difference(_loadingStartTime!);
    if (elapsed < widget.loadingConfig.minimumDuration) {
      await Future.delayed(widget.loadingConfig.minimumDuration - elapsed);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = false);
  }

  /// Cancels any pending debounced operation.
  void _cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _debouncedQuantity = null;
    _debounceStartQuantity = null;
  }

  // ============================================================================
  // Async Operation Execution - Core async handling logic
  // ============================================================================
  Future<void> _executeAsyncOperation(
    int targetQty,
    Future<void> Function() operation, {
    CartStepperOperationType operationType =
        CartStepperOperationType.setQuantity,
  }) async {
    // Cancel any previous pending operation
    if (_pendingQuantity != null && _pendingQuantity != targetQty) {
      widget.onOperationCancelled?.call(_pendingQuantity!);
    }

    // Increment operation ID to detect if this operation gets superseded
    final myOperationId = ++_operationId;
    _lastOperationType = operationType;

    // Clear previous error and set pending quantity
    // Use setState to batch these changes and trigger rebuild if needed
    setState(() {
      _pendingQuantity = targetQty;
      if (_lastError != null) {
        _lastError = null;
      }
    });

    _loadingStartTime = DateTime.now();

    // Apply show delay if configured
    if (widget.loadingConfig.showDelay > Duration.zero) {
      await Future.delayed(widget.loadingConfig.showDelay);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = true);

    try {
      await operation();

      // Check if this operation was superseded
      if (!mounted || _operationId != myOperationId) return;

      // Success - clear pending state and error
      setState(() {
        _pendingQuantity = null;
        _lastError = null;
      });
    } catch (error, stackTrace) {
      // Check if this operation was superseded
      if (!mounted || _operationId != myOperationId) return;

      // Create typed error
      final typedError = CartStepperOperationError(
        operationType: operationType,
        targetQuantity: targetQty,
        cause: error,
        stackTrace: stackTrace,
      );

      // Store the error for error builder
      _lastError = typedError;

      // Handle error via callback
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

      // Revert optimistic update on error by clearing pending quantity
      // The widget.quantity should still be the old value since the operation failed
      if (widget.optimisticUpdate && widget.revertOnError) {
        setState(() {
          _pendingQuantity = null;
        });
      }
    }

    // Cleanup loading state
    if (!mounted || _operationId != myOperationId) return;

    // Ensure minimum loading duration for visual feedback
    final elapsed = DateTime.now().difference(_loadingStartTime!);
    if (elapsed < widget.loadingConfig.minimumDuration) {
      await Future.delayed(widget.loadingConfig.minimumDuration - elapsed);
      if (!mounted || _operationId != myOperationId) return;
    }

    setState(() => _internalLoading = false);
  }

  /// Retries the last failed operation.
  void _retryLastOperation() {
    if (_lastError == null || _lastOperationType == null) return;

    final operationType = _lastOperationType!;

    // Clear the error state with explicit setState
    setState(() {
      _lastError = null;
    });

    // Trigger appropriate action based on last operation type
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
        // For remove, we need to recalculate the target quantity
        final newQty = _displayQuantity - widget.step;
        _handleRemoval(newQty, false);
        break;
      case CartStepperOperationType.setQuantity:
      case CartStepperOperationType.reset:
        // These require external context - error was cleared above, UI will rebuild
        break;
    }
  }

  // ============================================================================
  // Increment Operation
  // ============================================================================
  void _increment({bool isLongPress = false}) {
    _resetCollapseTimer();

    // Check basic capability (without validator)
    if (!_canIncrement(checkValidator: false)) return;

    final currentQty = _displayQuantity;
    final newQty = (currentQty + widget.step).clamp(
      widget.minQuantity,
      widget.maxQuantity,
    );

    // Validate the change
    if (!_validateChange(currentQty, newQty)) return;

    _triggerHaptic();

    // Determine if this is the max
    final isMax = newQty >= widget.maxQuantity;

    if (widget.onQuantityChangedAsync != null) {
      // Debounce mode - best UX for async operations
      if (_isDebounceMode) {
        _debouncedOperation(
          newQty,
          widget.onQuantityChangedAsync!,
          operationType: CartStepperOperationType.increment,
        );
      } else {
        // Legacy throttle mode
        // For long press with async, skip if not allowed
        if (isLongPress && !widget.allowLongPressForAsync) {
          // Just do a single operation, don't queue
          if (_hasOperation) return;
        }

        _throttledOperation(newQty, () async {
          await widget.onQuantityChangedAsync!(newQty);
          if (isMax) widget.onMaxReached?.call();
        }, operationType: CartStepperOperationType.increment);
      }
    } else {
      widget.onQuantityChanged?.call(newQty);
      if (isMax) widget.onMaxReached?.call();
    }
  }

  // ============================================================================
  // Decrement Operation
  // ============================================================================
  void _decrement({bool isLongPress = false}) {
    _resetCollapseTimer();

    // Check basic capability (without validator)
    if (!_canDecrement(checkValidator: false)) return;

    final currentQty = _displayQuantity;
    final newQty = currentQty - widget.step;

    // Handle removal case (going below min)
    if (newQty < widget.minQuantity) {
      _handleRemoval(newQty, isLongPress);
      return;
    }

    // Validate the change
    if (!_validateChange(currentQty, newQty)) return;

    _triggerHaptic();

    // Determine if this is the min
    final isMin = newQty == widget.minQuantity;

    if (widget.onQuantityChangedAsync != null) {
      // Debounce mode - best UX for async operations
      if (_isDebounceMode) {
        _debouncedOperation(
          newQty,
          widget.onQuantityChangedAsync!,
          operationType: CartStepperOperationType.decrement,
        );
      } else {
        // Legacy throttle mode
        // For long press with async, skip if not allowed
        if (isLongPress && !widget.allowLongPressForAsync) {
          if (_hasOperation) return;
        }

        _throttledOperation(newQty, () async {
          await widget.onQuantityChangedAsync!(newQty);
          if (isMin) widget.onMinReached?.call();
        }, operationType: CartStepperOperationType.decrement);
      }
    } else {
      widget.onQuantityChanged?.call(newQty);
      if (isMin) widget.onMinReached?.call();
    }
  }

  // ============================================================================
  // Removal Handling
  // ============================================================================
  void _handleRemoval(int newQty, bool isLongPress) {
    _triggerHaptic();

    if (widget.onRemoveAsync != null) {
      if (isLongPress && !widget.allowLongPressForAsync && _hasOperation)
        return;
      _throttledOperation(
        newQty,
        () => widget.onRemoveAsync!(),
        operationType: CartStepperOperationType.remove,
      );
    } else if (widget.onRemove != null) {
      widget.onRemove!();
    } else if (widget.deleteViaQuantityChange) {
      if (widget.onQuantityChangedAsync != null) {
        if (isLongPress && !widget.allowLongPressForAsync && _hasOperation)
          return;
        _throttledOperation(
          newQty,
          () => widget.onQuantityChangedAsync!(newQty),
          operationType: CartStepperOperationType.remove,
        );
      } else {
        widget.onQuantityChanged?.call(newQty);
      }
    }
  }

  // ============================================================================
  // Add Button Handler
  // ============================================================================
  void _onAddPressed() {
    // If quantity > 0 but collapsed, just expand
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

    // Calculate new quantity, clamped to maxQuantity to prevent invalid values
    final newQty = (widget.minQuantity + widget.step).clamp(
      widget.minQuantity,
      widget.maxQuantity,
    );

    if (widget.onAddAsync != null) {
      _throttledOperation(newQty, () async {
        await widget.onAddAsync!();
        if (mounted) {
          setState(() => _isExpanded = true);
          _controller.forward();
        }
      }, operationType: CartStepperOperationType.add);
    } else if (widget.onAdd != null) {
      widget.onAdd!();
      setState(() => _isExpanded = true);
      _controller.forward();
    } else if (widget.onQuantityChangedAsync != null) {
      _throttledOperation(newQty, () async {
        await widget.onQuantityChangedAsync!(newQty);
        if (mounted) {
          setState(() => _isExpanded = true);
          _controller.forward();
        }
      }, operationType: CartStepperOperationType.add);
    } else {
      widget.onQuantityChanged?.call(newQty);
      setState(() => _isExpanded = true);
      _controller.forward();
    }
  }

  // ============================================================================
  // Long Press Handling
  // ============================================================================
  void _startLongPress(bool isIncrement) {
    if (!widget.enableLongPress) return;

    // Disable long press rapid fire for async unless explicitly allowed
    // Exception: debounce mode allows long press since it batches operations
    if (_isAsync && !widget.allowLongPressForAsync && !_isDebounceMode) {
      // Just do a single action instead of continuous
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
    // Apply initial delay before rapid repeating starts
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
        // For decrement during long press, stop at minQuantity (don't delete)
        if (_canDecrement() && _displayQuantity > widget.minQuantity) {
          _decrement(isLongPress: true);
        } else {
          _cancelLongPress();
          break;
        }
      }

      // Wait for the repeat interval before next increment/decrement
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

  @override
  Widget build(BuildContext context) {
    _ensureColorsInitialized();
    final qty = _displayQuantity;
    // Check capabilities without validator - validator runs on tap to provide feedback
    final canInc = _canIncrement(checkValidator: false);
    final canDec = _canDecrement(checkValidator: false);

    // Build child widgets ONCE per render cycle, not per animation frame.
    // These are passed to AnimatedBuilder's child parameter to avoid
    // rebuilding them 60 times per second during animation.
    final addButton = _buildAddButton();
    final expandedControls = _buildExpandedControls();

    // Build the main stepper widget
    Widget stepper = RepaintBoundary(
      child: Semantics(
        label:
            widget.semanticLabel ??
            'Quantity: $qty. Tap to ${qty == 0 ? 'add' : 'adjust'}',
        value: qty.toString(),
        increasedValue: canInc ? '${qty + widget.step}' : null,
        decreasedValue: canDec ? '${qty - widget.step}' : null,
        onIncrease: canInc ? () => _increment() : null,
        onDecrease: canDec ? () => _decrement() : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Only animation-dependent code here - child widgets are pre-built
            return _buildAnimatedStepper(addButton, expandedControls);
          },
          // Pass a placeholder child to satisfy the API, actual children
          // are passed directly to avoid tuple/record overhead
          child: const SizedBox.shrink(),
        ),
      ),
    );

    // Wrap with error builder if there's an error and builder is provided
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

  /// Builds the animated stepper container with pre-built child widgets.
  ///
  /// This method is called on every animation frame but only handles
  /// animation-dependent logic. The [addButton] and [expandedControls]
  /// widgets are built once per render cycle in [build].
  Widget _buildAnimatedStepper(Widget addButton, Widget expandedControls) {
    final sizeConfig = widget.size;
    final expandedWidth = sizeConfig.expandedWidth;
    final height = sizeConfig.height;

    // Calculate collapsed size based on button style
    final collapsedSize = _calculateCollapsedSize(sizeConfig);

    // Calculate current width based on animation
    final currentWidth =
        collapsedSize +
        (expandedWidth - collapsedSize) * _expandAnimation.value;

    final borderRadius = _getCollapsedBorderRadius(height);

    // For button style, use different decoration logic
    final isButtonStyle =
        widget.addToCartConfig.style == AddToCartButtonStyle.button;
    final qty = _displayQuantity;
    final showFilledBackground =
        _isExpanded ||
        _expandAnimation.value > 0 ||
        (isButtonStyle && qty == 0);

    final collapsedBg = widget.collapsedBackgroundColor ?? Colors.transparent;
    final effectiveBgColor = showFilledBackground ? _bgColor : collapsedBg;

    return Container(
      width: currentWidth,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: borderRadius,
        border: (!showFilledBackground || _expandAnimation.value < 1)
            ? Border.all(color: _bdColor, width: widget.style.borderWidth)
            : null,
        boxShadow:
            widget.style.elevation > 0 &&
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
        child: Stack(
          children: [
            // Collapsed state (Add button) - use pre-built widget
            if (_expandAnimation.value < 1)
              Positioned.fill(
                child: Opacity(
                  opacity: 1 - _expandAnimation.value,
                  child: addButton,
                ),
              ),

            // Expanded state (Stepper controls) - use pre-built widget
            if (_expandAnimation.value > 0)
              Positioned.fill(
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: expandedControls,
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _calculateCollapsedSize(CartStepperSize sizeConfig) {
    final config = widget.addToCartConfig;

    if (config.style == AddToCartButtonStyle.circleIcon) {
      return config.buttonWidth ?? sizeConfig.collapsedSize;
    }

    // For button style, calculate based on content or use custom width
    if (config.buttonWidth != null) {
      return config.buttonWidth!;
    }

    // Auto-calculate width based on text and icon
    final hasText = config.buttonText != null && config.buttonText!.isNotEmpty;
    final hasIcon = config.showIcon;

    if (!hasText && hasIcon) {
      // Icon only button
      return sizeConfig.collapsedSize + config.iconOnlyExtraWidth;
    } else if (hasText && !hasIcon) {
      // Text only button - estimate based on character count
      return (config.buttonText!.length * config.charWidthEstimate +
              config.textOnlyExtraWidth)
          .clamp(config.minTextButtonWidth, config.maxAutoWidth);
    } else {
      // Text and icon
      return (config.buttonText!.length * config.charWidthEstimate +
              config.textIconExtraWidth)
          .clamp(config.minTextIconButtonWidth, config.maxAutoWidth);
    }
  }

  BorderRadiusGeometry _getCollapsedBorderRadius(double height) {
    if (widget.style.borderRadius != null) {
      return widget.style.borderRadius!;
    }

    final config = widget.addToCartConfig;
    if (config.borderRadius != null) {
      // Interpolate between button radius and stadium during animation
      if (_expandAnimation.value > 0) {
        return BorderRadius.circular(height / 2);
      }
      return config.borderRadius!;
    }

    return BorderRadius.circular(height / 2);
  }

  Widget _buildAddButton() {
    final iconSize = widget.size.iconSize * widget.style.iconScale;
    final loadingConfig = widget.loadingConfig;
    final loadingSize = iconSize * loadingConfig.sizeMultiplier;
    final buttonConfig = widget.addToCartConfig;

    // Determine colors based on button style
    final isButtonStyle = buttonConfig.style == AddToCartButtonStyle.button;
    final defaultIconColor = widget.enabled ? _bdColor : _disabledBdColor;
    final effectiveIconColor =
        widget.collapsedForegroundColor ?? defaultIconColor;

    final iconColor = isButtonStyle ? _fgColor : effectiveIconColor;
    final loadingColor = loadingConfig.color ?? iconColor;

    final qty = _displayQuantity;
    Widget content;
    if (_isLoading && !widget.optimisticUpdate) {
      content = _buildSpinKitIndicator(
        loadingConfig.type,
        loadingSize,
        loadingColor,
      );
    } else if (qty > 0) {
      content = CartBadge(
        count: qty,
        size: 14,
        badgeColor: _bgColor,
        textColor: _fgColor,
        child: Icon(
          widget.separateIcon ?? Icons.shopping_cart,
          size: widget.separateIconSize ?? iconSize,
          color: widget.enabled ? _bdColor : _disabledBdColor,
        ),
      );
    } else if (isButtonStyle) {
      // Button style "Add to Cart"
      content = _buildButtonStyleContent(buttonConfig, iconSize, iconColor);
    } else {
      // Circle icon style (default)
      // Use Transform.rotate instead of AnimatedRotation with zero duration
      // for better performance (avoids implicit animation overhead)
      content = Transform.rotate(
        angle: _rotationAnimation.value * 2 * math.pi,
        child: Icon(
          buttonConfig.icon ?? widget.addIcon,
          size: widget.addIconSize ?? iconSize,
          color: iconColor,
        ),
      );
    }

    // Use different ink shape based on button style
    final inkShape = (isButtonStyle && qty == 0)
        ? RoundedRectangleBorder(
            borderRadius:
                buttonConfig.borderRadius ??
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
        child: Center(child: content),
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
      fontFamily: widget.style.fontFamily,
    ).merge(widget.style.textStyle);

    if (!hasText && hasIcon) {
      // Icon only
      return Icon(icon, size: iconSize, color: iconColor);
    }

    if (hasText && !hasIcon) {
      // Text only
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

    // Icon + Text
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

  Widget _buildExpandedControls() {
    final iconSize = widget.size.iconSize * widget.style.iconScale;
    final fontSize = widget.size.fontSize;
    final qty = _displayQuantity;
    final isAtMin = qty <= widget.minQuantity;
    // Show delete icon if:
    // 1. showDeleteAtMin is true AND
    // 2. quantity is at min AND
    // 3. Either onRemove exists OR deleteViaQuantityChange is enabled with onQuantityChanged
    final hasRemoveAction =
        widget.onRemove != null ||
        widget.onRemoveAsync != null ||
        (widget.deleteViaQuantityChange &&
            (widget.onQuantityChanged != null ||
                widget.onQuantityChangedAsync != null));
    final showDelete = widget.showDeleteAtMin && isAtMin && hasRemoveAction;
    final buttonsDisabled =
        _isLoading && widget.loadingConfig.disableButtonsDuringLoading;

    // Allow interaction during loading when optimistic update is enabled
    final allowInteraction =
        widget.optimisticUpdate || !_isLoading || !buttonsDisabled;

    // Check capabilities WITHOUT validator to allow tap-to-reject feedback
    // The validator runs on actual tap to trigger onValidationRejected
    final canInc = _canIncrement(checkValidator: false);
    final canDec = _canDecrement(checkValidator: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Decrement / Delete button
        StepperButton(
          icon: showDelete ? widget.deleteIcon : widget.decrementIcon,
          iconSize: showDelete
              ? (widget.deleteIconSize ?? iconSize)
              : (widget.decrementIconSize ?? iconSize),
          iconColor: _fgColor,
          enabled: widget.enabled && canDec && allowInteraction,
          onTap: () => _decrement(),
          onLongPressStart: () => _startLongPress(false),
          onLongPressEnd: _stopLongPress,
          size: widget.size.buttonTapSize,
          splashColor: _splColor,
          highlightColor: _hlColor,
        ),

        // Quantity display with loading indicator or manual input
        Expanded(child: Center(child: _buildQuantityDisplay(qty, fontSize))),

        // Increment button
        StepperButton(
          icon: widget.incrementIcon,
          iconSize: widget.incrementIconSize ?? iconSize,
          iconColor: _fgColor,
          enabled: widget.enabled && canInc && allowInteraction,
          onTap: () => _increment(),
          onLongPressStart: () => _startLongPress(true),
          onLongPressEnd: _stopLongPress,
          size: widget.size.buttonTapSize,
          splashColor: _splColor,
          highlightColor: _hlColor,
        ),
      ],
    );
  }

  /// Builds the quantity display area, which can show:
  /// - Loading indicator (during async operations)
  /// - TextField for manual input (when editing)
  /// - AnimatedCounter (default display)
  Widget _buildQuantityDisplay(int qty, double fontSize) {
    // Show loading indicator during async operations (unless optimistic update)
    if (_isLoading && !widget.optimisticUpdate) {
      return _buildLoadingIndicator();
    }

    // Show input widget when in manual input mode
    if (_isEditingManually && widget.enableManualInput) {
      // Use custom builder if provided
      if (widget.manualInputBuilder != null) {
        return widget.manualInputBuilder!(
          context,
          qty,
          _submitManualInput,
          _cancelManualInput,
        );
      }
      // Default TextField
      return _buildManualInputField(fontSize);
    }

    // Build the text style for the counter
    final textStyle = TextStyle(
      color: _fgColor,
      fontSize: fontSize,
      fontWeight: widget.style.fontWeight,
      fontFamily: widget.style.fontFamily,
    ).merge(widget.style.textStyle);

    // Default: show animated counter
    final counter = AnimatedCounter(
      value: qty,
      style: textStyle,
      duration: widget.animation.countChangeDuration,
      curve: widget.animation.countChangeCurve,
      formatter: widget.quantityFormatter,
    );

    // Wrap with input-like styling if manual input is enabled
    if (widget.enableManualInput && widget.enabled && !_isLoading) {
      return GestureDetector(
        onTap: _startManualInput,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            // Subtle background to indicate it's tappable
            color: _fgColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            // Underline to feel like an input field
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

  /// Builds the TextField for manual quantity input.
  Widget _buildManualInputField(double fontSize) {
    final textStyle = TextStyle(
      color: _fgColor,
      fontSize: fontSize,
      fontWeight: widget.style.fontWeight,
      fontFamily: widget.style.fontFamily,
    ).merge(widget.style.textStyle);

    // Use custom decoration or create a minimal one
    final decoration =
        widget.manualInputDecoration ??
        InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        );

    return Container(
      width: widget.size.expandedWidth * 0.35,
      decoration: BoxDecoration(
        // Highlighted background to show it's being edited
        color: _fgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        // Solid underline to show active editing
        border: Border(bottom: BorderSide(color: _fgColor, width: 2)),
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
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(
            widget.maxQuantity.toString().length + 1,
          ),
        ],
        onSubmitted: _submitManualInput,
        onTapOutside: (_) {
          // Submit when tapping outside
          if (_isEditingManually) {
            _submitManualInput(_manualInputController?.text ?? '');
          }
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final config = widget.loadingConfig;
    final size = widget.size.iconSize * config.sizeMultiplier;
    final color = config.color ?? _fgColor;

    if (config.customIndicator != null) {
      return SizedBox(width: size, height: size, child: config.customIndicator);
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
        // Built-in Flutter CircularProgressIndicator (no SpinKit dependency)
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      case CartStepperLoadingType.linear:
        // Built-in Flutter linear progress indicator
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
