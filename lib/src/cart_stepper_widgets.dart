import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cart_stepper.dart';
import 'cart_stepper_config.dart';
import 'cart_stepper_enums.dart';
import 'cart_stepper_types.dart';

/// Provides theme-based styling for [CartStepper] widgets in a subtree.
///
/// Wrap your widget tree with [CartStepperTheme] to provide consistent
/// styling to all [ThemedCartStepper] widgets within.
///
/// Example:
/// ```dart
/// CartStepperTheme(
///   data: CartStepperThemeData(
///     style: CartStepperStyle.defaultOrange,
///     size: CartStepperSize.normal,
///     longPressConfig: CartStepperLongPressConfig(enabled: true),
///     collapseConfig: CartStepperCollapseConfig(
///       autoCollapseDelay: Duration(seconds: 5),
///     ),
///   ),
///   child: Column(
///     children: [
///       ThemedCartStepper(quantity: 1, onQuantityChanged: (_) {}),
///       ThemedCartStepper(quantity: 2, onQuantityChanged: (_) {}),
///     ],
///   ),
/// )
/// ```
///
/// See also:
/// - [ThemedCartStepper] which uses this theme
/// - [CartStepperThemeData] for available theme properties
class CartStepperTheme extends InheritedWidget {
  /// The theme data to apply to descendant steppers.
  final CartStepperThemeData data;

  /// Creates a cart stepper theme.
  const CartStepperTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns the theme data from the closest [CartStepperTheme] ancestor.
  ///
  /// Returns null if there is no ancestor.
  static CartStepperThemeData? maybeOf(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<CartStepperTheme>();
    return theme?.data;
  }

  /// Returns the theme data from the closest [CartStepperTheme] ancestor.
  ///
  /// Throws an assertion error if there is no ancestor.
  static CartStepperThemeData of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No CartStepperTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CartStepperTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for [CartStepper] widgets.
///
/// Uses config objects for consistent grouping of related properties.
/// Simple boolean flags are kept flat for convenience.
///
/// Use this with [CartStepperTheme] to style multiple steppers consistently.
@immutable
class CartStepperThemeData {
  /// Visual style configuration.
  final CartStepperStyle style;

  /// Size variant.
  final CartStepperSize size;

  /// Animation configuration.
  final CartStepperAnimation animation;

  /// Whether to show delete icon at minimum quantity.
  final bool showDeleteAtMin;

  /// Whether delete triggers onQuantityChanged instead of onRemove.
  final bool deleteViaQuantityChange;

  /// Long-press behavior configuration.
  final CartStepperLongPressConfig? longPressConfig;

  /// Collapse/expand behavior configuration.
  final CartStepperCollapseConfig? collapseConfig;

  /// Icon customization configuration.
  final CartStepperIconConfig? iconConfig;

  /// Manual input configuration.
  final CartStepperManualInputConfig? manualInputConfig;

  /// Async behavior configuration (debounce, throttle, optimistic updates).
  final CartStepperAsyncBehavior? asyncBehavior;

  /// Loading indicator configuration.
  final CartStepperLoadingConfig? loadingConfig;

  /// Add-to-cart button configuration.
  final AddToCartButtonConfig? addToCartConfig;

  /// Creates theme data for cart steppers.
  const CartStepperThemeData({
    this.style = CartStepperStyle.defaultOrange,
    this.size = CartStepperSize.normal,
    this.animation = const CartStepperAnimation(),
    this.showDeleteAtMin = true,
    this.deleteViaQuantityChange = false,
    this.longPressConfig,
    this.collapseConfig,
    this.iconConfig,
    this.manualInputConfig,
    this.asyncBehavior,
    this.loadingConfig,
    this.addToCartConfig,
  });

