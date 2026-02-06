import 'package:flutter/material.dart';

import 'cart_stepper_enums.dart';

/// Configuration for loading state behavior and appearance.
///
/// This class controls how the loading indicator behaves during async operations,
/// including timing, appearance, and button behavior.
///
/// Example:
/// ```dart
/// CartStepper(
///   loadingConfig: CartStepperLoadingConfig(
///     type: CartStepperLoadingType.pulse,
///     minimumDuration: Duration(milliseconds: 500),
///   ),
/// )
/// ```
@immutable
class CartStepperLoadingConfig {
  /// Type of loading indicator to display.
  ///
  /// Defaults to [CartStepperLoadingType.threeBounce].
  final CartStepperLoadingType type;

  /// Custom loading indicator widget.
  ///
  /// When provided, this overrides [type] and displays the custom widget instead.
  final Widget? customIndicator;

  /// Duration to wait before showing the loading indicator.
  ///
  /// Useful for preventing flicker during fast operations.
  /// Defaults to [Duration.zero] (show immediately).
  final Duration showDelay;

  /// Minimum duration to display the loading indicator.
  ///
  /// Ensures visual feedback even for very fast operations.
  /// Defaults to 300 milliseconds.
  final Duration minimumDuration;

  /// Whether to disable increment/decrement buttons during loading.
  ///
  /// Defaults to `true` to prevent duplicate operations.
  final bool disableButtonsDuringLoading;

  /// Loading indicator color.
  ///
  /// When null, uses the stepper's foreground color.
  final Color? color;

  /// Size multiplier for the loading indicator relative to icon size.
  ///
  /// A value of 1.0 matches the icon size exactly.
  /// Defaults to 0.8.
  final double sizeMultiplier;

  /// Creates a loading configuration.
  const CartStepperLoadingConfig({
    this.type = CartStepperLoadingType.threeBounce,
    this.customIndicator,
    this.showDelay = Duration.zero,
    this.minimumDuration = const Duration(milliseconds: 300),
    this.disableButtonsDuringLoading = true,
    this.color,
    this.sizeMultiplier = 0.8,
  });

  /// Default configuration optimized for cart operations.
  static const CartStepperLoadingConfig defaultConfig =
      CartStepperLoadingConfig();

  /// Fast feedback configuration with reduced minimum duration.
  static const CartStepperLoadingConfig fast = CartStepperLoadingConfig(
    type: CartStepperLoadingType.pulse,
    minimumDuration: Duration(milliseconds: 150),
    sizeMultiplier: 0.7,
  );

  /// Subtle configuration for quick operations.
  static const CartStepperLoadingConfig subtle = CartStepperLoadingConfig(
    type: CartStepperLoadingType.fadingFour,
    minimumDuration: Duration(milliseconds: 200),
    sizeMultiplier: 0.6,
  );

  /// Built-in configuration that doesn't require SpinKit dependency.
  static const CartStepperLoadingConfig builtIn = CartStepperLoadingConfig(
    type: CartStepperLoadingType.circular,
    minimumDuration: Duration(milliseconds: 200),
    sizeMultiplier: 0.7,
  );

  /// Creates a copy of this configuration with the given fields replaced.
  CartStepperLoadingConfig copyWith({
    CartStepperLoadingType? type,
    Widget? customIndicator,
    Duration? showDelay,
    Duration? minimumDuration,
    bool? disableButtonsDuringLoading,
    Color? color,
    double? sizeMultiplier,
  }) {
    return CartStepperLoadingConfig(
      type: type ?? this.type,
      customIndicator: customIndicator ?? this.customIndicator,
      showDelay: showDelay ?? this.showDelay,
      minimumDuration: minimumDuration ?? this.minimumDuration,
      disableButtonsDuringLoading:
          disableButtonsDuringLoading ?? this.disableButtonsDuringLoading,
      color: color ?? this.color,
      sizeMultiplier: sizeMultiplier ?? this.sizeMultiplier,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperLoadingConfig &&
        other.type == type &&
        other.customIndicator == customIndicator &&
        other.showDelay == showDelay &&
        other.minimumDuration == minimumDuration &&
        other.disableButtonsDuringLoading == disableButtonsDuringLoading &&
        other.color == color &&
        other.sizeMultiplier == sizeMultiplier;
  }

  @override
  int get hashCode => Object.hash(
    type,
    customIndicator,
    showDelay,
    minimumDuration,
    disableButtonsDuringLoading,
    color,
    sizeMultiplier,
  );
}

/// Visual styling configuration for [CartStepper].
///
/// Use this class to customize colors, borders, shadows, and text appearance.
///
/// Example:
/// ```dart
/// CartStepper(
///   style: CartStepperStyle(
///     backgroundColor: Colors.blue,
///     foregroundColor: Colors.white,
///     elevation: 4.0,
///   ),
/// )
/// ```
@immutable
class CartStepperStyle {
  /// Background color of the stepper container.
  ///
  /// When null, uses [Theme.of(context).primaryColor].
  final Color? backgroundColor;

