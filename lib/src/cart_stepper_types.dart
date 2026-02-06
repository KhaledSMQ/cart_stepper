import 'dart:async';

import 'package:flutter/widgets.dart';

/// Callback type for synchronous quantity changes.
///
/// The type parameter [T] matches the quantity type of the stepper
/// (typically `int` or `double`).
typedef QuantityChangedCallback<T extends num> = void Function(T quantity);

/// Callback type for asynchronous quantity changes with loading state.
///
/// When this callback is used instead of [QuantityChangedCallback],
/// the stepper will show a loading indicator while the future completes.
typedef AsyncQuantityChangedCallback<T extends num> = Future<void> Function(
    T quantity);

/// Callback for validating quantity changes before they occur.
///
/// Return `true` to allow the change, `false` to prevent it.
typedef QuantityValidator<T extends num> = bool Function(
    T currentQuantity, T newQuantity);

/// Callback for async validation of quantity changes.
///
/// Use this for server-side stock checks or other async validations.
/// The stepper shows a loading indicator while the future completes.
/// Return `true` to allow the change, `false` to prevent it.
typedef AsyncQuantityValidator<T extends num> = Future<bool> Function(
    T currentQuantity, T newQuantity);

/// Callback for handling errors during async operations.
///
/// This is called when [onQuantityChangedAsync] or [onRemoveAsync] throws.
/// The loading state is cleaned up automatically regardless of whether
/// this callback is provided.
typedef AsyncErrorCallback = void Function(Object error, StackTrace stackTrace);

/// Callback when a quantity change is rejected by the validator.
///
/// Provides the attempted new quantity that was rejected.
/// Useful for showing feedback like "Cannot add more items".
typedef ValidationRejectedCallback<T extends num> = void Function(
    T currentQuantity, T attemptedQuantity);

/// Callback when an async operation is cancelled.
///
/// This is called when a new operation starts before the previous one completes,
/// or when the widget is disposed during an operation.
typedef OperationCancelledCallback<T extends num> = void Function(
    T attemptedQuantity);

/// Builder for a fully custom collapsed (add-to-cart) button.
///
/// When provided to the stepper's collapse config, this replaces the entire
/// default collapsed button UI. The builder receives:
/// - [context]: The build context
/// - [quantity]: The current quantity (0 when never added, >0 when collapsed with badge)
/// - [isLoading]: Whether an async operation is in progress
/// - [onTap]: The internal add handler — wire this to your widget's tap action
///
/// Example:
/// ```dart
/// collapsedBuilder: (context, qty, isLoading, onTap) {
///   return GestureDetector(
///     onTap: onTap,
///     child: isLoading
///         ? const CircularProgressIndicator()
///         : const Text('Add to Cart'),
///   );
/// }
/// ```
typedef CollapsedButtonBuilder<T extends num> = Widget Function(
  BuildContext context,
  T quantity,
  bool isLoading,
  VoidCallback onTap,
);

/// Callback with change type metadata for detailed quantity tracking.
///
/// Provides the old value, new value, and the type of change that occurred.
/// Useful for analytics, logging, or conditional behavior based on how
/// the quantity was changed.
///
/// Example:
/// ```dart
/// onDetailedQuantityChanged: (newQty, oldQty, changeType) {
///   analytics.track('quantity_changed', {
///     'from': oldQty,
///     'to': newQty,
///     'method': changeType.name,
///   });
/// }
/// ```
typedef DetailedQuantityChangedCallback<T extends num> = void Function(
  T newQuantity,
  T oldQuantity,
  QuantityChangeType changeType,
);

/// Builder for custom expanded stepper controls.
///
/// When provided, replaces the default `[- qty +]` layout with custom UI.
/// The builder receives all necessary data and callbacks to build
/// a fully custom expanded state.
///
/// Example:
/// ```dart
/// expandedBuilder: (context, qty, increment, decrement, isLoading) {
///   return Row(
///     children: [
///       IconButton(onPressed: decrement, icon: Icon(Icons.remove)),
///       Slider(value: qty.toDouble(), onChanged: (_) {}),
///       IconButton(onPressed: increment, icon: Icon(Icons.add)),
///     ],
///   );
/// }
/// ```
typedef ExpandedWidgetBuilder<T extends num> = Widget Function(
  BuildContext context,
  T quantity,
  VoidCallback increment,
  VoidCallback decrement,
  bool isLoading,
);

/// Enum representing the type of quantity change operation.
enum QuantityChangeType {
  /// User tapped increment button
  increment,

  /// User tapped decrement button
  decrement,

  /// User tapped add button (from collapsed state)
  add,

  /// User tapped delete/remove button
  remove,

  /// Long press rapid increment
  longPressIncrement,

  /// Long press rapid decrement
  longPressDecrement,

  /// Manual keyboard input
  manualInput,

  /// Programmatic change via controller
  programmatic,

  /// Change from external stream
  stream,
}