  /// Creates a copy with the given fields replaced.
  CartStepperThemeData copyWith({
    CartStepperStyle? style,
    CartStepperSize? size,
    CartStepperAnimation? animation,
    bool? showDeleteAtMin,
    bool? deleteViaQuantityChange,
    CartStepperLongPressConfig? longPressConfig,
    CartStepperCollapseConfig? collapseConfig,
    CartStepperIconConfig? iconConfig,
    CartStepperManualInputConfig? manualInputConfig,
    CartStepperAsyncBehavior? asyncBehavior,
    CartStepperLoadingConfig? loadingConfig,
    AddToCartButtonConfig? addToCartConfig,
  }) {
    return CartStepperThemeData(
      style: style ?? this.style,
      size: size ?? this.size,
      animation: animation ?? this.animation,
      showDeleteAtMin: showDeleteAtMin ?? this.showDeleteAtMin,
      deleteViaQuantityChange:
          deleteViaQuantityChange ?? this.deleteViaQuantityChange,
      longPressConfig: longPressConfig ?? this.longPressConfig,
      collapseConfig: collapseConfig ?? this.collapseConfig,
      iconConfig: iconConfig ?? this.iconConfig,
      manualInputConfig: manualInputConfig ?? this.manualInputConfig,
      asyncBehavior: asyncBehavior ?? this.asyncBehavior,
      loadingConfig: loadingConfig ?? this.loadingConfig,
      addToCartConfig: addToCartConfig ?? this.addToCartConfig,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperThemeData &&
        other.style == style &&
        other.size == size &&
        other.animation == animation &&
        other.showDeleteAtMin == showDeleteAtMin &&
        other.deleteViaQuantityChange == deleteViaQuantityChange &&
        other.longPressConfig == longPressConfig &&
        other.collapseConfig == collapseConfig &&
        other.iconConfig == iconConfig &&
        other.manualInputConfig == manualInputConfig &&
        other.asyncBehavior == asyncBehavior &&
        other.loadingConfig == loadingConfig &&
        other.addToCartConfig == addToCartConfig;
  }

  @override
  int get hashCode => Object.hash(
        style,
        size,
        animation,
        showDeleteAtMin,
        deleteViaQuantityChange,
        longPressConfig,
        collapseConfig,
        iconConfig,
        manualInputConfig,
        asyncBehavior,
        loadingConfig,
        addToCartConfig,
      );

  @override
  String toString() {
    return 'CartStepperThemeData(style: $style, size: $size)';
  }
}

/// A [CartStepper] that automatically uses theme from [CartStepperTheme].
///
/// This widget looks up the nearest [CartStepperTheme] and applies its
/// settings, with local overrides taking precedence.
///
/// The type parameter [T] defaults to [int] for backward compatibility.
///
/// Example:
/// ```dart
/// CartStepperTheme(
///   data: CartStepperThemeData(
///     style: CartStepperStyle(backgroundColor: Colors.blue),
///   ),
///   child: ThemedCartStepper(
///     quantity: 5,
///     onQuantityChanged: (qty) => print(qty),
///   ),
/// )
/// ```
///
/// See also:
/// - [CartStepperTheme] for providing theme data
/// - [CartStepper] for the underlying widget
class ThemedCartStepper<T extends num> extends StatelessWidget {
  /// Current quantity value.
  final T quantity;

  /// Synchronous callback when quantity changes.
  final QuantityChangedCallback<T>? onQuantityChanged;

  /// Asynchronous callback when quantity changes.
  final AsyncQuantityChangedCallback<T>? onQuantityChangedAsync;

  /// Callback when item should be removed.
  final VoidCallback? onRemove;

  /// Async callback when item should be removed.
  final Future<void> Function()? onRemoveAsync;

  /// Callback when add button is pressed.
  final VoidCallback? onAdd;

  /// Async callback when add button is pressed.
  final Future<void> Function()? onAddAsync;

  /// Minimum allowed quantity.
  final num minQuantity;

  /// Maximum allowed quantity.
  final num maxQuantity;

  /// Step value for increment/decrement.
  final num step;

  /// Size variant (overrides theme).
  final CartStepperSize? size;

  /// Visual style (overrides theme).
  final CartStepperStyle? style;

  /// Animation configuration (overrides theme).
  final CartStepperAnimation? animation;

  /// Loading configuration (overrides theme).
  final CartStepperLoadingConfig? loadingConfig;

  /// Long-press configuration (overrides theme).
  final CartStepperLongPressConfig? longPressConfig;

  /// Collapse/expand configuration (overrides theme).
  final CartStepperCollapseConfig? collapseConfig;