  /// Foreground/icon color.
  ///
  /// When null, uses [Theme.of(context).colorScheme.onPrimary].
  final Color? foregroundColor;

  /// Border color when collapsed (add button state).
  ///
  /// When null, uses [backgroundColor].
  final Color? borderColor;

  /// Border width in logical pixels.
  ///
  /// Defaults to 2.0.
  final double borderWidth;

  /// Shadow elevation.
  ///
  /// Higher values create larger shadows. Defaults to 2.0.
  final double elevation;

  /// Shadow color.
  ///
  /// When null, uses [backgroundColor] with 30% opacity.
  final Color? shadowColor;

  /// Icon size multiplier.
  ///
  /// A value of 1.0 uses the default size for the [CartStepperSize].
  /// Defaults to 1.0.
  final double iconScale;

  /// Font weight for quantity text.
  ///
  /// Defaults to [FontWeight.w600].
  final FontWeight fontWeight;

  /// Custom border radius.
  ///
  /// When null, uses a stadium shape (fully rounded ends).
  final BorderRadiusGeometry? borderRadius;

  /// Custom text style for query display.
  ///
  /// When provided, overrides [fontWeight] and the size's default font size.
  final TextStyle? textStyle;

  /// Font family for the displayed text.
  final String? fontFamily;

  /// Creates a visual style configuration.
  const CartStepperStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.elevation = 2.0,
    this.shadowColor,
    this.iconScale = 1.0,
    this.fontWeight = FontWeight.w600,
    this.borderRadius,
    this.textStyle,
    this.fontFamily,
  });

  /// Default orange theme matching common e-commerce designs.
  static const CartStepperStyle defaultOrange = CartStepperStyle(
    backgroundColor: Color(0xFFD84315),
    foregroundColor: Colors.white,
    borderColor: Color(0xFFD84315),
    borderWidth: 2.0,
    elevation: 2.0,
  );

  /// Dark theme variant for dark mode UIs.
  static const CartStepperStyle dark = CartStepperStyle(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    borderColor: Color(0xFF424242),
    borderWidth: 2.0,
    elevation: 4.0,
  );

  /// Light/minimal theme for subtle integration.
  static const CartStepperStyle light = CartStepperStyle(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFFD84315),
    borderColor: Color(0xFFE0E0E0),
    borderWidth: 1.5,
    elevation: 1.0,
  );

  /// Creates a style from Flutter's [ColorScheme].
  ///
  /// This is useful for maintaining consistency with your app's theme.
  ///
  /// Example:
  /// ```dart
  /// CartStepper(
  ///   style: CartStepperStyle.fromColorScheme(
  ///     Theme.of(context).colorScheme,
  ///   ),
  /// )
  /// ```
  static CartStepperStyle fromColorScheme(ColorScheme scheme) {
    return CartStepperStyle(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      borderColor: scheme.primary,
    );
  }

  /// Creates a copy of this style with the given fields replaced.
  CartStepperStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    Color? shadowColor,
    double? iconScale,
    FontWeight? fontWeight,
    BorderRadiusGeometry? borderRadius,
    TextStyle? textStyle,
    String? fontFamily,
  }) {
    return CartStepperStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      iconScale: iconScale ?? this.iconScale,
      fontWeight: fontWeight ?? this.fontWeight,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.elevation == elevation &&
        other.shadowColor == shadowColor &&
        other.iconScale == iconScale &&
        other.fontWeight == fontWeight &&
        other.borderRadius == borderRadius &&
        other.textStyle == textStyle &&
        other.fontFamily == fontFamily;
  }

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    borderColor,
    borderWidth,
    elevation,
    shadowColor,
    iconScale,
    fontWeight,
    borderRadius,
    textStyle,
    fontFamily,
  );
}

