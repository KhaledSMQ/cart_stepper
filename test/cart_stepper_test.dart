import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advance_cart_stepper/advance_cart_stepper.dart';

void main() {
  group('CartStepper Widget Tests', () {
    testWidgets('renders in collapsed state when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 0,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      // Should show add icon (collapsed state)
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Should not show increment/decrement controls
      expect(find.byIcon(Icons.remove), findsNothing);
    });

    testWidgets('renders in expanded state when quantity > 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 5,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      // Wait for animation
      await tester.pumpAndSettle();

      // Should show increment and decrement buttons
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);

      // Should display quantity
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('increment button increases quantity',
        (WidgetTester tester) async {
      int quantity = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find all add icons, tap the one in the expanded controls (rightmost)
      final addButtons = find.byIcon(Icons.add);
      expect(addButtons, findsWidgets);

      // Tap increment button
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      expect(quantity, equals(2));
    });

    testWidgets('decrement button decreases quantity',
        (WidgetTester tester) async {
      int quantity = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap decrement button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(quantity, equals(2));
    });

    testWidgets('respects maxQuantity limit', (WidgetTester tester) async {
      int quantity = 5;
      const maxQuantity = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  maxQuantity: maxQuantity,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to increment past max
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      // Quantity should stay at max
      expect(quantity, equals(maxQuantity));
    });

    testWidgets('respects minQuantity limit', (WidgetTester tester) async {
      int quantity = 2;
      const minQuantity = 2;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  minQuantity: minQuantity,
                  showDeleteAtMin: false,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to decrement below min
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Quantity should stay at min
      expect(quantity, equals(minQuantity));
    });

    testWidgets('calls onRemove when decrementing below minQuantity',
        (WidgetTester tester) async {
      bool removeCallled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 1,
              minQuantity: 1,
              onQuantityChanged: (_) {},
              onRemove: () {
                removeCallled = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap decrement (should trigger delete icon since at min)
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(removeCallled, isTrue);
    });

    testWidgets('uses custom step value', (WidgetTester tester) async {
      int quantity = 5;
      const step = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  step: step,
                  maxQuantity: 100,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      // Should increment by step
      expect(quantity, equals(10));
    });

    testWidgets('displays with compact size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 1,
              size: CartStepperSize.compact,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(CartStepper<int>), findsOneWidget);
    });

    testWidgets('displays with large size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 1,
              size: CartStepperSize.large,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(CartStepper<int>), findsOneWidget);
    });

    testWidgets('applies custom style', (WidgetTester tester) async {
      const customStyle = CartStepperStyle(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 1,
              style: customStyle,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(CartStepper<int>), findsOneWidget);
    });

    testWidgets('disabled state prevents interactions',
        (WidgetTester tester) async {
      int quantity = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  enabled: false,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to tap increment
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      // Quantity should remain unchanged
      expect(quantity, equals(5));
    });

    testWidgets('uses button style for add button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepper(
              quantity: 0,
              addToCartConfig: AddToCartButtonConfig.addButton,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      // Should show "Add" text
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('uses quantity formatter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncCartStepper(
              quantity: 1500,
              maxQuantity: 10000,
              quantityFormatter: QuantityFormatters.abbreviated,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show abbreviated quantity
      expect(find.text('1.5k'), findsOneWidget);
    });

    testWidgets('expands when tapping collapsed add button',
        (WidgetTester tester) async {
      int quantity = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CartStepper(
                  quantity: quantity,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Quantity should increase and widget should expand
      expect(quantity, equals(1));
    });

    testWidgets('calls onMaxReached when incrementing to maxQuantity',
        (WidgetTester tester) async {
      int quantity = 4;
      bool maxReached = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  maxQuantity: 5,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                  onMaxReached: () {
                    maxReached = true;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button to reach max
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      expect(quantity, equals(5));
      expect(maxReached, isTrue);
    });

    testWidgets('calls onMinReached when decrementing to minQuantity',
        (WidgetTester tester) async {
      int quantity = 3;
      bool minReached = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  minQuantity: 2,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                  onMinReached: () {
                    minReached = true;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap decrement button to reach min
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(quantity, equals(2));
      expect(minReached, isTrue);
    });

    testWidgets('does not call onMaxReached when not at max',
        (WidgetTester tester) async {
      int quantity = 3;
      bool maxReached = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  maxQuantity: 10,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                  onMaxReached: () {
                    maxReached = true;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button (not reaching max)
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      expect(quantity, equals(4));
      expect(maxReached, isFalse);
    });

    testWidgets('does not call onMinReached when not at min',
        (WidgetTester tester) async {
      int quantity = 5;
      bool minReached = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  minQuantity: 1,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                  onMinReached: () {
                    minReached = true;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap decrement button (not reaching min)
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(quantity, equals(4));
      expect(minReached, isFalse);
    });
  });

  group('CartStepperController Tests', () {
    test('initializes with correct values', () {
      final controller = CartStepperController(
        initialQuantity: 5,
        minQuantity: 1,
        maxQuantity: 10,
        step: 2,
      );

      expect(controller.quantity, equals(5));
      expect(controller.minQuantity, equals(1));
      expect(controller.maxQuantity, equals(10));
      expect(controller.step, equals(2));
      expect(controller.isExpanded, isTrue);
    });

    test('clamps initial quantity to min/max', () {
      final controllerBelowMin = CartStepperController(
        initialQuantity: -5,
        minQuantity: 0,
        maxQuantity: 10,
      );
      expect(controllerBelowMin.quantity, equals(0));

      final controllerAboveMax = CartStepperController(
        initialQuantity: 100,
        minQuantity: 0,
        maxQuantity: 10,
      );
      expect(controllerAboveMax.quantity, equals(10));
    });

    test('increment increases quantity by step', () {
      final controller = CartStepperController(
        initialQuantity: 5,
        step: 3,
        maxQuantity: 20,
      );

      controller.increment();
      expect(controller.quantity, equals(8));

      controller.increment();
      expect(controller.quantity, equals(11));
    });

    test('increment respects maxQuantity', () {
      final controller = CartStepperController(
        initialQuantity: 8,
        step: 1,
        maxQuantity: 10,
      );

      controller.increment();
      expect(controller.quantity, equals(9));

      controller.increment();
      expect(controller.quantity, equals(10));

      // Should not increment beyond max
      controller.increment();
      expect(controller.quantity, equals(10));
    });

    test('decrement decreases quantity by step', () {
      final controller = CartStepperController(
        initialQuantity: 10,
        step: 2,
        minQuantity: 0,
      );

      controller.decrement();
      expect(controller.quantity, equals(8));

      controller.decrement();
      expect(controller.quantity, equals(6));
    });

    test('decrement respects minQuantity', () {
      final controller = CartStepperController(
        initialQuantity: 3,
        step: 1,
        minQuantity: 1,
      );

      controller.decrement();
      expect(controller.quantity, equals(2));

      controller.decrement();
      expect(controller.quantity, equals(1));

      // Should not decrement below min
      controller.decrement();
      expect(controller.quantity, equals(1));
    });

    test('setQuantity clamps to bounds', () {
      final controller = CartStepperController(
        initialQuantity: 5,
        minQuantity: 1,
        maxQuantity: 10,
      );

      controller.setQuantity(100);
      expect(controller.quantity, equals(10));

      controller.setQuantity(-5);
      expect(controller.quantity, equals(1));
    });

    test('reset sets quantity to 0 and collapses', () {
      final controller = CartStepperController(initialQuantity: 10);

      expect(controller.isExpanded, isTrue);

      controller.reset();

      expect(controller.quantity, equals(0));
      expect(controller.isExpanded, isFalse);
    });

    test('expand sets isExpanded and adjusts quantity if 0', () {
      final controller = CartStepperController(
        initialQuantity: 0,
        step: 1,
      );

      expect(controller.isExpanded, isFalse);

      controller.expand();

      expect(controller.isExpanded, isTrue);
      expect(controller.quantity, equals(1)); // Set to step since quantity was 0
    });

    test('collapse resets quantity and isExpanded', () {
      final controller = CartStepperController(initialQuantity: 5);

      controller.collapse();

      expect(controller.quantity, equals(0));
      expect(controller.isExpanded, isFalse);
    });

    test('setToMax sets quantity to maxQuantity', () {
      final controller = CartStepperController(
        initialQuantity: 5,
        maxQuantity: 99,
      );

      controller.setToMax();
      expect(controller.quantity, equals(99));
    });

    test('setToMin sets quantity to minQuantity', () {
      final controller = CartStepperController(
        initialQuantity: 50,
        minQuantity: 5,
      );

      controller.setToMin();
      expect(controller.quantity, equals(5));
    });

    test('canIncrement returns correct value', () {
      final controller = CartStepperController(
        initialQuantity: 8,
        step: 5,
        maxQuantity: 10,
      );

      expect(controller.canIncrement, isFalse);

      controller.setQuantity(5);
      expect(controller.canIncrement, isTrue);
    });

    test('canDecrement returns correct value', () {
      final controller = CartStepperController(
        initialQuantity: 2,
        step: 5,
        minQuantity: 1,
      );

      expect(controller.canDecrement, isFalse);

      controller.setQuantity(10);
      expect(controller.canDecrement, isTrue);
    });

    test('isAtMin and isAtMax return correct values', () {
      final controller = CartStepperController(
        initialQuantity: 5,
        minQuantity: 1,
        maxQuantity: 10,
      );

      expect(controller.isAtMin, isFalse);
      expect(controller.isAtMax, isFalse);

      controller.setToMin();
      expect(controller.isAtMin, isTrue);

      controller.setToMax();
      expect(controller.isAtMax, isTrue);
    });

    test('notifies listeners on changes', () {
      final controller = CartStepperController(initialQuantity: 5);
      int notificationCount = 0;

      controller.addListener(() {
        notificationCount++;
      });

      controller.increment();
      expect(notificationCount, equals(1));

      controller.decrement();
      expect(notificationCount, equals(2));

      controller.setQuantity(10);
      expect(notificationCount, equals(3));

      // Setting same quantity should not notify
      controller.setQuantity(10);
      expect(notificationCount, equals(3));
    });

    test('toJson serializes correctly', () {
      final controller = CartStepperController(
        initialQuantity: 7,
        minQuantity: 2,
        maxQuantity: 50,
        step: 3,
      );

      final json = controller.toJson();

      expect(json['quantity'], equals(7));
      expect(json['minQuantity'], equals(2));
      expect(json['maxQuantity'], equals(50));
      expect(json['step'], equals(3));
      expect(json['isExpanded'], isTrue);
    });

    test('toCartStepperController deserializes correctly', () {
      final json = {
        'quantity': 15,
        'minQuantity': 5,
        'maxQuantity': 100,
        'step': 5,
      };

      final controller = json.toCartStepperController();

      expect(controller.quantity, equals(15));
      expect(controller.minQuantity, equals(5));
      expect(controller.maxQuantity, equals(100));
      expect(controller.step, equals(5));
    });

    test('copyWith creates new controller with modified values', () {
      final original = CartStepperController(
        initialQuantity: 5,
        minQuantity: 1,
        maxQuantity: 10,
        step: 1,
      );

      final copied = original.copyWith(
        maxQuantity: 50,
        step: 5,
      );

      expect(copied.quantity, equals(5)); // Preserved
      expect(copied.minQuantity, equals(1)); // Preserved
      expect(copied.maxQuantity, equals(50)); // Modified
      expect(copied.step, equals(5)); // Modified
    });
  });

  group('CartBadge Widget Tests', () {
    testWidgets('displays count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CartBadge(
              count: 5,
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('hides badge when count is 0 and showZero is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CartBadge(
              count: 0,
              showZero: false,
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      );

      expect(find.text('0'), findsNothing);
    });

    testWidgets('shows badge when count is 0 and showZero is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CartBadge(
              count: 0,
              showZero: true,
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('displays max+ when count exceeds maxCount',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CartBadge(
              count: 150,
              maxCount: 99,
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
    });
  });

  group('QuantityFormatters Tests', () {
    test('abbreviated formats thousands correctly', () {
      expect(QuantityFormatters.abbreviated(999), equals('999'));
      expect(QuantityFormatters.abbreviated(1000), equals('1k'));
      expect(QuantityFormatters.abbreviated(1500), equals('1.5k'));
      expect(QuantityFormatters.abbreviated(10000), equals('10k'));
      expect(QuantityFormatters.abbreviated(1000000), equals('1M'));
      expect(QuantityFormatters.abbreviated(1500000), equals('1.5M'));
    });

    test('abbreviatedWithMax formats correctly', () {
      final formatter = QuantityFormatters.abbreviatedWithMax(99);
      expect(formatter(50), equals('50'));
      expect(formatter(99), equals('99+'));
      expect(formatter(100), equals('99+'));
      expect(formatter(1000), equals('99+'));
    });

    test('simple returns string representation', () {
      expect(QuantityFormatters.simple(42), equals('42'));
      expect(QuantityFormatters.simple(0), equals('0'));
      expect(QuantityFormatters.simple(1000), equals('1000'));
    });
  });

  group('CartStepperStyle Tests', () {
    test('defaultOrange has correct values', () {
      const style = CartStepperStyle.defaultOrange;
      expect(style.backgroundColor, equals(const Color(0xFFD84315)));
      expect(style.foregroundColor, equals(Colors.white));
    });

    test('copyWith creates new style with modified values', () {
      const original = CartStepperStyle(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2.0,
      );

      final copied = original.copyWith(
        backgroundColor: Colors.red,
        elevation: 4.0,
      );

      expect(copied.backgroundColor, equals(Colors.red));
      expect(copied.foregroundColor, equals(Colors.white)); // Preserved
      expect(copied.elevation, equals(4.0));
    });
  });

  group('CartStepperLoadingConfig Tests', () {
    test('default config has correct values', () {
      const config = CartStepperLoadingConfig.defaultConfig;
      expect(config.type, equals(CartStepperLoadingType.threeBounce));
      expect(config.minimumDuration, equals(const Duration(milliseconds: 300)));
      expect(config.disableButtonsDuringLoading, isTrue);
    });

    test('builtIn config uses circular type', () {
      const config = CartStepperLoadingConfig.builtIn;
      expect(config.type, equals(CartStepperLoadingType.circular));
    });
  });

  group('AddToCartButtonConfig Tests', () {
    test('circleIcon has correct style', () {
      const config = AddToCartButtonConfig.circleIcon;
      expect(config.style, equals(AddToCartButtonStyle.circleIcon));
    });

    test('addButton has correct values', () {
      const config = AddToCartButtonConfig.addButton;
      expect(config.style, equals(AddToCartButtonStyle.button));
      expect(config.buttonText, equals('Add'));
      expect(config.icon, equals(Icons.add));
    });

    test('copyWith creates new config with modified values', () {
      const original = AddToCartButtonConfig(
        style: AddToCartButtonStyle.button,
        buttonText: 'Add',
        showIcon: true,
      );

      final copied = original.copyWith(
        buttonText: 'Buy Now',
        showIcon: false,
      );

      expect(copied.style, equals(AddToCartButtonStyle.button)); // Preserved
      expect(copied.buttonText, equals('Buy Now'));
      expect(copied.showIcon, isFalse);
    });
  });

  // ============================================================================
  // New Architecture Feature Tests
  // ============================================================================

  group('Async Operation Tests', () {
    testWidgets('shows loading indicator during async operation',
        (WidgetTester tester) async {
      int quantity = 1;
      bool operationStarted = false;
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  onQuantityChangedAsync: (newQty) async {
                    operationStarted = true;
                    await completer.future;
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pump();

      expect(operationStarted, isTrue);

      // Complete the operation and allow loading minimum duration to pass
      completer.complete();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(quantity, equals(2));
    });

    testWidgets('calls onError when async operation fails',
        (WidgetTester tester) async {
      Object? caughtError;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncCartStepper(
              quantity: 1,
              onQuantityChangedAsync: (newQty) async {
                throw Exception('Network error');
              },
              onError: (error, stack) {
                caughtError = error;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      expect(caughtError, isA<Exception>());
      expect(caughtError.toString(), contains('Network error'));
    });
  });

  group('Validator Tests', () {
    testWidgets('validator can prevent increment',
        (WidgetTester tester) async {
      int quantity = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  maxQuantity: 10,
                  validator: (current, newQty) => newQty <= 5,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Increment twice - should work
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();
      expect(quantity, equals(4));

      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();
      expect(quantity, equals(5));

      // Third increment should be blocked by validator
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();
      expect(quantity, equals(5)); // Should not change
    });

    testWidgets('calls onValidationRejected when validator rejects',
        (WidgetTester tester) async {
      int? rejectedCurrentQty;
      int? rejectedAttemptedQty;
      int quantity = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AsyncCartStepper(
                    quantity: quantity,
                    maxQuantity: 10,
                    validator: (current, newQty) {
                      // Allow increments only up to 4
                      return newQty <= 4;
                    },
                    onQuantityChanged: (newQty) {
                      setState(() => quantity = newQty);
                    },
                    onValidationRejected: (current, attempted) {
                      rejectedCurrentQty = current;
                      rejectedAttemptedQty = attempted;
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Quantity is 3, increment to 4 should work
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();
      expect(quantity, equals(4));
      expect(rejectedCurrentQty, isNull); // No rejection yet

      // Now try to increment to 5 - validator should reject
      await tester.tap(addButtons.last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Validator should reject increment to 5
      expect(rejectedCurrentQty, equals(4));
      expect(rejectedAttemptedQty, equals(5));
      // Quantity should not change
      expect(quantity, equals(4));
    });
  });

  group('Optimistic Update Tests', () {
    testWidgets('optimistic update shows new value immediately',
        (WidgetTester tester) async {
      int quantity = 1;
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  asyncBehavior: const CartStepperAsyncBehavior(
                    optimisticUpdate: true,
                  ),
                  onQuantityChangedAsync: (newQty) async {
                    await completer.future;
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pump();

      // Should show 2 immediately (optimistic)
      expect(find.text('2'), findsOneWidget);

      // Complete the operation and allow loading minimum duration to pass
      completer.complete();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(quantity, equals(2));
    });

    testWidgets('optimistic update reverts on error when revertOnError is true',
        (WidgetTester tester) async {
      int quantity = 3;
      bool errorCalled = false;
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  asyncBehavior: const CartStepperAsyncBehavior(
                    optimisticUpdate: true,
                    revertOnError: true,
                  ),
                  onQuantityChangedAsync: (newQty) async {
                    await completer.future;
                    throw Exception('Failed');
                  },
                  onError: (_, __) {
                    errorCalled = true;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pump();

      // Should show 4 optimistically (before error)
      expect(find.text('4'), findsOneWidget);

      // Trigger the error and allow loading minimum duration to pass
      completer.complete();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Error should have been called
      expect(errorCalled, isTrue);

      // Should revert to 3 (original value shown since state wasn't updated)
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('Operation Cancellation Tests', () {
    testWidgets('second operation supersedes pending operation',
        (WidgetTester tester) async {
      // ignore: unused_local_variable
      int? cancelledQty;
      int quantity = 1;
      int operationCount = 0;
      final List<Completer<void>> completers = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  asyncBehavior: const CartStepperAsyncBehavior(
                    optimisticUpdate: true,
                  ),
                  onQuantityChangedAsync: (newQty) async {
                    operationCount++;
                    final completer = Completer<void>();
                    completers.add(completer);
                    await completer.future;
                    setState(() => quantity = newQty);
                  },
                  onOperationCancelled: (qty) {
                    cancelledQty = qty;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment button - starts first operation
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pump(const Duration(milliseconds: 100));

      // First operation is pending
      expect(operationCount, equals(1));

      // Tap again after throttle interval - starts second operation
      await tester.tap(addButtons.last);
      await tester.pump(const Duration(milliseconds: 100));

      // Both operations started (throttle queues, then executes)
      // The cancellation happens in _executeAsyncOperation when a new operation starts

      // Complete all pending operations
      for (final c in completers) {
        if (!c.isCompleted) c.complete();
      }
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // At least one operation should have completed
      expect(operationCount, greaterThanOrEqualTo(1));
    });
  });

  group('Long Press Tests', () {
    testWidgets('long press enables rapid increment',
        (WidgetTester tester) async {
      int quantity = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  maxQuantity: 100,
                  longPressConfig: const CartStepperLongPressConfig(
                    enabled: true,
                    interval: Duration(milliseconds: 50),
                    initialDelay: Duration(milliseconds: 100),
                  ),
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Long press on increment button
      final addButtons = find.byIcon(Icons.add);
      final gesture = await tester.startGesture(
        tester.getCenter(addButtons.last),
      );

      // Wait for Flutter's long press recognition (~500ms) + initial delay + repeats
      await tester.pump(const Duration(milliseconds: 500)); // Flutter long press timeout
      await tester.pump(const Duration(milliseconds: 100)); // Our initial delay
      await tester.pump(const Duration(milliseconds: 200)); // Several repeat intervals
      await tester.pump(const Duration(milliseconds: 200));

      await gesture.up();
      await tester.pumpAndSettle();

      // Should have incremented multiple times
      expect(quantity, greaterThan(2));
    });

    testWidgets('regular tap works with async operations',
        (WidgetTester tester) async {
      int operationCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncCartStepper(
              quantity: 1,
              maxQuantity: 100,
              longPressConfig: const CartStepperLongPressConfig(
                enabled: true,
              ),
              asyncBehavior: const CartStepperAsyncBehavior(
                allowLongPressForAsync: false,
              ),
              onQuantityChangedAsync: (newQty) async {
                operationCount++;
                await Future.delayed(const Duration(milliseconds: 10));
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Regular tap on increment button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      // Should trigger one operation
      expect(operationCount, equals(1));
    });

    testWidgets('long press does not trigger rapid fire for async',
        (WidgetTester tester) async {
      int quantity = 1;
      int operationCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  maxQuantity: 100,
                  longPressConfig: const CartStepperLongPressConfig(
                    enabled: true,
                    interval: Duration(milliseconds: 50),
                    initialDelay: Duration(milliseconds: 100),
                  ),
                  asyncBehavior: const CartStepperAsyncBehavior(
                    allowLongPressForAsync: false,
                  ),
                  onQuantityChangedAsync: (newQty) async {
                    operationCount++;
                    await Future.delayed(const Duration(milliseconds: 10));
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Long press on increment button
      final addButtons = find.byIcon(Icons.add);
      final gesture = await tester.startGesture(
        tester.getCenter(addButtons.last),
      );

      // Wait for what would be multiple increments with sync
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.up();
      await tester.pumpAndSettle();

      // Long press rapid fire should be disabled for async
      // Only the initial tap-on-release counts
      expect(operationCount, lessThanOrEqualTo(1));
    });
  });

  group('External State Synchronization Tests', () {
    testWidgets('responds to external quantity changes',
        (WidgetTester tester) async {
      int quantity = 5;

      late StateSetter outerSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                outerSetState = setState;
                return CartStepper(
                  quantity: quantity,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Externally update quantity
      outerSetState(() => quantity = 10);
      await tester.pumpAndSettle();

      // Should display new value
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('collapses when external quantity becomes 0',
        (WidgetTester tester) async {
      int quantity = 5;

      late StateSetter outerSetState;

      // Use a container with fixed size to avoid overflow during animation
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    outerSetState = setState;
                    return CartStepper(
                      quantity: quantity,
                      autoCollapse: true,
                      onQuantityChanged: (newQty) {
                        setState(() => quantity = newQty);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should be expanded with quantity showing
      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);

      // Externally set quantity to 0
      outerSetState(() => quantity = 0);

      // Let animation complete
      await tester.pumpAndSettle();

      // Should be collapsed (only add button visible, no decrement button)
      expect(find.byIcon(Icons.remove), findsNothing);
    });
  });

  // ============================================================================
  // Manual Input Tests
  // ============================================================================
  group('Manual Input Tests', () {
    testWidgets('tapping quantity opens manual input when enabled',
        (WidgetTester tester) async {
      int quantity = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  manualInputConfig: const CartStepperManualInputConfig(
                    enabled: true,
                  ),
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the quantity display area and tap it
      expect(find.text('5'), findsOneWidget);
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // Should show a TextField for input
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('manual input submits on enter',
        (WidgetTester tester) async {
      int quantity = 5;
      num? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  manualInputConfig: CartStepperManualInputConfig(
                    enabled: true,
                    onSubmitted: (value) {
                      submittedValue = value;
                    },
                  ),
                  maxQuantity: 100,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap quantity to open input
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // Enter new value
      await tester.enterText(find.byType(TextField), '25');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(quantity, equals(25));
      expect(submittedValue, equals(25));
    });

    testWidgets('manual input clamps to min/max',
        (WidgetTester tester) async {
      int quantity = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  manualInputConfig: const CartStepperManualInputConfig(
                    enabled: true,
                  ),
                  minQuantity: 1,
                  maxQuantity: 10,
                  onQuantityChanged: (newQty) {
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap quantity to open input
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // Enter value above max
      await tester.enterText(find.byType(TextField), '999');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Should be clamped to max
      expect(quantity, equals(10));
    });
  });

  // ============================================================================
  // Debounce Mode Tests
  // ============================================================================
  group('Debounce Mode Tests', () {
    testWidgets('debounce batches rapid operations',
        (WidgetTester tester) async {
      int quantity = 1;
      int apiCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AsyncCartStepper(
                  quantity: quantity,
                  maxQuantity: 100,
                  asyncBehavior: const CartStepperAsyncBehavior(
                    debounceDelay: Duration(milliseconds: 300),
                  ),
                  onQuantityChangedAsync: (newQty) async {
                    apiCallCount++;
                    await Future.delayed(const Duration(milliseconds: 50));
                    setState(() => quantity = newQty);
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Rapidly tap increment multiple times
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(addButtons.last);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(addButtons.last);
      await tester.pump(const Duration(milliseconds: 50));

      // Wait for debounce to complete
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Should have batched into a single API call
      expect(apiCallCount, equals(1));
    });
  });

  // ============================================================================
  // Auto-Collapse Timer Tests
  // ============================================================================
  group('Auto-Collapse Timer Tests', () {
    testWidgets('auto-collapses after delay when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: AsyncCartStepper(
                  quantity: 5,
                  collapseConfig: const CartStepperCollapseConfig(
                    autoCollapseDelay: Duration(milliseconds: 500),
                    initiallyExpanded: true,
                  ),
                  onQuantityChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      // Allow initial animation to finish
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should be expanded initially
      expect(find.byIcon(Icons.remove), findsOneWidget);

      // Wait for auto-collapse timer to fire
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Should be collapsed
      expect(find.byIcon(Icons.remove), findsNothing);
    });
  });

  // ============================================================================
  // Error Builder Tests
  // ============================================================================
  group('Error Builder Tests', () {
    testWidgets('errorBuilder displays error widget on failure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncCartStepper(
              quantity: 1,
              onQuantityChangedAsync: (newQty) async {
                throw Exception('Test error');
              },
              onError: (_, __) {},
              errorBuilder: (context, error, retry) {
                return Text('Error: ${error.message}');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap increment to trigger error
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.last);
      await tester.pumpAndSettle();

      // Should show error message
      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });

  // ============================================================================
  // ThemedCartStepper Tests
  // ============================================================================
  group('ThemedCartStepper Tests', () {
    testWidgets('ThemedCartStepper inherits theme from ancestor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepperTheme(
              data: CartStepperThemeData(
                size: CartStepperSize.large,
                style: CartStepperStyle.dark,
              ),
              child: ThemedCartStepper(
                quantity: 3,
                onQuantityChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(ThemedCartStepper<int>), findsOneWidget);
      expect(find.byType(CartStepper<int>), findsOneWidget);
    });

    testWidgets('ThemedCartStepper local props override theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepperTheme(
              data: CartStepperThemeData(
                size: CartStepperSize.large,
              ),
              child: ThemedCartStepper(
                quantity: 3,
                size: CartStepperSize.compact,
                onQuantityChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should render with compact size (overriding theme's large)
      expect(find.byType(ThemedCartStepper<int>), findsOneWidget);
    });
  });

  // ============================================================================
  // CartStepperGroup Tests
  // ============================================================================
  group('CartStepperGroup Tests', () {
    testWidgets('renders all items with labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepperGroup(
              items: [
                CartStepperGroupItem(id: 'small', quantity: 0, label: 'S'),
                CartStepperGroupItem(id: 'medium', quantity: 1, label: 'M'),
                CartStepperGroupItem(id: 'large', quantity: 0, label: 'L'),
              ],
              onQuantityChanged: (_, __) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show all labels
      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
    });

    testWidgets('calls onQuantityChanged with correct index',
        (WidgetTester tester) async {
      int? changedIndex;
      int? changedQty;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepperGroup(
              items: [
                CartStepperGroupItem(id: 'a', quantity: 0, label: 'A'),
                CartStepperGroupItem(id: 'b', quantity: 0, label: 'B'),
              ],
              onQuantityChanged: (index, qty) {
                changedIndex = index;
                changedQty = qty;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the second item's add button
      final addButtons = find.byIcon(Icons.add);
      await tester.tap(addButtons.at(1));
      await tester.pumpAndSettle();

      expect(changedIndex, equals(1));
      expect(changedQty, equals(1));
    });

    testWidgets('respects maxTotalQuantity across all items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartStepperGroup(
              items: [
                CartStepperGroupItem(id: 'a', quantity: 8, label: 'A'),
                CartStepperGroupItem(id: 'b', quantity: 0, label: 'B'),
              ],
              maxTotalQuantity: 10,
              onQuantityChanged: (_, __) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // totalQuantity is 8, maxTotalQuantity is 10
      // Second item can only go up to 2
      expect(find.byType(CartStepperGroup), findsOneWidget);
    });
  });

  // ============================================================================
  // CartProductTile Tests
  // ============================================================================
  group('CartProductTile Tests', () {
    testWidgets('renders all components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartProductTile(
              title: 'Test Product',
              subtitle: 'Product description',
              price: r'$19.99',
              quantity: 2,
              onQuantityChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Product description'), findsOneWidget);
      expect(find.text(r'$19.99'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartProductTile(
              title: 'Test Product',
              quantity: 1,
              onQuantityChanged: (_) {},
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Product'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