  /// Icon configuration (overrides theme).
  final CartStepperIconConfig? iconConfig;

  /// Manual input configuration (overrides theme).
  final CartStepperManualInputConfig? manualInputConfig;

  /// Async behavior configuration (overrides theme).
  final CartStepperAsyncBehavior? asyncBehavior;

  /// Add-to-cart button configuration (overrides theme).
  final AddToCartButtonConfig? addToCartConfig;

  /// Whether the stepper is enabled.
  final bool enabled;

  /// Whether to show delete icon at min (overrides theme).
  final bool? showDeleteAtMin;

  /// Whether delete triggers onQuantityChanged (overrides theme).
  final bool? deleteViaQuantityChange;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Error callback for async operations.
  final AsyncErrorCallback? onError;

  /// Custom quantity formatter.
  final String Function(num quantity)? quantityFormatter;

  /// Creates a themed cart stepper.
  const ThemedCartStepper({
    super.key,
    required this.quantity,
    this.onQuantityChanged,
    this.onQuantityChangedAsync,
    this.onRemove,
    this.onRemoveAsync,
    this.onAdd,
    this.onAddAsync,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.step = 1,
    this.size,
    this.style,
    this.animation,
    this.loadingConfig,
    this.longPressConfig,
    this.collapseConfig,
    this.iconConfig,
    this.manualInputConfig,
    this.asyncBehavior,
    this.addToCartConfig,
    this.enabled = true,
    this.showDeleteAtMin,
    this.deleteViaQuantityChange,
    this.semanticLabel,
    this.onError,
    this.quantityFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CartStepperTheme.maybeOf(context);

    final resolvedSize = size ?? theme?.size ?? CartStepperSize.normal;
    final resolvedStyle =
        style ?? theme?.style ?? CartStepperStyle.defaultOrange;
    final resolvedAnimation =
        animation ?? theme?.animation ?? const CartStepperAnimation();
    final resolvedShowDeleteAtMin =
        showDeleteAtMin ?? theme?.showDeleteAtMin ?? true;
    final resolvedLongPress = longPressConfig ??
        theme?.longPressConfig ??
        const CartStepperLongPressConfig();
    final resolvedCollapse = collapseConfig ??
        theme?.collapseConfig ??
        const CartStepperCollapseConfig();
    final resolvedAddToCart = addToCartConfig ??
        theme?.addToCartConfig ??
        const AddToCartButtonConfig();

    // Use AsyncCartStepper when async callbacks are provided
    final hasAsync = onQuantityChangedAsync != null ||
        onRemoveAsync != null ||
        onAddAsync != null;

    if (hasAsync) {
      return AsyncCartStepper<T>(
        quantity: quantity,
        onQuantityChangedAsync: onQuantityChangedAsync,
        onRemoveAsync: onRemoveAsync,
        onAddAsync: onAddAsync,
        onQuantityChanged: onQuantityChanged,
        onRemove: onRemove,
        onAdd: onAdd,
        minQuantity: minQuantity,
        maxQuantity: maxQuantity,
        step: step,
        size: resolvedSize,
        style: resolvedStyle,
        animation: resolvedAnimation,
        loadingConfig: loadingConfig ??
            theme?.loadingConfig ??
            const CartStepperLoadingConfig(),
        enabled: enabled,
        showDeleteAtMin: resolvedShowDeleteAtMin,
        deleteViaQuantityChange:
            deleteViaQuantityChange ?? theme?.deleteViaQuantityChange ?? false,
        semanticLabel: semanticLabel,
        collapseConfig: resolvedCollapse,
        longPressConfig: resolvedLongPress,
        iconConfig: iconConfig ?? theme?.iconConfig,
        manualInputConfig: manualInputConfig ?? theme?.manualInputConfig,
        asyncBehavior: asyncBehavior ??
            theme?.asyncBehavior ??
            const CartStepperAsyncBehavior(),
        onError: onError,
        quantityFormatter: quantityFormatter,
        addToCartConfig: resolvedAddToCart,
      );
    }

    // Use simple CartStepper for sync-only
    return CartStepper<T>(
      quantity: quantity,
      onQuantityChanged: onQuantityChanged,
      onRemove: onRemove,
      onAdd: onAdd,
      minQuantity: minQuantity,
      maxQuantity: maxQuantity,
      step: step,
      size: resolvedSize,
      style: resolvedStyle,
      animation: resolvedAnimation,
      addToCartConfig: resolvedAddToCart,
      enabled: enabled,
      showDeleteAtMin: resolvedShowDeleteAtMin,
      semanticLabel: semanticLabel,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<num>('quantity', quantity));
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

/// A row or column of cart steppers for variant selection.
///
/// Supports sync and async quantity changes, total quantity tracking,
/// selection modes (none, single, multiple), and automatic theme resolution.
///
/// The type parameter [T] is the associated data type for each item.
/// Quantities are always [int].
///
/// Example:
/// ```dart
/// CartStepperGroup(
///   items: [
///     CartStepperGroupItem(id: 'small', quantity: 0, label: 'S'),
///     CartStepperGroupItem(id: 'medium', quantity: 1, label: 'M'),
///     CartStepperGroupItem(id: 'large', quantity: 0, label: 'L'),
///   ],
///   onQuantityChanged: (index, qty) {
///     setState(() => sizes[index] = qty);
///   },
///   onTotalChanged: (total) => print('Total: $total'),
///   selectionMode: CartStepperSelectionMode.single,
/// )
/// ```
class CartStepperGroup<T> extends StatelessWidget {
  /// The items to display.
  final List<CartStepperGroupItem<T>> items;

  /// Synchronous callback when an item's quantity changes.
  final void Function(int index, int quantity)? onQuantityChanged;

  /// Async callback when an item's quantity changes.
  ///
  /// When provided, [AsyncCartStepper] is used instead of [CartStepper].
  final Future<void> Function(int index, int quantity)? onQuantityChangedAsync;

  /// Callback when an item should be removed.
  final void Function(int index)? onRemove;

  /// Callback when the total quantity across all items changes.
  ///
  /// Fired after [onQuantityChanged] or [onQuantityChangedAsync] completes.
  final void Function(int totalQuantity)? onTotalChanged;

  /// Callback when selection changes (items with quantity > 0).
  ///
  /// Only relevant when [selectionMode] is not [CartStepperSelectionMode.none].
  /// Provides the indices of all items with quantity > 0.
  final void Function(List<int> selectedIndices)? onSelectionChanged;

  /// Size variant for all steppers.
  final CartStepperSize size;

  /// Visual style for all steppers.
  final CartStepperStyle style;

  /// Spacing between items.
  final double spacing;

  /// Layout direction of the group.
  final Axis direction;

  /// Maximum total quantity across all items.
  final int maxTotalQuantity;

  /// Selection mode for the group.
  ///
  /// - [CartStepperSelectionMode.none]: Items work independently (default).
  /// - [CartStepperSelectionMode.single]: Only one item can have quantity > 0.
  /// - [CartStepperSelectionMode.multiple]: Multiple items can have quantity > 0.
  final CartStepperSelectionMode selectionMode;

  /// Whether to pick up styles from the nearest [CartStepperTheme].
  ///
  /// When true, [size] and [style] are only used as fallbacks if no theme
  /// is found in the widget tree.
  final bool themed;

  /// Error callback for async operations.
  final AsyncErrorCallback? onError;

  /// Creates a group of cart steppers.
  const CartStepperGroup({
    super.key,
    required this.items,
    this.onQuantityChanged,
    this.onQuantityChangedAsync,
    this.onRemove,
    this.onTotalChanged,
    this.onSelectionChanged,
    this.size = CartStepperSize.compact,
    this.style = CartStepperStyle.defaultOrange,
    this.spacing = 8,
    this.direction = Axis.horizontal,
    this.maxTotalQuantity = 999,
    this.selectionMode = CartStepperSelectionMode.none,
    this.themed = false,
    this.onError,
  });

  /// Total quantity across all items.
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Indices of items with quantity > 0.
  List<int> get selectedIndices => [
        for (var i = 0; i < items.length; i++)
          if (items[i].quantity > 0) i,
      ];

  @override
  Widget build(BuildContext context) {
    // Resolve theme if themed flag is set
    final themeData = themed ? CartStepperTheme.maybeOf(context) : null;
    final resolvedSize = themeData?.size ?? size;
    final resolvedStyle = themeData?.style ?? style;
    final useAsync = onQuantityChangedAsync != null;

    return Wrap(
      direction: direction,
      spacing: spacing,
      runSpacing: spacing,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final currentTotal = totalQuantity;
        final maxForThis = item.maxQuantity
            .clamp(0, maxTotalQuantity - currentTotal + item.quantity);

        return Column(
          key: ValueKey('cart_stepper_group_${item.id}'),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.label != null)
              Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    item.label!,
                    style: TextStyle(
                      fontSize:
                          resolvedSize == CartStepperSize.compact ? 10 : 12,
                      color: Theme.of(context).textTheme.bodySmall?.color ??
                          Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            if (useAsync)
              AsyncCartStepper<int>(
                quantity: item.quantity,
                minQuantity: item.minQuantity,
                maxQuantity: maxForThis,
                step: 1,
                size: resolvedSize,
                style: resolvedStyle,
                onQuantityChangedAsync: (qty) => _handleAsyncChange(index, qty),
                onQuantityChanged: (qty) => _handleSyncChange(index, qty),
                onRemove: () => onRemove?.call(index),
                onError: onError,
              )
            else
              CartStepper<int>(
                quantity: item.quantity,
                minQuantity: item.minQuantity,
                maxQuantity: maxForThis,
                step: 1,
                size: resolvedSize,
                style: resolvedStyle,
                onQuantityChanged: (qty) => _handleSyncChange(index, qty),
                onRemove: () => onRemove?.call(index),
              ),
          ],
        );
      }),
    );
  }