/// Animation configuration for [CartStepper].
///
/// Controls the timing and curves for expand/collapse and quantity animations.
@immutable
class CartStepperAnimation {
  /// Duration of expand/collapse animation.
  ///
  /// Defaults to 250 milliseconds.
  final Duration expandDuration;

  /// Duration of quantity change animation.
  ///
  /// Defaults to 150 milliseconds.
  final Duration countChangeDuration;

  /// Animation curve for expanding.
  ///
  /// Defaults to [Curves.easeOutCubic].
  final Curve expandCurve;

  /// Animation curve for collapsing.
  ///
  /// Defaults to [Curves.easeInCubic].
  final Curve collapseCurve;

  /// Animation curve for quantity number changes.
  ///
  /// Defaults to [Curves.easeInOut].
  final Curve countChangeCurve;

  /// Whether to trigger haptic feedback on interactions.
  ///
  /// Defaults to `true`.
  final bool enableHaptics;

  /// Creates an animation configuration.
  const CartStepperAnimation({
    this.expandDuration = const Duration(milliseconds: 250),
    this.countChangeDuration = const Duration(milliseconds: 150),
    this.expandCurve = Curves.easeOutCubic,
    this.collapseCurve = Curves.easeInCubic,
    this.countChangeCurve = Curves.easeInOut,
    this.enableHaptics = true,
  });

  /// Fast animation preset for snappy interactions.
  static const CartStepperAnimation fast = CartStepperAnimation(
    expandDuration: Duration(milliseconds: 150),
    countChangeDuration: Duration(milliseconds: 100),
  );

  /// Smooth animation preset with bounce effect.
  static const CartStepperAnimation smooth = CartStepperAnimation(
    expandDuration: Duration(milliseconds: 350),
    countChangeDuration: Duration(milliseconds: 200),
    expandCurve: Curves.easeOutBack,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperAnimation &&
        other.expandDuration == expandDuration &&
        other.countChangeDuration == countChangeDuration &&
        other.expandCurve == expandCurve &&
        other.collapseCurve == collapseCurve &&
        other.countChangeCurve == countChangeCurve &&
        other.enableHaptics == enableHaptics;
  }

  @override
  int get hashCode => Object.hash(
    expandDuration,
    countChangeDuration,
    expandCurve,
    collapseCurve,
    countChangeCurve,
    enableHaptics,
  );
}

/// Configuration for the "Add to Cart" button appearance.
///
/// Controls the button style, text, icon, and layout when the stepper
/// is in its collapsed state (quantity is 0).
@immutable
class AddToCartButtonConfig {
  /// Button style (circle icon or normal button).
  final AddToCartButtonStyle style;

  /// Text to display on the button (only for [AddToCartButtonStyle.button]).
  final String? buttonText;

  /// Icon to show.
  ///
  /// Defaults to [Icons.add] for circle style, [Icons.add_shopping_cart] for button.
  final IconData? icon;

  /// Whether to show the icon on the button (only for button style).
  final bool showIcon;

  /// Icon position for button style (before or after text).
  ///
  /// When `true`, icon appears before text. Defaults to `true`.
  final bool iconLeading;

  /// Custom width for button style.
  ///
  /// When null, width is calculated based on content.
  final double? buttonWidth;

  /// Button padding (only for button style).
  final EdgeInsetsGeometry? padding;

  /// Custom border radius for the button.
  ///
  /// When null, uses the stepper's default border radius.
  final BorderRadiusGeometry? borderRadius;

  // Auto-sizing parameters

  /// Extra width constant for icon-only button (added to collapsed size).
  ///
  /// Defaults to 16.0.
  final double iconOnlyExtraWidth;

  /// Estimated width per character for text width calculation.
  ///
  /// Defaults to 8.0.
  final double charWidthEstimate;

  /// Extra width constant for text-only button.
  ///
  /// Defaults to 24.0.
  final double textOnlyExtraWidth;

  /// Extra width constant for text + icon button.
  ///
  /// Defaults to 48.0.
  final double textIconExtraWidth;

  /// Minimum width constraint for text-only button.
  ///
  /// Defaults to 60.0.
  final double minTextButtonWidth;

  /// Minimum width constraint for text + icon button.
  ///
  /// Defaults to 80.0.
  final double minTextIconButtonWidth;

  /// Maximum width constraint for auto-calculated width.
  ///
  /// Defaults to 200.0.
  final double maxAutoWidth;

