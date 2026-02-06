import 'package:flutter/foundation.dart';

/// Base class for all CartStepper errors.
///
/// This provides a typed error hierarchy for better error handling
/// in async operations.
sealed class CartStepperError implements Exception {
  /// Human-readable error message.
  final String message;

  /// The original error that caused this exception, if any.
  final Object? cause;

  /// Stack trace from the original error.
  final StackTrace? stackTrace;

  const CartStepperError(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => 'CartStepperError: $message';
}

/// Error thrown when a quantity validation fails.
///
/// This is thrown when the [validator] callback returns false,
/// preventing the quantity change.
class CartStepperValidationError extends CartStepperError {
  /// The quantity before the attempted change.
  final int currentQuantity;

  /// The quantity that was attempted but rejected.
  final int attemptedQuantity;

  /// The reason for validation failure, if provided.
  final String? reason;

  const CartStepperValidationError({
    required this.currentQuantity,
    required this.attemptedQuantity,
    this.reason,
  }) : super(
          reason ??
              'Validation failed: cannot change from $currentQuantity to $attemptedQuantity',
        );

  @override
  String toString() =>
      'CartStepperValidationError: $message (current: $currentQuantity, attempted: $attemptedQuantity)';
}

/// Error thrown when an async operation fails.
///
/// Wraps the original error with context about what operation failed.
class CartStepperOperationError extends CartStepperError {
  /// The type of operation that failed.
  final CartStepperOperationType operationType;

  /// The quantity that was being set when the error occurred.
  final num? targetQuantity;

  CartStepperOperationError({
    required this.operationType,
    this.targetQuantity,
    required Object cause,
    StackTrace? stackTrace,
  }) : super(
          _buildOperationMessage(operationType, targetQuantity),
          cause: cause,
          stackTrace: stackTrace,
        );

  static String _buildOperationMessage(
    CartStepperOperationType operationType,
    num? targetQuantity,
  ) {
    final base = 'Operation ${operationType.name} failed';
    return targetQuantity != null ? '$base (target: $targetQuantity)' : base;
  }

  @override
  String toString() =>
      'CartStepperOperationError: ${operationType.name} failed - $cause';
}

/// Error thrown when an operation times out.
class CartStepperTimeoutError extends CartStepperError {
  /// The duration after which the operation timed out.
  final Duration timeout;

  /// The type of operation that timed out.
  final CartStepperOperationType operationType;

  CartStepperTimeoutError({
    required this.timeout,
    required this.operationType,
  }) : super(
          'Operation ${operationType.name} timed out after ${timeout.inMilliseconds}ms',
        );

  @override
  String toString() => 'CartStepperTimeoutError: $message';
}

/// Error thrown when an operation is cancelled.
class CartStepperCancellationError extends CartStepperError {
  /// The quantity that was being set when cancelled.
  final int attemptedQuantity;

  /// The reason for cancellation.
  final CancellationReason reason;

  CartStepperCancellationError({
    required this.attemptedQuantity,
    required this.reason,
  }) : super('Operation cancelled: ${reason.description}');

  @override
  String toString() =>
      'CartStepperCancellationError: $message (attempted: $attemptedQuantity)';
}

/// Error thrown when trying to perform an operation while another is in progress.
class CartStepperBusyError extends CartStepperError {
  /// The quantity of the pending operation.
  final int? pendingQuantity;

  const CartStepperBusyError({this.pendingQuantity})
      : super(
          'Cannot perform operation: another operation is in progress${pendingQuantity != null ? ' (pending: $pendingQuantity)' : ''}',
        );

  @override
  String toString() => 'CartStepperBusyError: $message';
}

/// Types of operations that can fail.
enum CartStepperOperationType {
  /// Increment operation
  increment,

  /// Decrement operation
  decrement,

  /// Add to cart operation (from collapsed state)
  add,

  /// Remove from cart operation
  remove,

  /// Direct quantity set operation
  setQuantity,

  /// Reset operation
  reset,
}

/// Reasons for operation cancellation.
enum CancellationReason {
  /// A new operation superseded this one.
  superseded('superseded by new operation'),

  /// The widget was disposed during the operation.
  disposed('widget was disposed'),

  /// The user manually cancelled the operation.
  userCancelled('cancelled by user'),

  /// The operation was cancelled due to a validation failure.
  validationFailed('validation failed');

  final String description;

  const CancellationReason(this.description);
}

/// Extension to create typed errors from raw errors.
extension CartStepperErrorFactory on Object {
  /// Wraps this error in a [CartStepperOperationError].
  CartStepperOperationError asOperationError({
    required CartStepperOperationType operationType,
    num? targetQuantity,
    StackTrace? stackTrace,
  }) {
    return CartStepperOperationError(
      operationType: operationType,
      targetQuantity: targetQuantity,
      cause: this,
      stackTrace: stackTrace,
    );
  }
}

/// Result of an async operation.
///
/// This sealed class provides a type-safe way to handle operation results.
sealed class OperationResult<T> {
  const OperationResult();
}

/// Successful operation result.
class OperationSuccess<T> extends OperationResult<T> {
  /// The result value.
  final T value;

  const OperationSuccess(this.value);
}

/// Failed operation result.
class OperationFailure<T> extends OperationResult<T> {
  /// The error that caused the failure.
  final CartStepperError error;

  const OperationFailure(this.error);
}

/// Mixin that provides error handling utilities for debugging.
mixin CartStepperErrorDiagnostics on DiagnosticableTreeMixin {
  /// Adds error properties to diagnostics.
  void addErrorDiagnostics(
    DiagnosticPropertiesBuilder properties,
    CartStepperError? lastError,
  ) {
    if (lastError != null) {
      properties.add(StringProperty('lastError', lastError.message));
      if (lastError.cause != null) {
        properties
            .add(StringProperty('errorCause', lastError.cause.toString()));
      }
    }
  }
}