  void _handleSyncChange(int index, int qty) {
    // In single selection mode, reset all other items when this one increases
    if (selectionMode == CartStepperSelectionMode.single && qty > 0) {
      // Notify reset for all other items that had quantity > 0
      for (var i = 0; i < items.length; i++) {
        if (i != index && items[i].quantity > 0) {
          onQuantityChanged?.call(i, 0);
        }
      }
    }

    onQuantityChanged?.call(index, qty);

    // Calculate the new total after this change
    final newTotal = totalQuantity - items[index].quantity + qty;
    onTotalChanged?.call(newTotal);

    if (selectionMode != CartStepperSelectionMode.none) {
      final newSelected = <int>[];
      for (var i = 0; i < items.length; i++) {
        final itemQty = i == index ? qty : items[i].quantity;
        // In single selection mode, other items are reset to 0
        if (selectionMode == CartStepperSelectionMode.single && i != index) {
          if (qty > 0) continue; // Others are reset
          if (itemQty > 0) newSelected.add(i);
        } else {
          if (itemQty > 0) newSelected.add(i);
        }
      }
      onSelectionChanged?.call(newSelected);
    }
  }

  Future<void> _handleAsyncChange(int index, int qty) async {
    // In single selection mode, reset others first
    if (selectionMode == CartStepperSelectionMode.single && qty > 0) {
      for (var i = 0; i < items.length; i++) {
        if (i != index && items[i].quantity > 0) {
          onQuantityChanged?.call(i, 0);
        }
      }
    }

    await onQuantityChangedAsync?.call(index, qty);

    final newTotal = totalQuantity - items[index].quantity + qty;
    onTotalChanged?.call(newTotal);

    if (selectionMode != CartStepperSelectionMode.none) {
      final newSelected = <int>[];
      for (var i = 0; i < items.length; i++) {
        final itemQty = i == index ? qty : items[i].quantity;
        if (selectionMode == CartStepperSelectionMode.single && i != index) {
          if (qty > 0) continue;
          if (itemQty > 0) newSelected.add(i);
        } else {
          if (itemQty > 0) newSelected.add(i);
        }
      }
      onSelectionChanged?.call(newSelected);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('itemCount', items.length));
    properties.add(IntProperty('totalQuantity', totalQuantity));
    properties.add(IntProperty('maxTotalQuantity', maxTotalQuantity));
    properties.add(
        EnumProperty<CartStepperSelectionMode>('selectionMode', selectionMode));
    properties.add(FlagProperty('themed', value: themed, ifTrue: 'themed'));
  }
}

/// Item data for [CartStepperGroup].
///
/// The type parameter [T] allows for type-safe associated data.
@immutable
class CartStepperGroupItem<T> {
  /// Unique identifier for this item.
  ///
  /// Used for stable widget keys when items are reordered or removed.
  /// Should be unique within a [CartStepperGroup].
  final String id;

