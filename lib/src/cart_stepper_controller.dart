import 'dart:async';

import 'package:flutter/foundation.dart';

import 'cart_stepper_types.dart';

/// A controller for managing cart stepper state externally.
///
/// This controller allows you to programmatically control the cart stepper
/// and listen to state changes. It's designed to work with any state
/// management solution.
///
/// ## Basic Example (with CartStepper)
/// ```dart
/// final controller = CartStepperController(initialQuantity: 0);
///
/// CartStepper(
///   quantity: controller.quantity,
///   onQuantityChanged: controller.setQuantity,
///   onRemove: controller.reset,
/// )
/// ```
///
/// ## Async Example (with AsyncCartStepper)
/// ```dart
/// final controller = CartStepperController(
///   initialQuantity: 0,
///   onError: (error, stack) => print('Error: $error'),
/// );
///
/// AsyncCartStepper(
///   quantity: controller.quantity,
///   isLoading: controller.isLoading,
///   onQuantityChangedAsync: (qty) => controller.setQuantityAsync(
///     qty,
///     () => api.updateCart(itemId, qty),
///   ),
/// )
/// ```
///
/// ## With Riverpod
/// ```dart
/// final cartItemProvider = StateNotifierProvider<CartStepperController, int>(
///   (ref) => CartStepperController(initialQuantity: 0),
/// );
/// ```
///
/// ## With Provider
/// ```dart
/// ChangeNotifierProvider(
///   create: (_) => CartStepperController(initialQuantity: 0),
/// )
/// ```
///
/// See also:
/// - [CartStepper] for simple synchronous stepper usage
/// - [AsyncCartStepper] for async operations with loading indicators
class CartStepperController<T extends num> extends ChangeNotifier
    with DiagnosticableTreeMixin {
  T _quantity;
  bool _isExpanded;
  bool _isLoading = false;
  T? _pendingQuantity;
  int _operationId = 0;
  bool _disposed = false;

  /// Whether this controller has been disposed.
  bool get isDisposed => _disposed;

  /// Minimum allowed quantity.
  final num minQuantity;

  /// Maximum allowed quantity.
  final num maxQuantity;

  /// Step value for increment/decrement operations.
  final num step;

  /// Optional validator for quantity changes.
  final QuantityValidator<T>? validator;

  /// Optional error callback for async operations.
  final AsyncErrorCallback? onError;

  /// Optional callback when max quantity is reached.
  final VoidCallback? onMaxReached;

  /// Optional callback when min quantity is reached.
  final VoidCallback? onMinReached;

  /// Helper to convert num to T.
  T _asT(num value) {
    if (value is T) return value;
    if (T == int) return value.toInt() as T;
    if (T == double) return value.toDouble() as T;
    return value as T;
  }

  /// Creates a cart stepper controller.
  ///
  /// The [initialQuantity] is clamped between [minQuantity] and [maxQuantity].
  CartStepperController({
    required T initialQuantity,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.step = 1,
    this.validator,
    this.onError,
    this.onMaxReached,
    this.onMinReached,
  })  : assert(minQuantity > 0, 'minQuantity must be > 0'),
        assert(maxQuantity > minQuantity, 'maxQuantity must be > minQuantity'),
        assert(step > 0, 'step must be > 0'),
        _quantity = initialQuantity,
        _isExpanded = initialQuantity > 0 {
    // Clamp after initialization to avoid type issues
    _quantity = _asT(initialQuantity.clamp(minQuantity, maxQuantity));
  }

  /// Current quantity value.
  T get quantity => _quantity;

  /// Whether the stepper should be in expanded state.
  bool get isExpanded => _isExpanded;

  /// Whether an async operation is in progress.
  bool get isLoading => _isLoading;

  /// Whether there's a pending operation.
  bool get hasPendingOperation => _pendingQuantity != null;

  /// The pending quantity value (for optimistic updates).
  T? get pendingQuantity => _pendingQuantity;

  /// Effective quantity to display (pending or actual).
  T get displayQuantity => _pendingQuantity ?? _quantity;

  /// Whether increment is possible from current state.
  bool get canIncrement => !_isLoading && displayQuantity + step <= maxQuantity;

  /// Whether decrement is possible from current state.
  bool get canDecrement => !_isLoading && displayQuantity - step >= minQuantity;

  /// Whether the quantity is at the minimum value.
  bool get isAtMin => displayQuantity <= minQuantity;

  /// Whether the quantity is at the maximum value.
  bool get isAtMax => displayQuantity >= maxQuantity;

  /// Set quantity directly.
  ///
  /// The value is clamped between [minQuantity] and [maxQuantity].
  /// Notifies listeners if the value changes.
  /// If called during an async operation, the pending operation is cancelled.
  void setQuantity(T value) {
    _checkDisposed();
    final newValue = _asT(value.clamp(minQuantity, maxQuantity));

    // Cancel any pending async operation to prevent race conditions
    if (_isLoading) {
      _operationId++;
      _isLoading = false;
    }

    if (_quantity != newValue || _pendingQuantity != null) {
      _quantity = newValue;
      _isExpanded = _quantity > 0;
      _pendingQuantity = null;
      notifyListeners();
    }
  }

  /// Set quantity asynchronously with loading state management.
  ///
  /// The [operation] is the async operation to perform (e.g., API call).
  /// Optionally set [optimistic] to true to update the display immediately.
  ///
  /// Example:
  /// ```dart
  /// await controller.setQuantityAsync(
  ///   newQty,
  ///   () => api.updateCart(itemId, newQty),
  ///   optimistic: true,
  /// );
  /// ```
  Future<bool> setQuantityAsync(
    T value,
    Future<void> Function() operation, {
    bool optimistic = false,
  }) async {
    _checkDisposed();
    final newValue = _asT(value.clamp(minQuantity, maxQuantity));

    // Check validator
    if (validator != null && !validator!(_quantity, newValue)) {
      return false;
    }

    final myOperationId = ++_operationId;
    final previousQuantity = _quantity;

    if (optimistic) {
      _pendingQuantity = newValue;
    }
    _isLoading = true;
    notifyListeners();

    try {
      await operation();

      if (_operationId != myOperationId) {
        return false;
      }

      _quantity = newValue;
      _isExpanded = _quantity > 0;
      _pendingQuantity = null;

      if (_quantity >= maxQuantity) {
        onMaxReached?.call();
      } else if (_quantity <= minQuantity) {
        onMinReached?.call();
      }

      return true;
    } catch (error, stackTrace) {
      if (_operationId != myOperationId || _disposed) {
        return false;
      }

      if (optimistic) {
        _pendingQuantity = null;
        _quantity = previousQuantity;
      }

      try {
        onError?.call(error, stackTrace);
      } catch (callbackError, callbackStack) {
        assert(() {
          debugPrint(
              'CartStepperController: Error in onError callback - $callbackError');
          debugPrint('Original error: $error');
          debugPrint('Callback stack trace: $callbackStack');
          return true;
        }());
      }
      return false;
    } finally {
      if (_operationId == myOperationId && !_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Increment quantity by [step].
  ///
  /// Does nothing if already at [maxQuantity] or loading.
  void increment() {
    _checkDisposed();
    if (canIncrement) {
      final newQty = _asT(displayQuantity + step);

      if (validator != null && !validator!(displayQuantity, newQty)) {
        return;
      }

      setQuantity(newQty);
      if (_quantity >= maxQuantity) {
        onMaxReached?.call();
      }
    }
  }

  /// Increment quantity asynchronously.
  Future<bool> incrementAsync(
    Future<void> Function(T newQty) operation, {
    bool optimistic = false,
  }) async {
    _checkDisposed();
    if (!canIncrement) return false;

    final newQty = _asT(displayQuantity + step);

    if (validator != null && !validator!(displayQuantity, newQty)) {
      return false;
    }

    return setQuantityAsync(
      newQty,
      () => operation(newQty),
      optimistic: optimistic,
    );
  }

  /// Decrement quantity by [step].
  void decrement() {
    _checkDisposed();
    if (canDecrement) {
      final newQty = _asT(displayQuantity - step);

      if (validator != null && !validator!(displayQuantity, newQty)) {
        return;
      }

      setQuantity(newQty);
      if (_quantity <= minQuantity) {
        onMinReached?.call();
      }
    }
  }

  /// Decrement quantity asynchronously.
  Future<bool> decrementAsync(
    Future<void> Function(T newQty) operation, {
    bool optimistic = false,
  }) async {
    _checkDisposed();
    if (!canDecrement) return false;

    final newQty = _asT(displayQuantity - step);

    if (validator != null && !validator!(displayQuantity, newQty)) {
      return false;
    }

    return setQuantityAsync(
      newQty,
      () => operation(newQty),
      optimistic: optimistic,
    );
  }

  /// Reset to initial state (quantity = minQuantity, collapsed if minQuantity is 0).
  ///
  /// Respects [minQuantity] constraint - quantity is set to minQuantity, not 0.
  void reset() {
    _checkDisposed();
    final targetQty = _asT(minQuantity);
    if (_quantity != targetQty || _isExpanded || _pendingQuantity != null) {
      _quantity = targetQty;
      _isExpanded = targetQty > 0;
      _pendingQuantity = null;
      _isLoading = false;
      notifyListeners();

      if (_quantity <= minQuantity) {
        onMinReached?.call();
      }
    }
  }

  /// Reset asynchronously with an operation.
  ///
  /// Respects [minQuantity] constraint - quantity is set to minQuantity, not 0.
  Future<bool> resetAsync(Future<void> Function() operation) async {
    _checkDisposed();
    final myOperationId = ++_operationId;
    final targetQty = minQuantity;

    _isLoading = true;
    notifyListeners();

    try {
      await operation();

      if (_operationId != myOperationId) return false;

      _quantity = _asT(targetQty);
      _isExpanded = targetQty > 0;
      _pendingQuantity = null;

      if (_quantity <= minQuantity) {
        onMinReached?.call();
      }

      return true;
    } catch (error, stackTrace) {
      if (_operationId != myOperationId || _disposed) return false;
      try {
        onError?.call(error, stackTrace);
      } catch (callbackError, callbackStack) {
        assert(() {
          debugPrint(
              'CartStepperController: Error in onError callback - $callbackError');
          debugPrint('Original error: $error');
          debugPrint('Callback stack trace: $callbackStack');
          return true;
        }());
      }
      return false;
    } finally {
      if (_operationId == myOperationId && !_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  /// Cancel any pending async operation.
  void cancelOperation() {
    _checkDisposed();
    if (_pendingQuantity != null || _isLoading) {
      _operationId++;
      _pendingQuantity = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Expand the stepper.
  void expand() {
    _checkDisposed();
    if (!_isExpanded) {
      if (_quantity == 0) {
        _quantity = _asT(minQuantity);
      }
      _isExpanded = true;
      notifyListeners();
    }
  }

  /// Collapse the stepper and reset quantity to [minQuantity].
  void collapse() {
    _checkDisposed();
    final targetQty = _asT(minQuantity);
    if (_isExpanded || _quantity != targetQty) {
      _isExpanded = false;
      _quantity = targetQty;
      _pendingQuantity = null;
      notifyListeners();

      if (_quantity <= minQuantity) {
        onMinReached?.call();
      }
    }
  }

  /// Set quantity to [maxQuantity].
  void setToMax() {
    setQuantity(_asT(maxQuantity));
  }

  /// Set quantity to [minQuantity].
  void setToMin() {
    setQuantity(_asT(minQuantity));
  }

  /// Throws an assertion error in debug mode if this controller has been disposed.
  ///
  /// This is used internally to catch programming errors where the controller
  /// is used after being disposed.
  void _checkDisposed() {
    assert(() {
      if (_disposed) {
        throw FlutterError(
          'A $runtimeType was used after being disposed.\n'
          'Once you have called dispose() on a $runtimeType, it can no longer be used.',
        );
      }
      return true;
    }());
  }

  @override
  void dispose() {
    _disposed = true;
    // Increment operation ID to cancel any pending async operations
    _operationId++;
    _pendingQuantity = null;
    _isLoading = false;
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<num>('quantity', quantity));
    properties
        .add(DiagnosticsProperty<num>('displayQuantity', displayQuantity));
    properties.add(DiagnosticsProperty<num>('minQuantity', minQuantity));
    properties.add(DiagnosticsProperty<num>('maxQuantity', maxQuantity));
    properties.add(DiagnosticsProperty<num>('step', step));
    properties
        .add(FlagProperty('isExpanded', value: isExpanded, ifTrue: 'expanded'));
    properties
        .add(FlagProperty('isLoading', value: isLoading, ifTrue: 'loading'));
    properties.add(
        FlagProperty('canIncrement', value: canIncrement, ifFalse: 'atMax'));
    properties.add(
        FlagProperty('canDecrement', value: canDecrement, ifFalse: 'atMin'));
    properties
        .add(FlagProperty('isDisposed', value: _disposed, ifTrue: 'disposed'));
    if (_pendingQuantity != null) {
      properties
          .add(DiagnosticsProperty<num>('pendingQuantity', _pendingQuantity));
    }
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    final loading = _isLoading ? ', loading' : '';
    final pending =
        _pendingQuantity != null ? ', pending: $_pendingQuantity' : '';
    return 'CartStepperController(quantity: $_quantity, min: $minQuantity, max: $maxQuantity, step: $step$loading$pending)';
  }
}

/// Extension for easy integration with common state management patterns.
extension CartStepperControllerExtensions<T extends num>
    on CartStepperController<T> {
  /// Create a copy with different parameters.
  CartStepperController<T> copyWith({
    T? initialQuantity,
    num? minQuantity,
    num? maxQuantity,
    num? step,
    QuantityValidator<T>? validator,
    AsyncErrorCallback? onError,
    VoidCallback? onMaxReached,
    VoidCallback? onMinReached,
  }) {
    return CartStepperController<T>(
      initialQuantity: initialQuantity ?? quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      step: step ?? this.step,
      validator: validator ?? this.validator,
      onError: onError ?? this.onError,
      onMaxReached: onMaxReached ?? this.onMaxReached,
      onMinReached: onMinReached ?? this.onMinReached,
    );
  }

  /// Convert to a map for serialization.
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'step': step,
      'isExpanded': isExpanded,
      'isLoading': isLoading,
    };
  }
}

/// Extension for creating a controller from JSON.
extension CartStepperControllerFromJson on Map<String, dynamic> {
  /// Create an int-based [CartStepperController] from a JSON map.
  CartStepperController<int> toCartStepperController() {
    return CartStepperController<int>(
      initialQuantity: this['quantity'] as int? ?? 0,
      minQuantity: this['minQuantity'] as int? ?? 0,
      maxQuantity: this['maxQuantity'] as int? ?? 99,
      step: this['step'] as int? ?? 1,
    );
  }
}
