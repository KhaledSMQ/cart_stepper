# Cart Stepper

A highly customizable, animated cart quantity stepper widget for Flutter with async support, loading indicators, and theming.

[![pub package](https://img.shields.io/pub/v/advance_cart_stepper.svg)](https://pub.dev/packages/advance_cart_stepper)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.10-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%5E3.0-blue.svg)](https://dart.dev)

![Cart Stepper Demo](https://raw.githubusercontent.com/khaledsmq/advance_cart_stepper/main/screenshots/demo.gif)

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Which Widget to Use?](#which-widget-to-use)
- [Quick Start](#quick-start)
- [Customization](#customization)
  - [Size Variants](#size-variants)
  - [Style Presets](#style-presets)
  - [Custom Styling](#custom-styling)
  - [Style from ColorScheme](#style-from-colorscheme)
  - [Add Button Styles](#add-button-styles)
  - [Animation Configuration](#animation-configuration)
  - [Generic Quantity Type](#generic-quantity-type)
  - [Vertical Layout](#vertical-layout)
  - [RTL / Directionality](#rtl--directionality)
  - [Detailed Quantity Changed Callback](#detailed-quantity-changed-callback)
  - [Expand / Collapse Callbacks](#expand--collapse-callbacks)
- [AsyncCartStepper Features](#asynccartstepper-features)
  - [Loading Indicators](#loading-indicators)
  - [Optimistic Updates](#optimistic-updates)
  - [Debounce Mode](#debounce-mode)
  - [Error Handling](#error-handling)
  - [Custom Icons](#custom-icons-cartsteppericonconfig)
  - [Long Press Configuration](#long-press-configuration-cartstepperlongpressconfig)
  - [Manual Input](#manual-input-cartsteppermanualinputconfig)
  - [Auto-Collapse with Badge](#auto-collapse-with-badge-cartsteppercollapseconfig)
  - [Validation with Feedback](#validation-with-feedback)
  - [Quantity Formatting](#quantity-formatting)
  - [Async Behavior Configuration](#async-behavior-configuration-cartstepperasyncbehavior)
  - [Deep Dive: Throttle vs Debounce](#deep-dive-throttle-vs-debounce)
  - [`isLoading` and Async Modes](#isloading-and-async-modes)
  - [Best Practices & Common Patterns](#best-practices--common-patterns)
  - [Reactive Streams](#reactive-streams)
  - [Undo After Delete](#undo-after-delete)
  - [Async Validator](#async-validator)
  - [Custom Expanded Builder](#custom-expanded-builder)
  - [Custom Transition Builder](#custom-transition-builder)
- [Controller](#controller)
- [Theming](#theming)
- [Composite Widgets](#composite-widgets)
  - [CartProductTile](#cartproducttile)
  - [CartStepperGroup](#cartsteppergroup)
  - [CartBadge](#cartbadge)
- [Extracted Widgets](#extracted-widgets)
  - [StepperButton](#stepperbutton)
  - [AnimatedCounter](#animatedcounter)
- [Error Types](#error-types)
- [Tips, Gotchas & Hidden Behaviors](#tips-gotchas--hidden-behaviors)
- [Migration Guide](#migration-guide)
- [Example App](#example-app)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Smooth Animations** -- Elegant expand/collapse transitions between add button and stepper
- **Two Widget Variants** -- Simple `CartStepper` for sync usage, `AsyncCartStepper` for full async support
- **Generic Quantity Type** -- Supports `int`, `double`, or any `num` subtype via `CartStepper<T>`
- **Async Support** -- Built-in loading indicators for API operations with error handling
- **Optimistic Updates** -- Instant UI feedback with automatic revert on errors
- **Debounce Mode** -- Batch rapid changes into a single API call
- **Operation Management** -- Throttling, cancellation, and pending operation tracking
- **Sync & Async Validation** -- Custom validators with rejection callbacks for user feedback
- **Multiple Loading Indicators** -- 15+ SpinKit animations plus Flutter's built-in indicators
- **Customizable Styling** -- Full control over colors, borders, shadows, and typography
- **Size Variants** -- Compact, normal, and large presets for different use cases
- **Theming** -- Apply consistent styles across multiple steppers with `CartStepperTheme`
- **Long Press** -- Hold to rapidly increment/decrement with configurable delays
- **Manual Input** -- Tap to type quantities directly via keyboard
- **Auto-Collapse** -- Optionally collapse to badge view after inactivity
- **Quantity Formatters** -- Built-in abbreviation for large numbers (1.5k, 2M)
- **RTL Support** -- Full right-to-left directionality support
- **Vertical Layout** -- Horizontal or vertical stepper layout direction
- **Controller Integration** -- External state management with `CartStepperController`
- **Reactive Streams** -- Drive quantity from a `Stream<T>` for reactive architectures
- **Undo Support** -- Configurable undo-after-delete with custom UI
- **Detailed Callbacks** -- `onDetailedQuantityChanged` with old value, new value, and change type
- **Expand/Collapse Callbacks** -- `onExpanded` / `onCollapsed` lifecycle hooks
- **Custom Builders** -- `expandedBuilder` and `transitionBuilder` for fully custom UI
- **Selection Modes** -- Single or multiple selection in `CartStepperGroup`
- **Typed Error Hierarchy** -- Sealed `CartStepperError` classes for precise error handling
- **Extracted Widgets** -- Reusable `StepperButton` and `AnimatedCounter` for custom implementations
- **State-Agnostic** -- Works with any state management (Provider, Riverpod, Bloc, etc.)
- **Accessibility** -- Full semantic support for screen readers

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  advance_cart_stepper: ^2.0.1
```

Then run:

```bash
flutter pub get
```

## Which Widget to Use?

| Feature | `CartStepper` | `AsyncCartStepper` |
|---|---|---|
| Sync callbacks | Yes | Yes |
| Generic `T extends num` | Yes | Yes |
| Controller integration | Yes | Yes |
| Reactive streams | Yes | Yes |
| RTL / directionality | Yes | Yes |
| Vertical layout | Yes | Yes |
| Expand/collapse callbacks | Yes | Yes |
| Detailed quantity changed | Yes | Yes |
| Async callbacks with loading | -- | Yes |
| Optimistic updates / debounce | -- | Yes |
| Custom icons | -- | Yes (via `iconConfig`) |
| Long press configuration | -- | Yes (via `longPressConfig`) |
| Manual input | -- | Yes (via `manualInputConfig`) |
| Auto-collapse / badge mode | -- | Yes (via `collapseConfig`) |
| Async validators | -- | Yes |
| Undo after delete | -- | Yes (via `undoConfig`) |
| Expanded builder | -- | Yes |
| Transition builder | -- | Yes (via `animation`) |
| Quantity formatters | -- | Yes |
| Error handling | -- | Yes |

**Rule of thumb:** Use `CartStepper` for simple add/remove/adjust flows. Use `AsyncCartStepper` when you need API calls, advanced customization, or any feature beyond the basics.

## Quick Start

### Basic Usage (CartStepper)

```dart
import 'package:advance_cart_stepper/advance_cart_stepper.dart';

CartStepper(
  quantity: quantity,
  onQuantityChanged: (qty) => setState(() => quantity = qty),
  onRemove: () => setState(() => quantity = 0),
)
```

### Async with Loading Indicator (AsyncCartStepper)

```dart
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onRemoveAsync: () async {
    await api.removeFromCart(itemId);
    setState(() => quantity = 0);
  },
  onError: (error, stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  },
)
```

## Customization

### Size Variants

```dart
// Compact -- for dense lists (32px height)
CartStepper(quantity: quantity, size: CartStepperSize.compact, onQuantityChanged: (qty) {})

// Normal -- default size (40px height)
CartStepper(quantity: quantity, size: CartStepperSize.normal, onQuantityChanged: (qty) {})

// Large -- for accessibility or prominent CTAs (48px height)
CartStepper(quantity: quantity, size: CartStepperSize.large, onQuantityChanged: (qty) {})
```

### Style Presets

```dart
CartStepper(quantity: quantity, style: CartStepperStyle.defaultOrange, onQuantityChanged: (qty) {})
CartStepper(quantity: quantity, style: CartStepperStyle.dark, onQuantityChanged: (qty) {})
CartStepper(quantity: quantity, style: CartStepperStyle.light, onQuantityChanged: (qty) {})
```

### Custom Styling

```dart
CartStepper(
  quantity: quantity,
  style: CartStepperStyle(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    borderColor: Colors.blue,
    borderWidth: 2.0,
    elevation: 4.0,
    borderRadius: BorderRadius.circular(8),
    fontWeight: FontWeight.bold,
    iconScale: 1.2,
    textStyle: TextStyle(fontSize: 16, letterSpacing: 1.2),
  ),
  onQuantityChanged: (qty) {},
)
```

### Style from ColorScheme

Automatically match your app's theme:

```dart
CartStepper(
  quantity: quantity,
  style: CartStepperStyle.fromColorScheme(Theme.of(context).colorScheme),
  onQuantityChanged: (qty) {},
)
```

### Add Button Styles

```dart
CartStepper(quantity: 0, addToCartConfig: AddToCartButtonConfig.circleIcon, onQuantityChanged: (qty) {})
CartStepper(quantity: 0, addToCartConfig: AddToCartButtonConfig.addButton, onQuantityChanged: (qty) {})
CartStepper(quantity: 0, addToCartConfig: AddToCartButtonConfig.addToCartButton, onQuantityChanged: (qty) {})
CartStepper(quantity: 0, addToCartConfig: AddToCartButtonConfig.iconOnlyButton, onQuantityChanged: (qty) {})

// Custom button
CartStepper(
  quantity: 0,
  addToCartConfig: AddToCartButtonConfig(
    style: AddToCartButtonStyle.button,
    buttonText: 'Buy Now',
    icon: Icons.shopping_bag,
    iconLeading: false,
    buttonWidth: 100,
  ),
  onQuantityChanged: (qty) {},
)
```

### Animation Configuration

```dart
CartStepper(quantity: quantity, animation: CartStepperAnimation.fast, onQuantityChanged: (qty) {})
CartStepper(quantity: quantity, animation: CartStepperAnimation.smooth, onQuantityChanged: (qty) {})

// Custom
CartStepper(
  quantity: quantity,
  animation: CartStepperAnimation(
    expandDuration: Duration(milliseconds: 300),
    countChangeDuration: Duration(milliseconds: 150),
    expandCurve: Curves.easeOutBack,
    collapseCurve: Curves.easeInCubic,
    countChangeCurve: Curves.easeInOut,
    enableHaptics: true,
  ),
  onQuantityChanged: (qty) {},
)
```

### Generic Quantity Type

Use `double` or any `num` subtype for fractional quantities:

```dart
// Double quantities (e.g., weight in kg)
CartStepper<double>(
  quantity: 1.5,
  minQuantity: 0.0,
  maxQuantity: 10.0,
  step: 0.5,
  onQuantityChanged: (qty) => setState(() => weight = qty),
)

// Default is int -- no type parameter needed
CartStepper(
  quantity: 3,
  onQuantityChanged: (qty) => setState(() => count = qty),
)
```

### Vertical Layout

Stack controls vertically:

```dart
CartStepper(
  quantity: quantity,
  direction: CartStepperDirection.vertical,
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### RTL / Directionality

Explicit text direction for RTL languages:

```dart
CartStepper(
  quantity: quantity,
  textDirection: TextDirection.rtl,
  onQuantityChanged: (qty) {},
)
```

### Detailed Quantity Changed Callback

Get old value, new value, and change type:

```dart
CartStepper(
  quantity: quantity,
  onDetailedQuantityChanged: (newQty, oldQty, changeType) {
    print('Changed from $oldQty to $newQty via $changeType');
    // changeType: increment, decrement, add, remove, longPressIncrement,
    //             longPressDecrement, manualInput, programmatic, stream
  },
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### Expand / Collapse Callbacks

React to stepper expand/collapse transitions:

```dart
CartStepper(
  quantity: quantity,
  onExpanded: () => print('Stepper expanded'),
  onCollapsed: () => print('Stepper collapsed'),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

## AsyncCartStepper Features

All of the following features require `AsyncCartStepper`.

### Loading Indicators

```dart
// SpinKit animations
AsyncCartStepper(
  quantity: quantity,
  loadingConfig: CartStepperLoadingConfig(
    type: CartStepperLoadingType.fadingCircle,
    minimumDuration: Duration(milliseconds: 500),
    sizeMultiplier: 0.8,
    showDelay: Duration.zero,
    disableButtonsDuringLoading: true,
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(qty);
  },
)

// Built-in Flutter indicator (no SpinKit dependency)
AsyncCartStepper(
  quantity: quantity,
  loadingConfig: CartStepperLoadingConfig.builtIn,
  onQuantityChangedAsync: (qty) async { await api.updateCart(qty); },
)
```

**Loading config presets:**

| Preset | Type | Min Duration | Size |
|---|---|---|---|
| `CartStepperLoadingConfig()` | `threeBounce` | 300ms | 0.8x |
| `CartStepperLoadingConfig.fast` | `pulse` | 150ms | 0.7x |
| `CartStepperLoadingConfig.subtle` | `fadingFour` | 200ms | 0.6x |
| `CartStepperLoadingConfig.builtIn` | `circular` | 200ms | 0.7x |

**Available loading types:**
`threeBounce` (default), `fadingCircle`, `pulse`, `dualRing`, `spinningCircle`, `wave`, `chasingDots`, `threeInOut`, `ring`, `ripple`, `fadingFour`, `pianoWave`, `dancingSquare`, `cubeGrid`, `circular` (Flutter built-in), `linear` (Flutter built-in)

### Optimistic Updates

Update the UI immediately while the API call happens in background:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: true,
    revertOnError: true,
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stack) {
    showErrorSnackBar(error.toString());
  },
)
```

### Debounce Mode

Batch rapid changes into a single API call:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    // Only called after user stops interacting for 500ms
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

With debounce:
- User sees immediate UI feedback
- User can rapidly adjust quantity without waiting
- Only one API call is made after user stops interacting
- Long press works smoothly without blocking

### Error Handling

#### Error Callback

```dart
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: $error')),
    );
  },
)
```

#### Error Builder

Display inline error UI with retry functionality:

```dart
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  errorBuilder: (context, error, retry) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Failed to update', style: TextStyle(color: Colors.red, fontSize: 12)),
        TextButton(onPressed: retry, child: Text('Retry')),
      ],
    );
  },
)
```

### Custom Icons (CartStepperIconConfig)

```dart
AsyncCartStepper(
  quantity: quantity,
  iconConfig: CartStepperIconConfig(
    addIcon: Icons.add_circle,
    incrementIcon: Icons.arrow_upward,
    decrementIcon: Icons.arrow_downward,
    deleteIcon: Icons.cancel,
    collapsedBadgeIcon: Icons.shopping_cart,
  ),
  onQuantityChanged: (qty) {},
)
```

### Long Press Configuration (CartStepperLongPressConfig)

```dart
// Fast repeat
AsyncCartStepper(
  quantity: quantity,
  longPressConfig: CartStepperLongPressConfig.fast,
  onQuantityChanged: (qty) {},
)

// Slow repeat
AsyncCartStepper(
  quantity: quantity,
  longPressConfig: CartStepperLongPressConfig.slow,
  onQuantityChanged: (qty) {},
)

// Disabled
AsyncCartStepper(
  quantity: quantity,
  longPressConfig: CartStepperLongPressConfig.disabled,
  onQuantityChanged: (qty) {},
)

// Custom
AsyncCartStepper(
  quantity: quantity,
  longPressConfig: CartStepperLongPressConfig(
    enabled: true,
    interval: Duration(milliseconds: 50),
    initialDelay: Duration(milliseconds: 200),
  ),
  onQuantityChanged: (qty) {},
)
```

**Long press presets:**

| Preset | Interval | Initial Delay |
|---|---|---|
| `CartStepperLongPressConfig()` | 100ms | 400ms |
| `CartStepperLongPressConfig.fast` | 50ms | 200ms |
| `CartStepperLongPressConfig.slow` | 200ms | 600ms |
| `CartStepperLongPressConfig.disabled` | -- | -- |

### Manual Input (CartStepperManualInputConfig)

Allow users to type quantities directly:

```dart
AsyncCartStepper(
  quantity: quantity,
  manualInputConfig: CartStepperManualInputConfig(
    enabled: true,
    onSubmitted: (value) => print('User entered: $value'),
  ),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

Custom input builder:

```dart
AsyncCartStepper(
  quantity: quantity,
  manualInputConfig: CartStepperManualInputConfig(
    enabled: true,
    builder: (context, currentValue, onSubmit, onCancel) {
      return MyCustomNumberPicker(
        value: currentValue,
        onConfirm: (value) => onSubmit(value.toString()),
        onCancel: onCancel,
      );
    },
  ),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### Auto-Collapse with Badge (CartStepperCollapseConfig)

```dart
AsyncCartStepper(
  quantity: quantity,
  collapseConfig: CartStepperCollapseConfig(
    autoCollapseDelay: Duration(seconds: 3),
    initiallyExpanded: false,
  ),
  iconConfig: CartStepperIconConfig(
    collapsedBadgeIcon: Icons.shopping_cart,
  ),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)

// Or use the badge() preset
AsyncCartStepper(
  quantity: quantity,
  collapseConfig: CartStepperCollapseConfig.badge(
    delay: Duration(seconds: 3),
  ),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

Custom collapsed button:

```dart
AsyncCartStepper(
  quantity: quantity,
  collapseConfig: CartStepperCollapseConfig(
    collapsedWidth: 110,
    collapsedHeight: 36,
    collapsedBuilder: (context, qty, isLoading, onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Text('Add to Cart'),
        ),
      );
    },
  ),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### Validation with Feedback

```dart
AsyncCartStepper(
  quantity: quantity,
  maxQuantity: 100,
  validator: (current, newQty) => newQty <= availableStock,
  onValidationRejected: (current, attempted) {
    showSnackBar('Only $availableStock items in stock');
  },
  onMaxReached: () => showSnackBar('Maximum quantity reached'),
  onMinReached: () => showSnackBar('Minimum quantity reached'),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### Quantity Formatting

```dart
// Abbreviate large numbers (1500 -> "1.5k")
AsyncCartStepper(
  quantity: 1500,
  maxQuantity: 9999999,
  quantityFormatter: QuantityFormatters.abbreviated,
  onQuantityChanged: (qty) {},
)

// Show max indicator (99 -> "99+")
AsyncCartStepper(
  quantity: 99,
  quantityFormatter: QuantityFormatters.abbreviatedWithMax(99),
  onQuantityChanged: (qty) {},
)

// Simple display (integers without decimal point)
AsyncCartStepper(
  quantity: 5,
  quantityFormatter: QuantityFormatters.simple,
  onQuantityChanged: (qty) {},
)
```

### Async Behavior Configuration (CartStepperAsyncBehavior)

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: true,       // Show new value immediately
    revertOnError: true,          // Revert if operation fails
    allowLongPressForAsync: false, // Disable rapid fire for async
    throttleInterval: Duration(milliseconds: 100),
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
  },
)
```

**Async behavior presets:**

| Preset | Description |
|---|---|
| `CartStepperAsyncBehavior()` | Default -- no optimistic updates, 80ms throttle |
| `CartStepperAsyncBehavior.optimistic` | Optimistic updates with revert on error |
| `CartStepperAsyncBehavior.debounced()` | Debounced with configurable delay (default 500ms) |

### Deep Dive: Throttle vs Debounce

Understanding the two execution strategies is key to choosing the right `asyncBehavior` for your use case.

#### Throttle Mode (Default)

When `debounceDelay` is **not set** (the default), each tap triggers an API call immediately, but rapid taps are throttled so no more than one call fires per `throttleInterval` (default 80ms). If a tap arrives while the throttle window is active, the latest value is queued and fires when the window elapses.

```
User taps: +  +  +  (rapid taps)
           |  |  |
API calls: [call 1]  (throttled → queued) → [call 2 with latest value]
```

```dart
// Default throttle mode — each tap triggers an API call (throttled at 80ms)
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

#### Debounce Mode

When `debounceDelay` is set, the widget switches to a completely different strategy:

1. **UI updates instantly** — the quantity counter changes immediately on each tap
2. **A timer starts** — if the user taps again before the timer fires, the timer resets
3. **One API call fires** — only after the user has **stopped interacting** for the `debounceDelay` duration, a single API call is made with the **final accumulated value**

```
User taps:  +    +    +         (rapid taps, then pause)
            |    |    |
UI display: 1    2    3         (updates instantly)
            [reset] [reset]     (timer keeps resetting)
                          |--- 500ms idle ---|
API call:                                   [call with qty=3]
```

```dart
// Debounce mode — user taps +++ rapidly, UI shows 3 instantly,
// then ONE API call fires 500ms after the last tap
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

#### Key Differences

| Aspect | Throttle (default) | Debounce |
|---|---|---|
| API call timing | Immediately (throttled) | After user stops interacting |
| Number of API calls | One per tap (deduped by throttle window) | One total for all rapid taps |
| UI update | Waits for API (unless `optimisticUpdate`) | Instant local update |
| Long press for async | Blocked by default | Allowed automatically |
| Best for | Single item adjustments | Shopping carts, bulk edits |

> **Tip:** Debounce mode is ideal for shopping cart APIs where you want responsive UI without hammering the server. The user can tap 5 times rapidly and only one API call is made.

#### Debounce + Long Press

In throttle mode, long-press rapid-fire is **blocked** for async operations by default (to prevent queuing many concurrent API calls). But in debounce mode, long-press is **automatically allowed** because there is no risk — only one API call fires at the end regardless of how many taps occurred:

```dart
// Long press works smoothly in debounce mode — no extra config needed
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  longPressConfig: CartStepperLongPressConfig.fast,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

#### Debounce + Error Revert

When `revertOnError` is `true` (the default), if the debounced API call fails, the displayed quantity reverts to the value **before the debounce accumulation started** — not just the last tap:

```
User taps:  1 → 2 → 3 → 4    (debounce accumulates)
API call:   updateCart(4)      (fires after delay)
API fails:  ✗ error
UI reverts: 1                  (back to the starting value, not 3)
```

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
    revertOnError: true, // default
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stack) {
    showErrorSnackBar('Failed to update cart');
  },
)
```

### `isLoading` and Async Modes

The `isLoading` parameter lets you externally control the loading state. However, it interacts with debounce and optimistic updates in important ways.

#### How Loading State Works Internally

There are two sources of loading state:

| Source | Description |
|---|---|
| `isLoading` (external) | Set by you via the widget parameter — **overrides** internal state |
| Internal loading | Managed automatically by the widget during async operations |

When `isLoading` is `null` (the default), the widget manages its own loading state:
- In **throttle mode**: loading is `true` while each API call is in flight
- In **debounce mode**: loading stays `false` during the debounce "waiting" phase and only becomes `true` when the API call actually fires

When `isLoading` is explicitly set, it **always takes priority** over the internal state.

#### Where Loading Blocks Interaction

When loading is active (`isLoading == true` or internal loading is `true`):

| Action | Blocked? | Override |
|---|---|---|
| Increment / decrement | Yes | Unless `optimisticUpdate: true` |
| Add button | Yes | Unless `optimisticUpdate: true` |
| Manual input | **Always blocked** | No override available |

#### The Debounce Gotcha

Debounce mode relies on the user being able to **tap multiple times freely** during the debounce accumulation window. If you externally set `isLoading: true` too broadly, it blocks all taps and defeats the purpose of debouncing:

```dart
// BAD — Don't do this with debounce mode
AsyncCartStepper(
  quantity: quantity,
  isLoading: myGlobalLoadingFlag, // blocks taps during debounce window!
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async { ... },
)

// GOOD — Let the widget manage its own loading state
AsyncCartStepper(
  quantity: quantity,
  // isLoading: not set (null) — internal state manages it correctly
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async { ... },
)
```

#### Recommended `isLoading` Usage

| Scenario | `isLoading` | Why |
|---|---|---|
| Debounce mode | Don't set (leave `null`) | Let internal state handle it |
| Throttle + optimistic updates | Optional | Safe because `optimisticUpdate` bypasses the loading check |
| Throttle (default, no optimistic) | Optional | Can use for external control |
| External loading (e.g., page-level refresh) | `true` during refresh | Useful to block all interaction during unrelated loading |

### Best Practices & Common Patterns

#### Pattern 1: Quick Cart Update (Recommended for Most Apps)

Debounce with error handling — responsive UI, minimal API calls:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stack) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update cart')),
    );
  },
)
```

#### Pattern 2: Instant Feedback with Safety Net

Optimistic updates + revert on error — feels instant, auto-recovers:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior.optimistic,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stack) {
    showErrorSnackBar('Update failed — reverted');
  },
)
```

#### Pattern 3: Maximum Responsiveness (Optimistic + Debounce)

Combines both strategies — UI updates instantly, one batched API call, reverts on failure:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: true,
    revertOnError: true,
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stack) {
    showErrorSnackBar('Update failed — reverted');
  },
)
```

#### Pattern 4: Strict Server-Authoritative

No optimistic updates, no debounce — wait for the server on every change:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: false,
    throttleInterval: Duration(milliseconds: 100),
  ),
  loadingConfig: CartStepperLoadingConfig.fast,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

#### Pattern 5: Debounce with Long Press for Bulk Adjustments

Fast long-press + debounce — great for adjusting large quantities quickly:

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 800),
  ),
  longPressConfig: CartStepperLongPressConfig.fast,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

### Reactive Streams

Drive quantity from a `Stream`:

```dart
AsyncCartStepper(
  quantity: quantity,
  quantityStream: myQuantityStream,
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### Undo After Delete

Allow users to undo item removal:

```dart
AsyncCartStepper(
  quantity: quantity,
  undoConfig: const CartStepperUndoConfig(
    enabled: true,
    duration: Duration(seconds: 3),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onRemoveAsync: () async {
    await api.removeFromCart(itemId);
    setState(() => quantity = 0);
  },
)
```

Custom undo UI:

```dart
AsyncCartStepper(
  quantity: quantity,
  undoConfig: CartStepperUndoConfig(
    enabled: true,
    duration: Duration(seconds: 5),
    builder: (context, undo) => TextButton(
      onPressed: undo,
      child: Text('Undo'),
    ),
  ),
  onQuantityChangedAsync: (qty) async { await api.updateCart(itemId, qty); },
)
```

### Async Validator

Validate quantity changes asynchronously (e.g., check stock):

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncValidator: (current, next) async {
    final available = await api.checkStock(itemId, next);
    return available;
  },
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

### Custom Expanded Builder

Replace the default expanded controls with a custom builder:

```dart
AsyncCartStepper(
  quantity: quantity,
  expandedBuilder: (context, qty, increment, decrement, isLoading) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: decrement, icon: Icon(Icons.remove)),
        Text('$qty'),
        IconButton(onPressed: increment, icon: Icon(Icons.add)),
      ],
    );
  },
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

### Custom Transition Builder

Customize the expand/collapse animation:

```dart
CartStepper(
  quantity: quantity,
  animation: CartStepperAnimation(
    transitionBuilder: (context, animation, child) {
      return ScaleTransition(scale: animation, child: child);
    },
  ),
  onQuantityChanged: (qty) => setState(() => quantity = qty),
)
```

## Controller

For external state management with `CartStepperController`:

```dart
class _MyWidgetState extends State<MyWidget> {
  late final CartStepperController controller;

  @override
  void initState() {
    super.initState();
    controller = CartStepperController(
      initialQuantity: 0,
      minQuantity: 0,
      maxQuantity: 10,
      step: 1,
      onMaxReached: () => print('Max reached'),
      onMinReached: () => print('Min reached'),
    );
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Manual wiring
        CartStepper(
          quantity: controller.quantity,
          maxQuantity: controller.maxQuantity,
          onQuantityChanged: controller.setQuantity,
          onRemove: controller.reset,
        ),

        // Or pass controller directly for auto-wiring
        CartStepper(
          quantity: 0, // ignored when controller is provided
          controller: controller,
        ),

        // Async with controller
        AsyncCartStepper(
          quantity: controller.quantity,
          isLoading: controller.isLoading,
          onQuantityChangedAsync: (qty) => controller.setQuantityAsync(
            qty, () => api.updateCart(itemId, qty),
          ),
        ),
      ],
    );
  }
}
```

### Controller API

The controller exposes a rich API for programmatic control:

```dart
final controller = CartStepperController<int>(initialQuantity: 0);

// Properties
controller.quantity;          // Current quantity
controller.displayQuantity;  // Effective quantity (pending or actual)
controller.isExpanded;       // Whether stepper is expanded
controller.isLoading;        // Whether async operation is in progress
controller.canIncrement;     // Whether increment is possible
controller.canDecrement;     // Whether decrement is possible
controller.isAtMin;          // Whether quantity is at minimum
controller.isAtMax;          // Whether quantity is at maximum
controller.hasPendingOperation; // Whether there's a pending operation

// Sync methods
controller.setQuantity(5);
controller.increment();
controller.decrement();
controller.reset();
controller.expand();
controller.collapse();
controller.setToMax();
controller.setToMin();
controller.cancelOperation();

// Async methods
await controller.setQuantityAsync(5, () => api.updateCart(5), optimistic: true);
await controller.incrementAsync((newQty) => api.updateCart(newQty));
await controller.decrementAsync((newQty) => api.updateCart(newQty));
await controller.resetAsync(() => api.removeFromCart());

// Serialization
final json = controller.toJson();
final restored = json.toCartStepperController();
```

### Controller with State Management

```dart
// With Provider
ChangeNotifierProvider(
  create: (_) => CartStepperController(initialQuantity: 0),
)

// With Riverpod
final cartItemProvider = ChangeNotifierProvider(
  (ref) => CartStepperController(initialQuantity: 0),
);
```

## Theming

Apply consistent styling across multiple steppers:

```dart
CartStepperTheme(
  data: CartStepperThemeData(
    style: CartStepperStyle(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
    ),
    size: CartStepperSize.normal,
    animation: CartStepperAnimation.smooth,
    addToCartConfig: AddToCartButtonConfig.addButton,
    longPressConfig: CartStepperLongPressConfig(enabled: true),
    collapseConfig: CartStepperCollapseConfig(
      autoCollapseDelay: Duration(seconds: 5),
    ),
    iconConfig: CartStepperIconConfig(
      collapsedBadgeIcon: Icons.shopping_cart,
    ),
    manualInputConfig: CartStepperManualInputConfig(enabled: true),
    loadingConfig: CartStepperLoadingConfig.fast,
  ),
  child: Column(
    children: [
      ThemedCartStepper(quantity: 1, onQuantityChanged: (qty) {}),
      ThemedCartStepper(quantity: 2, onQuantityChanged: (qty) {}),
      ThemedCartStepper(
        quantity: 3,
        size: CartStepperSize.compact, // Override theme size
        onQuantityChanged: (qty) {},
      ),
    ],
  ),
)
```

`ThemedCartStepper` supports both sync and async callbacks. It looks up the nearest `CartStepperTheme` and applies its settings, with local overrides taking precedence.

## Composite Widgets

### CartProductTile

A complete product tile with integrated stepper:

```dart
CartProductTile(
  leading: Image.network(product.imageUrl),
  title: product.name,
  subtitle: 'In stock',
  price: '\$${product.price}',
  quantity: quantity,
  onQuantityChanged: (qty) => updateCart(product.id, qty),
  onRemove: () => removeFromCart(product.id),
  stepperSize: CartStepperSize.compact,
  stepperStyle: CartStepperStyle.defaultOrange,
  onTap: () => navigateToProduct(product.id),
  borderRadius: 12,
)
```

### CartStepperGroup

For variant selection (sizes, colors):

```dart
CartStepperGroup(
  items: [
    CartStepperGroupItem(id: 'small', quantity: 0, label: 'S'),
    CartStepperGroupItem(id: 'medium', quantity: 1, label: 'M'),
    CartStepperGroupItem(id: 'large', quantity: 0, label: 'L'),
  ],
  onQuantityChanged: (index, qty) {
    setState(() => sizes[index] = qty);
  },
  maxTotalQuantity: 10,
  onTotalChanged: (total) => print('Total: $total'),
)
```

**Selection modes:**

```dart
// Single selection (radio-style: only one item can have quantity > 0)
CartStepperGroup(
  items: colorVariants,
  selectionMode: CartStepperSelectionMode.single,
  onQuantityChanged: (index, qty) { ... },
  onSelectionChanged: (selectedIndices) { ... },
)

// Async group with loading indicators
CartStepperGroup(
  items: variants,
  onQuantityChangedAsync: (index, qty) async {
    await api.updateVariant(index, qty);
  },
  onError: (error, stack) => showError(error),
)

// Themed group (picks up CartStepperTheme from context)
CartStepperGroup(
  items: variants,
  themed: true,
  onQuantityChanged: (index, qty) { ... },
)
```

**Group items** support typed associated data:

```dart
CartStepperGroupItem<ProductVariant>(
  id: 'red-m',
  quantity: 0,
  label: 'Red - M',
  data: ProductVariant(color: 'red', size: 'm'),
  minQuantity: 0,
  maxQuantity: 10,
)
```

### CartBadge

Display cart count on icons with animated transitions:

```dart
CartBadge(
  count: totalItems,
  child: Icon(Icons.shopping_cart),
)
```

With customization:

```dart
CartBadge(
  count: totalItems,
  badgeColor: Colors.red,
  textColor: Colors.white,
  size: 20,
  maxCount: 99,          // Shows "99+" for higher counts
  showZero: false,       // Hide badge when count is 0
  alignment: Alignment.topRight,
  offset: EdgeInsets.only(top: -4, right: -4),
  child: Icon(Icons.shopping_cart, size: 28),
)
```

## Extracted Widgets

These standalone widgets are exported for use in custom implementations.

### StepperButton

A reusable button with the same styling used internally by the stepper:

```dart
StepperButton(
  icon: Icons.add,
  onPressed: () => handleAdd(),
)
```

### AnimatedCounter

An animated number display with slide transitions, used by the stepper for quantity changes:

```dart
AnimatedCounter(
  count: currentCount,
)
```

## Error Types

The package provides a sealed error hierarchy for precise error handling in async operations:

| Error Class | When Thrown |
|---|---|
| `CartStepperValidationError` | Quantity validation fails |
| `CartStepperOperationError` | Async operation (API call) fails |
| `CartStepperTimeoutError` | Async operation times out |
| `CartStepperCancellationError` | Operation cancelled (new operation started or widget disposed) |
| `CartStepperBusyError` | Operation attempted while another is in progress |

All error types extend the sealed `CartStepperError` base class, enabling exhaustive `switch` expressions:

```dart
AsyncCartStepper(
  quantity: quantity,
  errorBuilder: (context, error, retry) {
    return switch (error) {
      CartStepperValidationError(:final attemptedQuantity) =>
        Text('Cannot set to $attemptedQuantity'),
      CartStepperOperationError(:final operationType) =>
        TextButton(onPressed: retry, child: Text('Retry $operationType')),
      CartStepperTimeoutError() =>
        Text('Request timed out'),
      CartStepperCancellationError() =>
        SizedBox.shrink(),
      CartStepperBusyError() =>
        Text('Please wait...'),
    };
  },
  onQuantityChangedAsync: (qty) async { ... },
)
```

Helper types for operation results:

```dart
// OperationResult is a sealed type with two subtypes:
// - OperationSuccess
// - OperationFailure
```

## Tips, Gotchas

This section documents non-obvious behaviors, subtle edge cases, and practical tips that go beyond the basic API documentation. Read this before shipping to production.

### `minQuantity` Must Be > 0

Despite the doc comments saying "Defaults to 0", the actual default is `1` and the widget enforces `minQuantity > 0` via assertion. Passing `minQuantity: 0` will crash in debug mode.

```dart
// BAD — crashes in debug mode
CartStepper(quantity: 1, minQuantity: 0, onQuantityChanged: (qty) {})

// GOOD — minimum is 1 or higher
CartStepper(quantity: 1, minQuantity: 1, onQuantityChanged: (qty) {})
```

This also means the "Add" button always sets quantity to `minQuantity` (not 0), and `controller.reset()` resets to `minQuantity` (not 0). There is no concept of "quantity = 0" in the widget -- quantity 0 is the collapsed/empty state where the "Add to Cart" button is shown.

### Always Provide `onError` for Async Operations

When using `AsyncCartStepper`, if no `onError` callback is provided and an async operation fails, the error is **silently swallowed in release builds**. You won't see any crash, log, or trace -- the stepper simply gets stuck in a failed state.

```dart
// BAD — errors vanish silently in production
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty); // if this throws... silence
  },
)

// GOOD — always handle errors
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
  onError: (error, stackTrace) {
    log('Cart update failed', error: error, stackTrace: stackTrace);
    showErrorSnackBar('Failed to update cart');
  },
)
```

For visual error feedback, also provide an `errorBuilder`:

```dart
AsyncCartStepper(
  quantity: quantity,
  onQuantityChangedAsync: (qty) async { ... },
  onError: (error, stack) => log('Error', error: error),
  errorBuilder: (context, error, retry) {
    return TextButton(onPressed: retry, child: Text('Retry'));
  },
)
```

### Long Press Is Silently Disabled for Async

When you use `onQuantityChangedAsync`, long-press rapid-fire is **disabled by default** with no visual indication. The user holds the button and nothing happens beyond the first tap.

This is intentional to prevent queuing many concurrent API calls, but it can confuse users. You have three options:

```dart
// Option 1: Explicitly allow long press for async (careful — can queue many API calls)
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(allowLongPressForAsync: true),
  onQuantityChangedAsync: (qty) async { ... },
)

// Option 2: Use debounce mode — long press is automatically allowed
// (only one API call fires at the end, so it's safe)
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async { ... },
)

// Option 3: Disable long press entirely to make it explicit
AsyncCartStepper(
  quantity: quantity,
  longPressConfig: CartStepperLongPressConfig.disabled,
  onQuantityChangedAsync: (qty) async { ... },
)
```

### Long Press Never Triggers Removal

Even during a long-press decrement hold, the stepper will **stop at `minQuantity`** and never trigger deletion. Only a **single tap** on the decrement/delete button when at `minQuantity` triggers `onRemove` / `onRemoveAsync`. This is intentional to prevent accidental deletions during rapid adjustment.

### Optimistic Updates: Server Must Confirm Exact Value

When using `optimisticUpdate: true`, the widget shows a pending value immediately and waits for the server to "confirm" it by matching `widget.quantity` to the pending value. If the server returns a **different** quantity (e.g., you sent 10 but server capped it to 8), the optimistic value **persists** until the async operation completes.

```dart
// If the server might return a different quantity than requested,
// make sure to update widget.quantity from the server response:
AsyncCartStepper(
  quantity: serverQuantity, // always use the server-confirmed value
  asyncBehavior: CartStepperAsyncBehavior.optimistic,
  onQuantityChangedAsync: (qty) async {
    final confirmedQty = await api.updateCart(itemId, qty);
    setState(() => serverQuantity = confirmedQty); // use server's response
  },
)
```

### `revertOnError: false` Can Cause Stuck State

When `optimisticUpdate: true` and `revertOnError: false`, if the async operation fails, the pending optimistic value is **never cleared**. The display stays stuck on the pending value forever.

```dart
// DANGEROUS — stuck pending value on error
asyncBehavior: CartStepperAsyncBehavior(
  optimisticUpdate: true,
  revertOnError: false, // pending value stays if API fails
)

// SAFE — revert on error is the default
asyncBehavior: CartStepperAsyncBehavior(
  optimisticUpdate: true,
  revertOnError: true, // default — reverts to pre-operation value
)
```

### Loading Has a Minimum Duration of 300ms

Even if your async operation completes in 10ms, the loading spinner shows for at least 300ms by default. This prevents visual "flicker" but can feel slow for fast operations.

```dart
// Use the fast preset to reduce minimum loading to 150ms
AsyncCartStepper(
  quantity: quantity,
  loadingConfig: CartStepperLoadingConfig.fast,
  onQuantityChangedAsync: (qty) async { ... },
)

// Or customize it directly
AsyncCartStepper(
  quantity: quantity,
  loadingConfig: CartStepperLoadingConfig(
    minimumDuration: Duration(milliseconds: 100), // shorter
    showDelay: Duration(milliseconds: 200), // don't show spinner for fast ops
  ),
  onQuantityChangedAsync: (qty) async { ... },
)
```

The `showDelay` parameter delays showing the spinner. Combined with a fast API, you can avoid showing the spinner entirely for quick operations while still showing it for slow ones.

### `autoCollapseDelay` Changes Initial Expand State

Setting `autoCollapseDelay` has a surprising side effect: the stepper starts **collapsed** even when `quantity > 0`, unless you also explicitly set `initiallyExpanded: true`.

```dart
// SURPRISE — stepper starts collapsed even though quantity is 5
AsyncCartStepper(
  quantity: 5,
  collapseConfig: CartStepperCollapseConfig(
    autoCollapseDelay: Duration(seconds: 3),
  ),
  onQuantityChanged: (qty) {},
)

// FIX — explicitly start expanded
AsyncCartStepper(
  quantity: 5,
  collapseConfig: CartStepperCollapseConfig(
    autoCollapseDelay: Duration(seconds: 3),
    initiallyExpanded: true, // now it starts expanded, then auto-collapses
  ),
  onQuantityChanged: (qty) {},
)
```

### Async Operations Are Not Cancelled Server-Side

When a new operation supersedes an old one (or the widget is disposed), the old API call **keeps running on the server**. Only the UI update from the stale result is suppressed. If your API calls have side effects (charging a card, sending emails), ensure your server handles duplicate/overlapping requests gracefully (idempotency).

### Controller `reset()` and `collapse()` Don't Remove Items

Both `controller.reset()` and `controller.collapse()` set quantity to `minQuantity` (default 1), **not** 0. There is no controller method to "remove from cart" (set quantity below `minQuantity`). Use `onRemove` / `onRemoveAsync` callbacks for item removal.

### Controller `setQuantity()` Skips Validation

Calling `controller.setQuantity(value)` bypasses the `validator` callback. Only `increment()`, `decrement()`, `incrementAsync()`, and `decrementAsync()` call the validator. If you need to enforce validation on direct quantity changes, validate before calling `setQuantity()`.

```dart
// Validator is NOT called here
controller.setQuantity(50);

// Validator IS called here
controller.increment(); // calls validator(current, current + step)
```

### Controller `setQuantity()` Silently Cancels In-Flight Async

Calling `controller.setQuantity()` while an async operation is in progress silently increments the internal operation ID and clears the loading state. The running API call completes on the server but its result is ignored, and `onOperationCancelled` is **not** called.

### Priority Order: Controller > Stream > Widget Quantity

When multiple quantity sources are provided, the priority is:

1. `controller.quantity` (highest)
2. `quantityStream` latest value
3. `widget.quantity` (lowest)

If you provide both a controller and a `quantityStream`, the stream is **completely ignored** with no warning.

### `ThemedCartStepper` Drops Config in Sync Mode

When `ThemedCartStepper` is used without any async callbacks, it falls back to the sync `CartStepper` which does **not** support `longPressConfig`, `collapseConfig`, `iconConfig`, `manualInputConfig`, `quantityFormatter`, or `deleteViaQuantityChange`. These theme properties are silently dropped. To use these features, provide at least one async callback (even if you don't need async behavior).

### `CartStepperGroup` Ignores Theme by Default

Unlike `ThemedCartStepper`, `CartStepperGroup` does **not** pick up `CartStepperTheme` from context by default. You must explicitly opt in:

```dart
// Theme is IGNORED
CartStepperGroup(items: items, onQuantityChanged: (i, qty) {})

// Theme is applied
CartStepperGroup(items: items, themed: true, onQuantityChanged: (i, qty) {})
```

### `CartStepperGroup` Uses `compact` Size by Default

`CartStepperGroup` defaults to `CartStepperSize.compact`, while standalone steppers default to `CartStepperSize.normal`. This can cause visual inconsistency if you use both without explicit sizing.

### `CartProductTile` Is Sync-Only

`CartProductTile` internally uses `CartStepper` (sync), not `AsyncCartStepper`. There is no way to use async callbacks, loading indicators, or advanced features through `CartProductTile`. Build a custom tile layout if you need async support.

### Manual Input Allows Decimals for `int` Steppers

The manual input field allows decimal points (e.g., "5.5") even when the stepper type is `int`. The value is parsed and silently **truncated** (not rounded). Consider providing a custom `manualInputConfig.builder` if you need stricter input validation.

### Manual Input Submits on Focus Loss

When manual input is active and the field loses focus (tapping elsewhere, keyboard dismiss), the current value is **automatically submitted** -- not cancelled. If you want cancel-on-blur behavior, use a custom `manualInputConfig.builder`.

### Undo State Shows `minQuantity`, Not Zero

During the undo-after-delete countdown, the displayed quantity shows `minQuantity` (e.g., 1), not 0. This is because the widget doesn't have a concept of "zero quantity display" during active operation. Consider providing a custom `undoConfig.builder` if you want different undo visuals.

### `toCartStepperController()` JSON Extension Has Wrong Defaults

The `Map<String, dynamic>.toCartStepperController()` extension defaults `minQuantity` to `0`, which violates the `minQuantity > 0` assertion and will crash in debug mode. Always provide explicit values when using JSON deserialization:

```dart
// BAD — crashes if 'minQuantity' key is missing
final controller = jsonMap.toCartStepperController();

// GOOD — provide the values explicitly
final controller = CartStepperController<int>(
  initialQuantity: jsonMap['quantity'] as int? ?? 1,
  minQuantity: jsonMap['minQuantity'] as int? ?? 1,
  maxQuantity: jsonMap['maxQuantity'] as int? ?? 99,
);
```

### Large `step` Values Can Disable Increment

If `step` is larger than `maxQuantity - currentQuantity`, the increment button appears **disabled** even though the clamped result would be valid. For example, with `step: 5`, `currentQuantity: 1`, `maxQuantity: 3`, the button is disabled even though incrementing to 3 would be a valid clamped result.

```dart
// Be careful with large step values relative to your range
CartStepper(
  quantity: 1,
  step: 5,
  maxQuantity: 3, // increment button will be disabled!
  onQuantityChanged: (qty) {},
)
```

### Non-Blocking UI: Keeping the Stepper Responsive

By default, when an async operation is in flight, the stepper **blocks all interaction** -- buttons are disabled and a loading spinner replaces the quantity. This is the safest behavior, but it can feel sluggish. Here's how each mechanism blocks (or doesn't block) the UI, and how to keep things feeling instant.

#### What Blocks What

| State | +/- Buttons | Add Button | Manual Input | Quantity Display |
|---|---|---|---|---|
| `_isLoading` (no optimistic) | **Disabled** | **Disabled** | **Disabled** | Shows spinner |
| `_isLoading` + `optimisticUpdate` | Enabled | Enabled | **Disabled** | Shows pending qty |
| `_isLoading` + `disableButtonsDuringLoading: false` | Enabled | **Disabled** | **Disabled** | Shows spinner |
| Debounce waiting (before API fires) | Enabled | Enabled | Enabled | Shows debounced qty |
| `enabled: false` | **Disabled** | **Disabled** | **Disabled** | Normal display |
| External `isLoading: true` | **Disabled** | **Disabled** | **Disabled** | Shows spinner |

> **Key insight:** Manual input is **always** blocked during loading, regardless of `optimisticUpdate`. There is no override for this.

#### Strategy 1: Optimistic Updates (Instant Feedback, Spinner in Background)

The quantity updates instantly. Buttons stay enabled. The spinner does **not** appear -- instead, the new quantity is shown immediately. If the API fails, it reverts.

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: true,
    revertOnError: true,
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

**UI behavior:** User taps + -> display shows new quantity instantly -> API runs in background -> if error, display reverts. No spinner, no disabled state. The user can keep tapping freely.

#### Strategy 2: Debounce (Accumulate Taps, One API Call)

The UI updates locally on every tap. No API call fires during tapping. One call fires after the user pauses. Loading spinner only appears during the actual API call.

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

**UI behavior:** User taps +++ -> display shows 1, 2, 3 locally -> 500ms idle -> loading spinner appears briefly -> API call completes. The stepper is fully interactive during the debounce wait, including long press.

#### Strategy 3: Debounce + Optimistic (Maximum Responsiveness)

Combines both: instant local updates, batched API call, no spinner during accumulation, and buttons stay enabled even during the API call.

```dart
AsyncCartStepper(
  quantity: quantity,
  asyncBehavior: CartStepperAsyncBehavior(
    optimisticUpdate: true,
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

**UI behavior:** Fully non-blocking. User can tap freely at all times. One API call fires after pausing. On error, reverts to the value before the accumulation started.

#### Strategy 4: Keep Buttons Enabled During Loading (Without Optimistic)

If you don't want optimistic updates but still want buttons enabled during loading (so the user can queue the next change), disable the button-blocking:

```dart
AsyncCartStepper(
  quantity: quantity,
  loadingConfig: CartStepperLoadingConfig(
    disableButtonsDuringLoading: false, // buttons stay enabled
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

**UI behavior:** Spinner appears in the quantity area, but +/- buttons remain tappable. The new operation supersedes the old one (the old API call still runs server-side but its result is ignored).

> **Note:** The Add button (collapsed state) is **always** disabled during loading regardless of `disableButtonsDuringLoading`. Only the expanded +/- buttons respect this setting.

#### Strategy 5: Hide the Spinner for Fast Operations

Use `showDelay` to only show the spinner if the operation takes longer than expected:

```dart
AsyncCartStepper(
  quantity: quantity,
  loadingConfig: CartStepperLoadingConfig(
    showDelay: Duration(milliseconds: 300), // wait 300ms before showing spinner
    minimumDuration: Duration(milliseconds: 150), // if shown, show for at least 150ms
  ),
  onQuantityChangedAsync: (qty) async {
    await api.updateCart(itemId, qty);
    setState(() => quantity = qty);
  },
)
```

**UI behavior:** If the API responds within 300ms, the user never sees a spinner -- it feels instant. If it takes longer, the spinner appears and stays for at least 150ms to avoid flicker.

#### Avoid: External `isLoading` with Debounce

Setting `isLoading` externally during debounce mode blocks all taps and defeats the purpose of debouncing:

```dart
// BAD — blocks interaction during the debounce window
AsyncCartStepper(
  quantity: quantity,
  isLoading: _myLoadingFlag, // overrides internal state, blocks taps
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async { ... },
)

// GOOD — let the widget manage loading internally
AsyncCartStepper(
  quantity: quantity,
  // isLoading: don't set it
  asyncBehavior: CartStepperAsyncBehavior(
    debounceDelay: Duration(milliseconds: 500),
  ),
  onQuantityChangedAsync: (qty) async { ... },
)
```

#### Quick Reference: Which Strategy to Use

| Scenario | Strategy | Config |
|---|---|---|
| Fast API (< 200ms) | Show delay | `loadingConfig: CartStepperLoadingConfig(showDelay: Duration(milliseconds: 200))` |
| Shopping cart (frequent updates) | Debounce | `asyncBehavior: CartStepperAsyncBehavior(debounceDelay: Duration(milliseconds: 500))` |
| Instant feel, safe revert | Optimistic | `asyncBehavior: CartStepperAsyncBehavior.optimistic` |
| Maximum responsiveness | Debounce + Optimistic | `asyncBehavior: CartStepperAsyncBehavior(optimisticUpdate: true, debounceDelay: Duration(milliseconds: 500))` |
| Slow API, allow queuing | Keep buttons enabled | `loadingConfig: CartStepperLoadingConfig(disableButtonsDuringLoading: false)` |
| Server-authoritative, strict | Default | No config needed (default behavior) |

### Assertions Only Run in Debug Mode

All parameter validation (`minQuantity > 0`, `maxQuantity > minQuantity`, `step > 0`, controller exclusivity) is done via Dart `assert()`, which is stripped in release builds. Invalid parameters won't crash in production but may cause unexpected behavior. Always test thoroughly in debug mode first.

## Migration Guide

See [MIGRATION.md](MIGRATION.md) for a detailed guide on migrating from v1.x to v2.0.0, including the new widget split, config objects, generic type support, and all new features.

## Example App

See the [example](example/) folder for a complete demo showcasing all features.

```bash
cd example
flutter create .
flutter run
```

## Contributing

Contributions are welcome! Here's how to get started:

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:

```bash
git clone https://github.com/your-username/advance_cart_stepper.git
cd advance_cart_stepper
```

3. **Install dependencies**:

```bash
flutter pub get
```

4. **Create a branch** for your change:

```bash
git checkout -b feature/my-feature
```

5. **Make your changes** and ensure everything passes:

```bash
dart analyze lib/ example/
dart format lib/ example/ --set-exit-if-changed
flutter test
```

6. **Run the example app** to verify your changes visually:

```bash
cd example
flutter create .
flutter run
```

7. **Commit** your changes with a clear message:

```bash
git commit -m "feat: add my new feature"
```

8. **Push** to your fork and **open a Pull Request** against the `main` branch

### Guidelines

- Follow the existing code style and conventions
- Add documentation comments for any new public API
- Update the example app if adding new features
- Update `README.md` and `MIGRATION.md` if the change affects the public API
- Keep PRs focused -- one feature or fix per PR

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