  /// Current quantity.
  final int quantity;

  /// Minimum allowed quantity.
  final int minQuantity;

  /// Maximum allowed quantity.
  final int maxQuantity;

  /// Optional label displayed above the stepper.
  final String? label;

  /// Optional typed data associated with this item.
  ///
  /// Useful for storing product variant IDs or other metadata.
  final T? data;

  /// Creates a group item.
  const CartStepperGroupItem({
    required this.id,
    required this.quantity,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.label,
    this.data,
  });

  /// Creates a copy with the given fields replaced.
  CartStepperGroupItem<T> copyWith({
    String? id,
    int? quantity,
    int? minQuantity,
    int? maxQuantity,
    String? label,
    T? data,
  }) {
    return CartStepperGroupItem<T>(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      label: label ?? this.label,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartStepperGroupItem<T> &&
        other.id == id &&
        other.quantity == quantity &&
        other.minQuantity == minQuantity &&
        other.maxQuantity == maxQuantity &&
        other.label == label &&
        other.data == data;
  }

  @override
  int get hashCode =>
      Object.hash(id, quantity, minQuantity, maxQuantity, label, data);

  @override
  String toString() {
    return 'CartStepperGroupItem(id: $id, quantity: $quantity, label: $label)';
  }
}

/// Vertical list variant for product cards.
///
/// Combines product info with cart stepper in a card layout.
/// The type parameter [T] controls the quantity type (defaults to [int]).
///
/// Example:
/// ```dart
/// CartProductTile(
///   leading: Image.network(product.imageUrl),
///   title: product.name,
///   subtitle: product.description,
///   price: '\$${product.price}',
///   quantity: cartQuantity,
///   onQuantityChanged: (qty) => updateCart(product.id, qty),
///   onRemove: () => removeFromCart(product.id),
/// )
/// ```
class CartProductTile<T extends num> extends StatelessWidget {
  /// Leading widget (typically an image).
  final Widget? leading;

