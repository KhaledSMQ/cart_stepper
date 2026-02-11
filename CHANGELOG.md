# Changelog

All notable changes to this project will be documented in this file.

## 2.0.1

### Documentation

- Added **Deep Dive: Throttle vs Debounce** section explaining the two async execution strategies with flow diagrams and comparison table
- Added **`isLoading` and Async Modes** section documenting external vs internal loading state interactions and the debounce gotcha
- Added **Best Practices & Common Patterns** with 5 production-ready async configuration patterns
- Added **Non-Blocking UI** guide with strategy matrix showing which config combinations keep the stepper responsive
- Added **Tips, Gotchas & Hidden Behaviors** section covering 22+ non-obvious behaviors, edge cases, and practical tips for production use

## 2.0.0

### Breaking Changes

- **Split `CartStepper` into two widgets:**
  - **`CartStepper<T>`** - Simple, ~20 parameters, synchronous only, supports generic `num` types
  - **`AsyncCartStepper<T>`** - Full-featured, ~35 parameters (organized into config objects), supports async operations, undo, streams, and more
- **Flat parameters reorganized into config objects** for better API clarity:
  - `CartStepperAsyncBehavior` - async settings (optimistic updates, debounce, throttle)
  - `CartStepperLongPressConfig` - long press behavior
  - `CartStepperManualInputConfig` - manual input settings
  - `CartStepperCollapseConfig` - auto-collapse behavior
  - `CartStepperIconConfig` - icon customization
- **`separateIcon` renamed to `collapsedBadgeIcon`** (via `CartStepperIconConfig`)
- **`QuantityFormatters` now accept `num` instead of `int`**
- **`ThemedCartStepper` is now generic** (`ThemedCartStepper<T extends num>`)
- **`CartStepperThemeData` uses config objects** instead of flat parameters

### New Features

- **Generic type support** - `CartStepper<double>(quantity: 1.5, ...)` for decimal quantities
- **Detailed quantity changed callback** - `onDetailedQuantityChanged: (newQty, oldQty, type) {}`
- **RTL / directionality support** - `textDirection: TextDirection.rtl`
- **Vertical layout** - `direction: CartStepperDirection.vertical`
- **Expand/collapse callbacks** - `onExpanded` / `onCollapsed`
- **Controller integration** - `controller: myController` for external state management
- **Reactive streams** - `quantityStream: myStream` for stream-based updates
- **Async validator** - `asyncValidator: (current, next) async => ...`
- **Expanded builder** - `expandedBuilder: (ctx, qty, inc, dec, loading) => ...`
- **Transition builder** - `animation: CartStepperAnimation(transitionBuilder: ...)`
- **Undo after delete** - `undoConfig: CartStepperUndoConfig(...)` for undo support
- **Group total callback** - `onTotalChanged: (total) {}` for `CartStepperGroup`
- **Group async support** - `onQuantityChangedAsync: (index, qty) async {}` for groups
- **Group selection mode** - `CartStepperSelectionMode.single`
- **Config object presets** - `CartStepperLongPressConfig.fast`, `CartStepperAsyncBehavior.optimistic`, etc.

### Improvements

- Refactored internal architecture with modular builder/facade/operations pattern
- Improved code organization and maintainability
- Enhanced analysis options for stricter linting
- Expanded test coverage
- Comprehensive example app with all feature demonstrations
- Added migration guide (`MIGRATION.md`)

## 1.0.0

Initial release of Advance Cart Stepper.

### Features

- **CartStepper Widget** - Expandable cart quantity stepper with smooth animations
- **Size Variants** - Compact (32px), Normal (40px), and Large (48px) presets
- **Add-to-Cart Styles** - Circle icon, text buttons, and customizable configurations
- **Async Support** - Built-in loading indicators with 15+ SpinKit animations
- **Optimistic Updates** - Instant UI feedback with automatic error revert
- **Debounce Mode** - Batch rapid changes into single API calls
- **Error Handling** - onError callback and errorBuilder for inline error display
- **Validation** - Custom validators with rejection callbacks
- **Long Press** - Hold buttons for rapid increment/decrement
- **Auto-Collapse** - Collapse to badge view after inactivity
- **Quantity Formatters** - Built-in abbreviation (1.5k, 2M) and max indicators (99+)
- **Manual Input** - Tap quantity to type directly with keyboard
- **Theming** - CartStepperTheme for consistent styling across widgets
- **Haptic Feedback** - Optional haptics on button interactions
- **Theme-Aware Colors** - CartBadge uses theme colors by default

### Components

- **CartStepper** - Main stepper widget
- **CartStepperController** - External state management with ChangeNotifier
- **CartBadge** - Display count badges on icons
- **CartStepperGroup** - Horizontal variant selection with generic type support
- **CartProductTile** - Complete product tile with integrated stepper
- **ThemedCartStepper** - Theme-aware stepper variant
- **AnimatedCounter** - Standalone animated number display
- **StepperButton** - Reusable button with long-press support

### Configuration Classes

- **CartStepperStyle** - Colors, borders, typography customization
- **CartStepperAnimation** - Duration, curves, haptics configuration
- **CartStepperLoadingConfig** - Loading indicator type and behavior
- **AddToCartButtonConfig** - Initial button appearance and behavior
- **CartStepperGroupItem** - Generic item with required `id` for stable keys
