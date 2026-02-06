# Migration Guide

## Migrating from v1.x to v2.0.0

Version 2.0.0 is a major release that introduces a breaking API change: the single `CartStepper` widget has been split into two variants, and many new features have been added. The package now provides:

- **`CartStepper<T>`** - Simple, ~20 parameters, synchronous only, supports generic `num` types
- **`AsyncCartStepper<T>`** - Full-featured, ~35 parameters (organized into config objects), supports async operations, undo, streams, and more

### No changes needed for basic sync usage (v1.x -> v2.0)

If you were using `CartStepper` in v1.x with only basic sync callbacks, your code works as-is in v2.0:

```dart
// This still works exactly the same
CartStepper(
  quantity: quantity,
  onQuantityChanged: (qty) => setState(() => quantity = qty),
  onRemove: () => setState(() => quantity = 0),
)
```

### Async usage: rename to `AsyncCartStepper` (v1.x -> v2.0)

If you were using async callbacks (`onQuantityChangedAsync`, `onRemoveAsync`, `onAddAsync`) in v1.x, rename the widget to `AsyncCartStepper` and move grouped parameters into config objects:

```dart
// Before (v1.x)
CartStepper(
  quantity: qty,
  onQuantityChangedAsync: (q) async { ... },
  optimisticUpdate: true,
  revertOnError: true,
  debounceDelay: Duration(milliseconds: 500),
  enableManualInput: true,
  enableLongPress: false,
  addIcon: Icons.add_circle,
  incrementIcon: Icons.arrow_upward,
  separateIcon: Icons.shopping_cart,
)

// After (v2.0)
AsyncCartStepper(
  quantity: qty,
  onQuantityChangedAsync: (q) async { ... },
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: true,
    revertOnError: true,
    debounceDelay: Duration(milliseconds: 500),
  ),
  manualInputConfig: CartStepperManualInputConfig(enabled: true),
  longPressConfig: CartStepperLongPressConfig(enabled: false),
  iconConfig: CartStepperIconConfig(
    addIcon: Icons.add_circle,
    incrementIcon: Icons.arrow_upward,
    collapsedBadgeIcon: Icons.shopping_cart, // renamed from separateIcon
  ),
)
```

### Advanced sync features: use `AsyncCartStepper` (v1.x -> v2.0)

Even without async callbacks, if you were using advanced v1.x features like custom icons, validators, manual input, long press config, auto-collapse, or quantity formatters, use `AsyncCartStepper` in v2.0:

```dart
// Before (v1.x)
CartStepper(
  quantity: qty,
  validator: (current, next) => next % 2 == 0,
  onValidationRejected: (current, attempted) { ... },
  enableManualInput: true,
  autoCollapseDelay: Duration(seconds: 3),
  quantityFormatter: QuantityFormatters.abbreviated,
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)

// After (v2.0)
AsyncCartStepper(
  quantity: qty,
  validator: (current, next) => next % 2 == 0,
  onValidationRejected: (current, attempted) { ... },
  manualInputConfig: CartStepperManualInputConfig(enabled: true),
  collapseConfig: CartStepperCollapseConfig(
    autoCollapseDelay: Duration(seconds: 3),
  ),
  quantityFormatter: QuantityFormatters.abbreviated,
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### CartStepperThemeData changes (v1.x -> v2.0)

Flat parameters have been replaced with config objects in the theme:

```dart
// Before (v1.x)
CartStepperThemeData(
  enableLongPress: true,
  autoCollapseDelay: Duration(seconds: 5),
)

// After (v2.0)
CartStepperThemeData(
  longPressConfig: CartStepperLongPressConfig(enabled: true),
  collapseConfig: CartStepperCollapseConfig(
    autoCollapseDelay: Duration(seconds: 5),
  ),
)
```

### ThemedCartStepper changes (v1.x -> v2.0)

`ThemedCartStepper` is now generic (`ThemedCartStepper<T extends num>`) and uses config objects instead of flat parameters:

```dart
// Before (v1.x)
ThemedCartStepper(
  quantity: qty,
  enableLongPress: true,
  autoCollapseDelay: Duration(seconds: 3),
  initialLongPressDelay: Duration(milliseconds: 400),
  onQuantityChanged: (qty) {},
)

// After (v2.0)
ThemedCartStepper(
  quantity: qty,
  longPressConfig: CartStepperLongPressConfig(
    enabled: true,
    initialDelay: Duration(milliseconds: 400),
  ),
  collapseConfig: CartStepperCollapseConfig(
    autoCollapseDelay: Duration(seconds: 3),
  ),
  onQuantityChanged: (qty) {},
)
```

### QuantityFormatters type change (v1.x -> v2.0)

Formatter functions now accept `num` instead of `int`:

```dart
// Before (v1.x)
String Function(int) formatter = QuantityFormatters.abbreviated;