  /// Product title.
  final String title;

  /// Optional subtitle or description.
  final String? subtitle;

  /// Optional price display.
  final String? price;

  /// Current quantity in cart.
  final T quantity;

  /// Callback when quantity changes.
  final QuantityChangedCallback<T>? onQuantityChanged;

  /// Callback when item should be removed.
  final VoidCallback? onRemove;

  /// Callback when tile is tapped.
  final VoidCallback? onTap;

  /// Minimum allowed quantity.
  final num minQuantity;

  /// Maximum allowed quantity.
  final num maxQuantity;

  /// Step value for increment/decrement.
  final num step;

  /// Size variant for the stepper.
  final CartStepperSize stepperSize;

  /// Visual style for the stepper.
  final CartStepperStyle stepperStyle;

  /// Padding around the tile content.
  final EdgeInsetsGeometry padding;

  /// Background color of the tile.
  final Color? backgroundColor;

  /// Border radius of the tile.
  final double borderRadius;

  /// Creates a cart product tile.
  const CartProductTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.price,
    required this.quantity,
    this.onQuantityChanged,
    this.onRemove,
    this.onTap,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.step = 1,
    this.stepperSize = CartStepperSize.compact,
    this.stepperStyle = CartStepperStyle.defaultOrange,
    this.padding = const EdgeInsets.all(12),
    this.backgroundColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.cardColor;
    final priceColor = stepperStyle.backgroundColor ?? theme.primaryColor;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color ??
                              theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (price != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        price!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: priceColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              CartStepper<T>(
                quantity: quantity,
                minQuantity: minQuantity,
                maxQuantity: maxQuantity,
                step: step,
                size: stepperSize,
                style: stepperStyle,
                onQuantityChanged: onQuantityChanged,
                onRemove: onRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(DiagnosticsProperty<num>('quantity', quantity));
    properties.add(StringProperty('price', price));
  }
}
