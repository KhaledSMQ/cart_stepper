import 'package:flutter/material.dart';

/// A circular button widget for increment/decrement actions.
///
/// This is used internally by [CartStepper] but can also be used
/// independently for custom stepper implementations.
///
/// ## Example
/// ```dart
/// StepperButton(
///   icon: Icons.add,
///   iconSize: 20,
///   iconColor: Colors.white,
///   enabled: true,
///   onTap: () => print('Tapped'),
///   onLongPressStart: () => print('Long press started'),
///   onLongPressEnd: () => print('Long press ended'),
///   size: 40,
///   splashColor: Colors.white24,
///   highlightColor: Colors.white12,
/// )
/// ```
class StepperButton extends StatefulWidget {
  /// The icon to display in the button.
  final IconData icon;

  /// Size of the icon.
  final double iconSize;

  /// Color of the icon when enabled.
  final Color iconColor;

  /// Whether the button is enabled and can be interacted with.
  final bool enabled;

  /// Callback when the button is tapped.
  final VoidCallback onTap;

  /// Callback when a long press starts.
  final VoidCallback onLongPressStart;

  /// Callback when a long press ends.
  final VoidCallback onLongPressEnd;

  /// Size of the button (width and height).
  final double size;

  /// Splash color for ink effect.
  final Color splashColor;

  /// Highlight color for ink effect.
  final Color highlightColor;

  /// Creates a stepper button.
  const StepperButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.enabled,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.size,
    required this.splashColor,
    required this.highlightColor,
  });

  @override
  State<StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<StepperButton> {
  bool _isLongPressing = false;
  bool _isHighlighted = false;

  @override
  void dispose() {
    // Clean up long press state if still active to prevent parent timers from running
    if (_isLongPressing) {
      _isLongPressing = false;
      widget.onLongPressEnd();
    }
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    setState(() => _isHighlighted = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isHighlighted) {
      setState(() => _isHighlighted = false);
    }
    if (!widget.enabled) return;
    if (!_isLongPressing) {
      widget.onTap();
    }
  }

  void _handleTapCancel() {
    setState(() => _isHighlighted = false);
    if (_isLongPressing) {
      _isLongPressing = false;
      widget.onLongPressEnd();
    }
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    if (!widget.enabled) return;
    _isLongPressing = true;
    widget.onLongPressStart();
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() => _isHighlighted = false);
    if (_isLongPressing) {
      _isLongPressing = false;
      widget.onLongPressEnd();
    }
  }

  void _handleLongPressCancel() {
    setState(() => _isHighlighted = false);
    if (_isLongPressing) {
      _isLongPressing = false;
      widget.onLongPressEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabledColor = widget.iconColor.withValues(alpha: 0.5);

    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onLongPressStart: widget.enabled ? _handleLongPressStart : null,
          onLongPressEnd: widget.enabled ? _handleLongPressEnd : null,
          onLongPressCancel: widget.enabled ? _handleLongPressCancel : null,
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _isHighlighted ? widget.highlightColor : Colors.transparent,
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.enabled ? widget.iconColor : disabledColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