// After (v2.0)
String Function(num) formatter = QuantityFormatters.abbreviated;
```

## Parameter mapping reference (v1.x -> v2.0)

### Renamed parameters

| Old | New |
|---|---|
| `separateIcon` | `collapsedBadgeIcon` (via `CartStepperIconConfig`) |

### Parameters moved to `CartStepperAsyncBehavior`

| Old (flat parameter) | New (config object) |
|---|---|
| `optimisticUpdate` | `asyncBehavior: CartStepperAsyncBehavior(optimisticUpdate: ...)` |
| `revertOnError` | `asyncBehavior: CartStepperAsyncBehavior(revertOnError: ...)` |
| `debounceDelay` | `asyncBehavior: CartStepperAsyncBehavior(debounceDelay: ...)` |
| `throttleInterval` | `asyncBehavior: CartStepperAsyncBehavior(throttleInterval: ...)` |
| `allowLongPressForAsync` | `asyncBehavior: CartStepperAsyncBehavior(allowLongPressForAsync: ...)` |

### Parameters moved to `CartStepperLongPressConfig`

| Old (flat parameter) | New (config object) |
|---|---|
| `enableLongPress` | `longPressConfig: CartStepperLongPressConfig(enabled: ...)` |
| `longPressInterval` | `longPressConfig: CartStepperLongPressConfig(interval: ...)` |
| `initialLongPressDelay` | `longPressConfig: CartStepperLongPressConfig(initialDelay: ...)` |

### Parameters moved to `CartStepperManualInputConfig`

| Old (flat parameter) | New (config object) |
|---|---|
| `enableManualInput` | `manualInputConfig: CartStepperManualInputConfig(enabled: ...)` |
| `manualInputKeyboardType` | `manualInputConfig: CartStepperManualInputConfig(keyboardType: ...)` |
| `manualInputDecoration` | `manualInputConfig: CartStepperManualInputConfig(decoration: ...)` |
| `onManualInputSubmitted` | `manualInputConfig: CartStepperManualInputConfig(onSubmitted: ...)` |
| `manualInputBuilder` | `manualInputConfig: CartStepperManualInputConfig(builder: ...)` |

### Parameters moved to `CartStepperCollapseConfig`

| Old (flat parameter) | New (config object) |
|---|---|
| `autoCollapse` | `collapseConfig: CartStepperCollapseConfig(autoCollapse: ...)` |
| `autoCollapseDelay` | `collapseConfig: CartStepperCollapseConfig(autoCollapseDelay: ...)` |
| `initiallyExpanded` | `collapseConfig: CartStepperCollapseConfig(initiallyExpanded: ...)` |
| `collapsedBuilder` | `collapseConfig: CartStepperCollapseConfig(collapsedBuilder: ...)` |
| `collapsedWidth` | `collapseConfig: CartStepperCollapseConfig(collapsedWidth: ...)` |
| `collapsedHeight` | `collapseConfig: CartStepperCollapseConfig(collapsedHeight: ...)` |

### Parameters moved to `CartStepperIconConfig`

| Old (flat parameter) | New (config object) |
|---|---|
| `addIcon` | `iconConfig: CartStepperIconConfig(addIcon: ...)` |
| `incrementIcon` | `iconConfig: CartStepperIconConfig(incrementIcon: ...)` |
| `decrementIcon` | `iconConfig: CartStepperIconConfig(decrementIcon: ...)` |
| `deleteIcon` | `iconConfig: CartStepperIconConfig(deleteIcon: ...)` |
| `separateIcon` | `iconConfig: CartStepperIconConfig(collapsedBadgeIcon: ...)` |

### Parameters unchanged on `AsyncCartStepper`

These parameters remain as top-level parameters on `AsyncCartStepper` (same names, same behavior):

- `quantity`, `onQuantityChangedAsync`, `onRemoveAsync`, `onAddAsync`
- `onQuantityChanged`, `onRemove`, `onAdd`
- `minQuantity`, `maxQuantity`, `step`
- `size`, `style`, `animation`, `addToCartConfig`
- `loadingConfig`, `isLoading`
- `enabled`, `showDeleteAtMin`, `deleteViaQuantityChange`
- `semanticLabel`
- `onError`, `errorBuilder`
- `validator`, `onMaxReached`, `onMinReached`
- `onValidationRejected`, `onOperationCancelled`
- `quantityFormatter`

## New features in v2.0

These features are new in v2.0 and have no v1.x equivalent:

| Feature | Widget | Config / Parameter |
|---|---|---|
| Generic `T extends num` | Both | `CartStepper<double>(quantity: 1.5, ...)` |
| Detailed quantity changed | Both | `onDetailedQuantityChanged: (newQty, oldQty, type) {}` |
| RTL / directionality | Both | `textDirection: TextDirection.rtl` |
| Vertical layout | Both | `direction: CartStepperDirection.vertical` |
| Expand/collapse callbacks | Both | `onExpanded` / `onCollapsed` |
| Controller integration | Both | `controller: myController` |
| Reactive streams | Both | `quantityStream: myStream` |
| Async validator | `AsyncCartStepper` | `asyncValidator: (current, next) async => ...` |
| Expanded builder | `AsyncCartStepper` | `expandedBuilder: (ctx, qty, inc, dec, loading) => ...` |
| Transition builder | Both | `animation: CartStepperAnimation(transitionBuilder: ...)` |
| Undo after delete | `AsyncCartStepper` | `undoConfig: CartStepperUndoConfig(...)` |
| Group total callback | `CartStepperGroup` | `onTotalChanged: (total) {}` |
| Group async support | `CartStepperGroup` | `onQuantityChangedAsync: (index, qty) async {}` |
| Group selection mode | `CartStepperGroup` | `selectionMode: CartStepperSelectionMode.single` |
| Group themed flag | `CartStepperGroup` | `themed: true` |
| Theme config objects | `CartStepperThemeData` | `longPressConfig`, `collapseConfig`, `iconConfig`, etc. |

## Config object presets

The config objects come with convenient static presets:

```dart
// Long press
CartStepperLongPressConfig.fast       // 50ms interval, 200ms delay
CartStepperLongPressConfig.slow       // 200ms interval, 600ms delay
CartStepperLongPressConfig.disabled   // long press off

// Async behavior
CartStepperAsyncBehavior.optimistic   // optimistic + revert on error
CartStepperAsyncBehavior.debounced()  // debounced with configurable delay

// Collapse
CartStepperCollapseConfig.badge()     // auto-collapse with configurable delay
```
