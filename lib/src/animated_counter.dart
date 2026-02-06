import 'package:flutter/material.dart';

/// An animated counter widget that shows smooth transitions between values.
///
/// When the value changes, the old value slides out while the new value
/// slides in with a fade effect.
///
/// ## Example
/// ```dart
/// AnimatedCounter(
///   value: quantity,
///   style: TextStyle(fontSize: 16, color: Colors.white),
///   duration: Duration(milliseconds: 200),
///   curve: Curves.easeInOut,
///   formatter: (value) => value > 99 ? '99+' : '$value',
/// )
/// ```
class AnimatedCounter extends StatefulWidget {
  /// The current value to display.
  ///
  /// Supports both [int] and [double] values.
  final num value;

  /// Text style for the counter.
  final TextStyle style;

  /// Duration of the transition animation.
  final Duration duration;

  /// Curve for the animation.
  final Curve curve;

  /// Optional formatter to customize how the value is displayed.
  ///
  /// If null, the value is displayed as-is using [toString].
  /// For integer values, decimal places are not shown by default.
  final String Function(num)? formatter;

  /// Creates an animated counter.
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.formatter,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  // Cached static animation instances for non-animating state
  static const _zeroOffset = AlwaysStoppedAnimation(Offset.zero);
  static const _fullOpacity = AlwaysStoppedAnimation(1.0);

  num _currentValue = 0;
  num _previousValue = 0;
  double _slideDirection = 1.0; // 1 for up (increase), -1 for down (decrease)

  // Slide animations - recreated only when direction changes
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5),
    ));

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0),
    ));

    _updateSlideAnimations();
  }

  /// Update slide animations based on current slide direction.
  /// Called when the value changes and direction is determined.
  void _updateSlideAnimations() {
    // Slide out: from center (0,0) to off-screen in slide direction
    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, _slideDirection),
    ).animate(_controller);

    // Slide in: from off-screen opposite direction to center
    _slideInAnimation = Tween<Offset>(
      begin: Offset(0, -_slideDirection),
      end: Offset.zero,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _previousValue = _currentValue;
      _currentValue = widget.value;
      _slideDirection = _currentValue > _previousValue ? -1.0 : 1.0;

      // Recreate slide animations with new direction
      _updateSlideAnimations();
      _controller.forward(from: 0);
    }

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    // Stop any in-flight animations before disposing to prevent callbacks during disposal
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  String _format(num value) {
    if (widget.formatter != null) return widget.formatter!(value);
    // For integer values, don't show decimal places
    if (value is int || value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in RepaintBoundary to isolate repaints during animation
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final isAnimating = _controller.isAnimating;

          return ClipRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Previous value sliding out - only shown during animation
                if (isAnimating)
                  SlideTransition(
                    position: _slideOutAnimation,
                    child: FadeTransition(
                      opacity: _fadeOutAnimation,
                      child: Text(
                        _format(_previousValue),
                        style: widget.style,
                      ),
                    ),
                  ),

                // Current value sliding in (or static when not animating)
                SlideTransition(
                  // Use cached animation when not animating, proper animation otherwise
                  position: isAnimating ? _slideInAnimation : _zeroOffset,
                  child: FadeTransition(
                    opacity: isAnimating ? _fadeInAnimation : _fullOpacity,
                    child: Text(
                      _format(_currentValue),
                      style: widget.style,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
