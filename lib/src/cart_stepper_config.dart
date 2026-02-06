import 'package:flutter/material.dart';

import 'cart_stepper_enums.dart';
import 'cart_stepper_types.dart';

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

  /// Custom text style for quantity display.
  ///
  /// When provided, overrides [fontWeight] and the size's default font size.
  final TextStyle? textStyle;

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
        other.textStyle == textStyle;
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

  /// Custom transition builder for the expanded controls animation.
  ///
  /// When provided, replaces the default opacity tween for the expanded
  /// controls (increment/quantity/decrement). The collapsed add button
  /// always uses the default opacity fade and remains visible.
  ///
  /// The [animation] parameter goes from 0.0 (collapsed) to 1.0 (expanded).
  /// The [child] is the expanded stepper controls.
  ///
  /// Example:
  /// ```dart
  /// CartStepperAnimation(
  ///   transitionBuilder: (context, animation, child) {
  ///     return ScaleTransition(scale: animation, child: child);
  ///   },
  /// )
  /// ```
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )? transitionBuilder;

  /// Creates an animation configuration.
  const CartStepperAnimation({
    this.expandDuration = const Duration(milliseconds: 250),
    this.countChangeDuration = const Duration(milliseconds: 150),
    this.expandCurve = Curves.easeOutCubic,
    this.collapseCurve = Curves.easeInCubic,
    this.countChangeCurve = Curves.easeInOut,
    this.enableHaptics = true,
    this.transitionBuilder,
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

  /// Creates a copy with the given fields replaced.
  CartStepperAnimation copyWith({
    Duration? expandDuration,
    Duration? countChangeDuration,
    Curve? expandCurve,
    Curve? collapseCurve,
    Curve? countChangeCurve,
    bool? enableHaptics,
    Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder,
  }) {
    return CartStepperAnimation(
      expandDuration: expandDuration ?? this.expandDuration,
      countChangeDuration: countChangeDuration ?? this.countChangeDuration,
      expandCurve: expandCurve ?? this.expandCurve,
      collapseCurve: collapseCurve ?? this.collapseCurve,
      countChangeCurve: countChangeCurve ?? this.countChangeCurve,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperAnimation &&
        other.expandDuration == expandDuration &&
        other.countChangeDuration == countChangeDuration &&
        other.expandCurve == expandCurve &&
        other.collapseCurve == collapseCurve &&
        other.countChangeCurve == countChangeCurve &&
        other.enableHaptics == enableHaptics &&
        other.transitionBuilder == transitionBuilder;
  }

  @override
  int get hashCode => Object.hash(
        expandDuration,
        countChangeDuration,
        expandCurve,
        collapseCurve,
        countChangeCurve,
        enableHaptics,
        transitionBuilder,
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
        other.borderRadius == borderRadius;
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
      );
}

/// Configuration for custom icons used in the stepper.
///
/// Groups all icon-related parameters. When null on [AsyncCartStepper],
/// default Material icons are used.
///
/// Example:
/// ```dart
/// AsyncCartStepper(
///   iconConfig: CartStepperIconConfig(
///     incrementIcon: Icons.arrow_upward,
///     decrementIcon: Icons.arrow_downward,
///     deleteIcon: Icons.close,
///   ),
/// )
/// ```
@immutable
class CartStepperIconConfig {
  /// Custom icon for add button (collapsed state).
  ///
  /// Defaults to [Icons.add].
  final IconData addIcon;

  /// Custom icon for increment button.
  ///
  /// Defaults to [Icons.add].
  final IconData incrementIcon;

  /// Custom icon for decrement button.
  ///
  /// Defaults to [Icons.remove].
  final IconData decrementIcon;

  /// Custom icon for delete/remove button.
  ///
  /// Defaults to [Icons.delete_outline].
  final IconData deleteIcon;

  /// Icon to show when collapsed but having items (badge mode).
  ///
  /// Shown with a quantity badge when the stepper is collapsed and
  /// quantity is greater than 0.
  ///
  /// Defaults to [Icons.shopping_cart].
  final IconData? collapsedBadgeIcon;

  /// Creates an icon configuration.
  const CartStepperIconConfig({
    this.addIcon = Icons.add,
    this.incrementIcon = Icons.add,
    this.decrementIcon = Icons.remove,
    this.deleteIcon = Icons.delete_outline,
    this.collapsedBadgeIcon,
  });

  /// Creates a copy of this configuration with the given fields replaced.
  CartStepperIconConfig copyWith({
    IconData? addIcon,
    IconData? incrementIcon,
    IconData? decrementIcon,
    IconData? deleteIcon,
    IconData? collapsedBadgeIcon,
  }) {
    return CartStepperIconConfig(
      addIcon: addIcon ?? this.addIcon,
      incrementIcon: incrementIcon ?? this.incrementIcon,
      decrementIcon: decrementIcon ?? this.decrementIcon,
      deleteIcon: deleteIcon ?? this.deleteIcon,
      collapsedBadgeIcon: collapsedBadgeIcon ?? this.collapsedBadgeIcon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperIconConfig &&
        other.addIcon == addIcon &&
        other.incrementIcon == incrementIcon &&
        other.decrementIcon == decrementIcon &&
        other.deleteIcon == deleteIcon &&
        other.collapsedBadgeIcon == collapsedBadgeIcon;
  }

  @override
  int get hashCode => Object.hash(
        addIcon,
        incrementIcon,
        decrementIcon,
        deleteIcon,
        collapsedBadgeIcon,
      );
}

/// Configuration for long-press rapid quantity changes.
///
/// Groups all long-press-related parameters. When null on [AsyncCartStepper],
/// long press is enabled with default timing.
///
/// Example:
/// ```dart
/// AsyncCartStepper(
///   longPressConfig: CartStepperLongPressConfig(
///     enabled: true,
///     interval: Duration(milliseconds: 50),
///   ),
/// )
/// ```
@immutable
class CartStepperLongPressConfig {
  /// Whether long-press enables rapid quantity changes.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Interval between quantity changes during long-press.
  ///
  /// Defaults to 100 milliseconds.
  final Duration interval;

  /// Initial delay before long-press repeat starts.
  ///
  /// Prevents accidental rapid changes from brief presses.
  /// Defaults to 400 milliseconds.
  final Duration initialDelay;

  /// Creates a long-press configuration.
  const CartStepperLongPressConfig({
    this.enabled = true,
    this.interval = const Duration(milliseconds: 100),
    this.initialDelay = const Duration(milliseconds: 400),
  });

  /// Default configuration with rapid repeating.
  static const CartStepperLongPressConfig defaultConfig =
      CartStepperLongPressConfig();

  /// Disabled long press.
  static const CartStepperLongPressConfig disabled =
      CartStepperLongPressConfig(enabled: false);

  /// Fast repeat for quick adjustments.
  static const CartStepperLongPressConfig fast = CartStepperLongPressConfig(
    interval: Duration(milliseconds: 50),
    initialDelay: Duration(milliseconds: 200),
  );

  /// Slow repeat for careful adjustments.
  static const CartStepperLongPressConfig slow = CartStepperLongPressConfig(
    interval: Duration(milliseconds: 200),
    initialDelay: Duration(milliseconds: 600),
  );

  /// Creates a copy of this configuration with the given fields replaced.
  CartStepperLongPressConfig copyWith({
    bool? enabled,
    Duration? interval,
    Duration? initialDelay,
  }) {
    return CartStepperLongPressConfig(
      enabled: enabled ?? this.enabled,
      interval: interval ?? this.interval,
      initialDelay: initialDelay ?? this.initialDelay,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperLongPressConfig &&
        other.enabled == enabled &&
        other.interval == interval &&
        other.initialDelay == initialDelay;
  }

  @override
  int get hashCode => Object.hash(enabled, interval, initialDelay);
}

/// Configuration for manual quantity input via keyboard.
///
/// Groups all manual-input-related parameters. When null,
/// manual input is disabled.
///
/// Example:
/// ```dart
/// AsyncCartStepper(
///   manualInputConfig: CartStepperManualInputConfig(
///     enabled: true,
///     onSubmitted: (value) => print('Submitted: $value'),
///   ),
/// )
/// ```
@immutable
class CartStepperManualInputConfig {
  /// Whether tapping the quantity enables manual input via keyboard.
  ///
  /// Defaults to `true` (the config existing implies the feature is wanted).
  final bool enabled;

  /// Keyboard type for manual input.
  ///
  /// Defaults to [TextInputType.number].
  final TextInputType keyboardType;

  /// Input decoration for the manual input TextField.
  ///
  /// When null, uses a minimal decoration that blends with the stepper.
  final InputDecoration? decoration;

  /// Callback when manual input is submitted.
  ///
  /// Called with the new value after clamping to min/max.
  final ValueChanged<num>? onSubmitted;

  /// Builder for custom manual input widget.
  ///
  /// When provided, this builder is used instead of the default TextField.
  final Widget Function(
    BuildContext context,
    num currentValue,
    ValueChanged<String> onSubmit,
    VoidCallback onCancel,
  )? builder;

  /// Creates a manual input configuration.
  const CartStepperManualInputConfig({
    this.enabled = true,
    this.keyboardType = TextInputType.number,
    this.decoration,
    this.onSubmitted,
    this.builder,
  });

  /// Creates a copy of this configuration with the given fields replaced.
  CartStepperManualInputConfig copyWith({
    bool? enabled,
    TextInputType? keyboardType,
    InputDecoration? decoration,
    ValueChanged<num>? onSubmitted,
    Widget Function(
      BuildContext context,
      num currentValue,
      ValueChanged<String> onSubmit,
      VoidCallback onCancel,
    )? builder,
  }) {
    return CartStepperManualInputConfig(
      enabled: enabled ?? this.enabled,
      keyboardType: keyboardType ?? this.keyboardType,
      decoration: decoration ?? this.decoration,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperManualInputConfig &&
        other.enabled == enabled &&
        other.keyboardType == keyboardType &&
        other.decoration == decoration &&
        other.onSubmitted == onSubmitted &&
        other.builder == builder;
  }

  @override
  int get hashCode => Object.hash(
        enabled,
        keyboardType,
        decoration,
        onSubmitted,
        builder,
      );
}

/// Configuration for collapse/badge behavior.
///
/// Groups all collapse-related parameters. When null on [AsyncCartStepper],
/// autoCollapse is enabled with default behavior.
///
/// Example:
/// ```dart
/// AsyncCartStepper(
///   collapseConfig: CartStepperCollapseConfig(
///     autoCollapse: true,
///     autoCollapseDelay: Duration(seconds: 3),
///   ),
/// )
/// ```
@immutable
class CartStepperCollapseConfig {
  /// Whether to auto-collapse when quantity reaches 0.
  ///
  /// Defaults to `true`.
  final bool autoCollapse;

  /// Duration after which the stepper auto-collapses if inactive.
  ///
  /// When null, the stepper stays expanded indefinitely.
  final Duration? autoCollapseDelay;

  /// Force initial expanded state.
  ///
  /// When null, auto-determines based on quantity and [autoCollapseDelay].
  final bool? initiallyExpanded;

  /// Builder for a fully custom collapsed (add-to-cart) button.
  ///
  /// When provided, replaces the entire default collapsed button UI.
  final CollapsedButtonBuilder? collapsedBuilder;

  /// Custom width for the collapsed button.
  ///
  /// When null, the width is determined by [AddToCartButtonConfig] and [CartStepperSize].
  final double? collapsedWidth;

  /// Custom height for the collapsed button.
  ///
  /// When null, the height matches [CartStepperSize].
  final double? collapsedHeight;

  /// Callback when the stepper finishes expanding.
  ///
  /// Fired when the expand animation completes (reaches fully expanded state).
  /// Useful for analytics or coordinating adjacent UI (e.g., scrolling to make room).
  final VoidCallback? onExpanded;

  /// Callback when the stepper finishes collapsing.
  ///
  /// Fired when the collapse animation completes (reaches fully collapsed state).
  /// Useful for analytics or cleanup logic.
  final VoidCallback? onCollapsed;

  /// Creates a collapse configuration.
  const CartStepperCollapseConfig({
    this.autoCollapse = true,
    this.autoCollapseDelay,
    this.initiallyExpanded,
    this.collapsedBuilder,
    this.collapsedWidth,
    this.collapsedHeight,
    this.onExpanded,
    this.onCollapsed,
  });

  /// Default configuration.
  static const CartStepperCollapseConfig defaultConfig =
      CartStepperCollapseConfig();

  /// Badge mode: auto-collapse after a delay, showing a badge icon.
  static CartStepperCollapseConfig badge({
    Duration delay = const Duration(seconds: 3),
  }) {
    return CartStepperCollapseConfig(
      autoCollapse: true,
      autoCollapseDelay: delay,
    );
  }

  /// Creates a copy of this configuration with the given fields replaced.
  CartStepperCollapseConfig copyWith({
    bool? autoCollapse,
    Duration? autoCollapseDelay,
    bool? initiallyExpanded,
    CollapsedButtonBuilder? collapsedBuilder,
    double? collapsedWidth,
    double? collapsedHeight,
    VoidCallback? onExpanded,
    VoidCallback? onCollapsed,
  }) {
    return CartStepperCollapseConfig(
      autoCollapse: autoCollapse ?? this.autoCollapse,
      autoCollapseDelay: autoCollapseDelay ?? this.autoCollapseDelay,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      collapsedBuilder: collapsedBuilder ?? this.collapsedBuilder,
      collapsedWidth: collapsedWidth ?? this.collapsedWidth,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      onExpanded: onExpanded ?? this.onExpanded,
      onCollapsed: onCollapsed ?? this.onCollapsed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperCollapseConfig &&
        other.autoCollapse == autoCollapse &&
        other.autoCollapseDelay == autoCollapseDelay &&
        other.initiallyExpanded == initiallyExpanded &&
        other.collapsedBuilder == collapsedBuilder &&
        other.collapsedWidth == collapsedWidth &&
        other.collapsedHeight == collapsedHeight &&
        other.onExpanded == onExpanded &&
        other.onCollapsed == onCollapsed;
  }

  @override
  int get hashCode => Object.hash(
        autoCollapse,
        autoCollapseDelay,
        initiallyExpanded,
        collapsedBuilder,
        collapsedWidth,
        collapsedHeight,
        onExpanded,
        onCollapsed,
      );
}

/// Configuration for async operation behavior.
///
/// Groups all async-specific behavior parameters. When null on
/// [AsyncCartStepper], sensible defaults are used.
///
/// Example:
/// ```dart
/// AsyncCartStepper(
///   asyncBehavior: CartStepperAsyncBehavior(
///     optimisticUpdate: true,
///     debounceDelay: Duration(milliseconds: 500),
///   ),
/// )
/// ```
@immutable
class CartStepperAsyncBehavior {
  /// Whether to update the UI optimistically before async operations complete.
  ///
  /// When `true`, the quantity display updates immediately and reverts
  /// if the operation fails (controlled by [revertOnError]).
  /// Defaults to `false`.
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
  final bool allowLongPressForAsync;

  /// Throttle interval for rapid operations.
  ///
  /// Prevents rapid-fire operations from overwhelming the system.
  /// Defaults to 80 milliseconds.
  final Duration throttleInterval;

  /// Debounce delay for async operations.
  ///
  /// When set, enables debounce mode: UI updates immediately (locally),
  /// and after the user stops interacting for this duration, one API call
  /// is made. Ideal for shopping carts.
  ///
  /// When null (default), async operations execute immediately.
  final Duration? debounceDelay;

  /// Creates an async behavior configuration.
  const CartStepperAsyncBehavior({
    this.optimisticUpdate = false,
    this.revertOnError = true,
    this.allowLongPressForAsync = false,
    this.throttleInterval = const Duration(milliseconds: 80),
    this.debounceDelay,
  });

  /// Default configuration with no optimistic updates and standard throttle.
  static const CartStepperAsyncBehavior defaultConfig =
      CartStepperAsyncBehavior();

  /// Optimistic configuration for instant UI feedback.
  static const CartStepperAsyncBehavior optimistic = CartStepperAsyncBehavior(
    optimisticUpdate: true,
    revertOnError: true,
  );

  /// Debounced configuration for batching rapid changes.
  static CartStepperAsyncBehavior debounced({
    Duration delay = const Duration(milliseconds: 500),
  }) {
    return CartStepperAsyncBehavior(
      debounceDelay: delay,
    );
  }

  /// Creates a copy of this configuration with the given fields replaced.
  CartStepperAsyncBehavior copyWith({
    bool? optimisticUpdate,
    bool? revertOnError,
    bool? allowLongPressForAsync,
    Duration? throttleInterval,
    Duration? debounceDelay,
  }) {
    return CartStepperAsyncBehavior(
      optimisticUpdate: optimisticUpdate ?? this.optimisticUpdate,
      revertOnError: revertOnError ?? this.revertOnError,
      allowLongPressForAsync:
          allowLongPressForAsync ?? this.allowLongPressForAsync,
      throttleInterval: throttleInterval ?? this.throttleInterval,
      debounceDelay: debounceDelay ?? this.debounceDelay,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperAsyncBehavior &&
        other.optimisticUpdate == optimisticUpdate &&
        other.revertOnError == revertOnError &&
        other.allowLongPressForAsync == allowLongPressForAsync &&
        other.throttleInterval == throttleInterval &&
        other.debounceDelay == debounceDelay;
  }

  @override
  int get hashCode => Object.hash(
        optimisticUpdate,
        revertOnError,
        allowLongPressForAsync,
        throttleInterval,
        debounceDelay,
      );
}

/// Configuration for undo-after-delete behavior.
///
/// When enabled, removing an item shows an undo prompt for a brief period.
/// If the user taps undo, the quantity is restored. If the timer expires,
/// the removal is finalized.
///
/// Example:
/// ```dart
/// AsyncCartStepper(
///   undoConfig: CartStepperUndoConfig(
///     enabled: true,
///     duration: Duration(seconds: 3),
///     builder: (context, undo) => TextButton(
///       onPressed: undo,
///       child: Text('Undo'),
///     ),
///   ),
/// )
/// ```
@immutable
class CartStepperUndoConfig {
  /// Whether undo is enabled after delete.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Duration to show the undo prompt.
  ///
  /// After this duration, the removal is finalized.
  /// Defaults to 3 seconds.
  final Duration duration;

  /// Custom builder for the undo UI.
  ///
  /// When provided, this replaces the default undo overlay.
  /// The builder receives:
  /// - [context]: The build context
  /// - [undo]: Callback to trigger undo (restores previous quantity)
  ///
  /// When null, the stepper shows a default undo indicator.
  final Widget Function(BuildContext context, VoidCallback undo)? builder;

  /// Creates an undo configuration.
  const CartStepperUndoConfig({
    this.enabled = true,
    this.duration = const Duration(seconds: 3),
    this.builder,
  });

  /// Default configuration.
  static const CartStepperUndoConfig defaultConfig = CartStepperUndoConfig();

  /// Creates a copy with the given fields replaced.
  CartStepperUndoConfig copyWith({
    bool? enabled,
    Duration? duration,
    Widget Function(BuildContext context, VoidCallback undo)? builder,
  }) {
    return CartStepperUndoConfig(
      enabled: enabled ?? this.enabled,
      duration: duration ?? this.duration,
      builder: builder ?? this.builder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperUndoConfig &&
        other.enabled == enabled &&
        other.duration == duration &&
        other.builder == builder;
  }

  @override
  int get hashCode => Object.hash(enabled, duration, builder);
}
