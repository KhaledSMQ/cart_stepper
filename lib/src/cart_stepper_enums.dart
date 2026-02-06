/// Available loading indicator types using SpinKit.
///
/// Most types use the `flutter_spinkit` package, but [circular] and [linear]
/// use Flutter's built-in indicators and don't require the SpinKit dependency.
enum CartStepperLoadingType {
  /// Three bouncing dots (default, compact).
  threeBounce,

  /// Fading circle of dots.
  fadingCircle,

  /// Pulsing circle.
  pulse,

  /// Dual spinning ring.
  dualRing,

  /// Spinning circle.
  spinningCircle,

  /// Wave animation.
  wave,

  /// Chasing dots.
  chasingDots,

  /// Three dots in/out.
  threeInOut,

  /// Ring spinner.
  ring,

  /// Ripple effect.
  ripple,

  /// Fading four dots.
  fadingFour,

  /// Piano wave.
  pianoWave,

  /// Dancing square.
  dancingSquare,

  /// Cube grid.
  cubeGrid,

  /// Built-in Flutter CircularProgressIndicator (no SpinKit dependency).
  circular,

  /// Built-in Flutter linear progress indicator.
  linear,
}

/// Size variants for the stepper widget.
///
/// Each variant defines consistent dimensions for height, width, icons, and fonts.
enum CartStepperSize {
  /// Compact size - suitable for dense lists and small spaces.
  ///
  /// Height: 32px, Icon: 16px, Font: 12px
  compact(
    height: 32.0,
    collapsedSize: 32.0,
    expandedWidth: 88.0,
    iconSize: 16.0,
    fontSize: 12.0,
    buttonTapSize: 28.0,
  ),

  /// Normal size - the default for most use cases.
  ///
  /// Height: 40px, Icon: 20px, Font: 14px
  normal(
    height: 40.0,
    collapsedSize: 40.0,
    expandedWidth: 110.0,
    iconSize: 20.0,
    fontSize: 14.0,
    buttonTapSize: 36.0,
  ),

  /// Large size - for accessibility or prominent CTAs.
  ///
  /// Height: 48px, Icon: 24px, Font: 16px
  large(
    height: 48.0,
    collapsedSize: 48.0,
    expandedWidth: 132.0,
    iconSize: 24.0,
    fontSize: 16.0,
    buttonTapSize: 44.0,
  );

  /// Total height of the stepper.
  final double height;

  /// Size when collapsed (add button state).
  final double collapsedSize;

  /// Width when expanded (showing quantity controls).
  final double expandedWidth;

  /// Icon size for buttons.
  final double iconSize;

  /// Font size for quantity text.
  final double fontSize;

  /// Tap target size for increment/decrement buttons.
  final double buttonTapSize;

  const CartStepperSize({
    required this.height,
    required this.collapsedSize,
    required this.expandedWidth,
    required this.iconSize,
    required this.fontSize,
    required this.buttonTapSize,
  });
}

/// Style for the "Add to Cart" button when quantity is 0.
enum AddToCartButtonStyle {
  /// Circular icon button with + icon (default).
  circleIcon,

  /// Normal rectangular button with text and optional icon.
  button,
}

/// Layout direction for the stepper controls.
///
/// Controls whether the `[- qty +]` layout is horizontal or vertical.
enum CartStepperDirection {
  /// Horizontal layout: `[- qty +]` (default).
  horizontal,

  /// Vertical layout with increment on top, decrement on bottom.
  vertical,
}

/// Selection mode for [CartStepperGroup].
///
/// Controls how items can be selected within a group.
enum CartStepperSelectionMode {
  /// No selection behavior (default). Items work independently.
  none,

  /// Only one item can have quantity > 0 at a time (radio-style).
  single,

  /// Multiple items can have quantity > 0 (checkbox-style).
  multiple,
}