  /// Creates a button configuration.
  const AddToCartButtonConfig({
    this.style = AddToCartButtonStyle.circleIcon,
    this.buttonText,
    this.icon,
    this.showIcon = true,
    this.iconLeading = true,
    this.buttonWidth,
    this.padding,
    this.borderRadius,
    this.iconOnlyExtraWidth = 16.0,
    this.charWidthEstimate = 8.0,
    this.textOnlyExtraWidth = 24.0,
    this.textIconExtraWidth = 48.0,
    this.minTextButtonWidth = 60.0,
    this.minTextIconButtonWidth = 80.0,
    this.maxAutoWidth = 200.0,
  });

  /// Default circle icon configuration.
  static const AddToCartButtonConfig circleIcon = AddToCartButtonConfig(
    style: AddToCartButtonStyle.circleIcon,
  );

  /// Default button configuration with "Add" text.
  static const AddToCartButtonConfig addButton = AddToCartButtonConfig(
    style: AddToCartButtonStyle.button,
    buttonText: 'Add',
    icon: Icons.add,
    showIcon: true,
  );

  /// Button with cart icon and text.
  static const AddToCartButtonConfig addToCartButton = AddToCartButtonConfig(
    style: AddToCartButtonStyle.button,
    buttonText: 'Add to Cart',
    icon: Icons.add_shopping_cart,
    showIcon: true,
  );

  /// Compact button with just icon.
  static const AddToCartButtonConfig iconOnlyButton = AddToCartButtonConfig(
    style: AddToCartButtonStyle.button,
    buttonText: null,
    icon: Icons.add_shopping_cart,
    showIcon: true,
  );

  /// Creates a copy of this configuration with the given fields replaced.
  AddToCartButtonConfig copyWith({
    AddToCartButtonStyle? style,
    String? buttonText,
    IconData? icon,
    bool? showIcon,
    bool? iconLeading,
    double? buttonWidth,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    double? iconOnlyExtraWidth,
    double? charWidthEstimate,
    double? textOnlyExtraWidth,
    double? textIconExtraWidth,
    double? minTextButtonWidth,
    double? minTextIconButtonWidth,
    double? maxAutoWidth,
  }) {
    return AddToCartButtonConfig(
      style: style ?? this.style,
      buttonText: buttonText ?? this.buttonText,
      icon: icon ?? this.icon,
      showIcon: showIcon ?? this.showIcon,
      iconLeading: iconLeading ?? this.iconLeading,
      buttonWidth: buttonWidth ?? this.buttonWidth,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      iconOnlyExtraWidth: iconOnlyExtraWidth ?? this.iconOnlyExtraWidth,
      charWidthEstimate: charWidthEstimate ?? this.charWidthEstimate,
      textOnlyExtraWidth: textOnlyExtraWidth ?? this.textOnlyExtraWidth,
      textIconExtraWidth: textIconExtraWidth ?? this.textIconExtraWidth,
      minTextButtonWidth: minTextButtonWidth ?? this.minTextButtonWidth,
      minTextIconButtonWidth:
          minTextIconButtonWidth ?? this.minTextIconButtonWidth,
      maxAutoWidth: maxAutoWidth ?? this.maxAutoWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddToCartButtonConfig &&
        other.style == style &&
        other.buttonText == buttonText &&
        other.icon == icon &&
        other.showIcon == showIcon &&
        other.iconLeading == iconLeading &&
        other.buttonWidth == buttonWidth &&
        other.padding == padding &&
        other.borderRadius == borderRadius &&
        other.iconOnlyExtraWidth == iconOnlyExtraWidth &&
        other.charWidthEstimate == charWidthEstimate &&
        other.textOnlyExtraWidth == textOnlyExtraWidth &&
        other.textIconExtraWidth == textIconExtraWidth &&
        other.minTextButtonWidth == minTextButtonWidth &&
        other.minTextIconButtonWidth == minTextIconButtonWidth &&
        other.maxAutoWidth == maxAutoWidth;
  }

  @override
  int get hashCode => Object.hash(
    style,
    buttonText,
    icon,
    showIcon,
    iconLeading,
    buttonWidth,
    padding,
    borderRadius,
    iconOnlyExtraWidth,
    charWidthEstimate,
    textOnlyExtraWidth,
    textIconExtraWidth,
    minTextButtonWidth,
    minTextIconButtonWidth,
    maxAutoWidth,
  );
}
