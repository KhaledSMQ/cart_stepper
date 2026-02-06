import 'package:advance_cart_stepper/advance_cart_stepper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CartStepperExampleApp());
}

class CartStepperExampleApp extends StatelessWidget {
  const CartStepperExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Stepper Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD84315)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD84315),
          brightness: Brightness.dark,
        ),
      ),
      home: const CartStepperDemo(),
    );
  }
}

class CartStepperDemo extends StatefulWidget {
  const CartStepperDemo({super.key});

  @override
  State<CartStepperDemo> createState() => _CartStepperDemoState();
}

class _CartStepperDemoState extends State<CartStepperDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Stepper Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Basics'),
            Tab(text: 'Styles'),
            Tab(text: 'Async'),
            Tab(text: 'Advanced'),
            Tab(text: 'Components'),
            Tab(text: 'Real World'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _BasicsTab(),
          _StylesTab(),
          _AsyncTab(),
          _AdvancedTab(),
          _ComponentsTab(),
          _RealWorldTab(),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 1: BASICS
// =============================================================================
class _BasicsTab extends StatefulWidget {
  const _BasicsTab();

  @override
  State<_BasicsTab> createState() => _BasicsTabState();
}

class _BasicsTabState extends State<_BasicsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Basic quantities
  int _basicQuantity = 0;
  int _compactQuantity = 0;
  int _normalQuantity = 2;
  int _largeQuantity = 1;

  // Add to cart button styles
  int _circleIconQty = 0;
  int _addButtonQty = 0;
  int _addToCartQty = 0;
  int _iconOnlyQty = 0;
  int _customButtonQty = 0;
  int _collapsedBuilderQty = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Size Variants',
          'Different sizes for various use cases',
          [
            _buildRow(
              'Compact (32px)',
              CartStepper(
                quantity: _compactQuantity,
                size: CartStepperSize.compact,
                onQuantityChanged: (qty) =>
                    setState(() => _compactQuantity = qty),
                onRemove: () => setState(() => _compactQuantity = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Normal (40px) - Default',
              CartStepper(
                quantity: _normalQuantity,
                size: CartStepperSize.normal,
                onQuantityChanged: (qty) =>
                    setState(() => _normalQuantity = qty),
                onRemove: () => setState(() => _normalQuantity = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Large (48px)',
              CartStepper(
                quantity: _largeQuantity,
                size: CartStepperSize.large,
                onQuantityChanged: (qty) =>
                    setState(() => _largeQuantity = qty),
                onRemove: () => setState(() => _largeQuantity = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Add to Cart Button Styles',
          'Choose between circle icon or button styles',
          [
            _buildRow(
              'Circle Icon (default)',
              CartStepper(
                quantity: _circleIconQty,
                addToCartConfig: AddToCartButtonConfig.circleIcon,
                onQuantityChanged: (qty) =>
                    setState(() => _circleIconQty = qty),
                onRemove: () => setState(() => _circleIconQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              '"Add" Button',
              CartStepper(
                quantity: _addButtonQty,
                addToCartConfig: AddToCartButtonConfig.addButton,
                onQuantityChanged: (qty) => setState(() => _addButtonQty = qty),
                onRemove: () => setState(() => _addButtonQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              '"Add to Cart" Button',
              CartStepper(
                quantity: _addToCartQty,
                addToCartConfig: AddToCartButtonConfig.addToCartButton,
                onQuantityChanged: (qty) => setState(() => _addToCartQty = qty),
                onRemove: () => setState(() => _addToCartQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Icon Only Button',
              CartStepper(
                quantity: _iconOnlyQty,
                addToCartConfig: AddToCartButtonConfig.iconOnlyButton,
                onQuantityChanged: (qty) => setState(() => _iconOnlyQty = qty),
                onRemove: () => setState(() => _iconOnlyQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Custom Button',
              CartStepper(
                quantity: _customButtonQty,
                addToCartConfig: const AddToCartButtonConfig(
                  style: AddToCartButtonStyle.button,
                  buttonText: 'Buy Now',
                  icon: Icons.shopping_bag,
                  iconLeading: false,
                  buttonWidth: 110,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                style: const CartStepperStyle(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  borderColor: Color(0xFF2E7D32),
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _customButtonQty = qty),
                onRemove: () => setState(() => _customButtonQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Collapsed Builder',
              AsyncCartStepper(
                quantity: _collapsedBuilderQty,
                collapseConfig: CartStepperCollapseConfig(
                  collapsedWidth: 100,
                  collapsedHeight: 36,
                  collapsedBuilder: (context, qty, isLoading, onTap) {
                    return GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFD84315)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    qty > 0 ? 'Add ($qty)' : 'Add',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _collapsedBuilderQty = qty),
                onRemove: () => setState(() => _collapsedBuilderQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fully custom widget via collapsedBuilder',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Basic Functionality',
          'Core features: add, increment, decrement, delete',
          [
            _buildRow(
              'Start from 0',
              CartStepper(
                quantity: _basicQuantity,
                onQuantityChanged: (qty) =>
                    setState(() => _basicQuantity = qty),
                onRemove: () => setState(() => _basicQuantity = 0),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap + to add, use -/+ to adjust, trash to remove',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

// =============================================================================
// TAB 2: STYLES
// =============================================================================
class _StylesTab extends StatefulWidget {
  const _StylesTab();

  @override
  State<_StylesTab> createState() => _StylesTabState();
}

class _StylesTabState extends State<_StylesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _orangeQty = 2;
  int _darkQty = 3;
  int _lightQty = 1;
  int _blueQty = 2;
  int _greenQty = 1;
  int _tealQty = 2;
  int _indigoQty = 3;
  int _animFastQty = 1;
  int _animSmoothQty = 2;
  int _animCustomQty = 1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Pre-built Themes',
          'Ready-to-use style variants',
          [
            _buildRow(
              'Orange (Default)',
              CartStepper(
                quantity: _orangeQty,
                style: CartStepperStyle.defaultOrange,
                onQuantityChanged: (qty) => setState(() => _orangeQty = qty),
                onRemove: () => setState(() => _orangeQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Dark',
              CartStepper(
                quantity: _darkQty,
                style: CartStepperStyle.dark,
                onQuantityChanged: (qty) => setState(() => _darkQty = qty),
                onRemove: () => setState(() => _darkQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Light',
              CartStepper(
                quantity: _lightQty,
                style: CartStepperStyle.light,
                onQuantityChanged: (qty) => setState(() => _lightQty = qty),
                onRemove: () => setState(() => _lightQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Custom Styles',
          'Create your own brand colors',
          [
            _buildRow(
              'Blue with elevation',
              CartStepper(
                quantity: _blueQty,
                style: const CartStepperStyle(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  borderColor: Color(0xFF1976D2),
                  elevation: 4.0,
                  iconScale: 1.1,
                ),
                onQuantityChanged: (qty) => setState(() => _blueQty = qty),
                onRemove: () => setState(() => _blueQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Green bold font',
              CartStepper(
                quantity: _greenQty,
                style: const CartStepperStyle(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  borderColor: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w800,
                ),
                onQuantityChanged: (qty) => setState(() => _greenQty = qty),
                onRemove: () => setState(() => _greenQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Rounded square',
              CartStepper(
                quantity: _tealQty,
                style: CartStepperStyle(
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  borderColor: Colors.teal,
                ),
                onQuantityChanged: (qty) => setState(() => _tealQty = qty),
                onRemove: () => setState(() => _tealQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Custom font style',
              CartStepper(
                quantity: _indigoQty,
                style: const CartStepperStyle(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  borderColor: Colors.indigo,
                  textStyle: TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                onQuantityChanged: (qty) => setState(() => _indigoQty = qty),
                onRemove: () => setState(() => _indigoQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Animation Presets',
          'Different animation speeds and curves',
          [
            _buildRow(
              'Fast (150ms)',
              CartStepper(
                quantity: _animFastQty,
                animation: CartStepperAnimation.fast,
                onQuantityChanged: (qty) => setState(() => _animFastQty = qty),
                onRemove: () => setState(() => _animFastQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Smooth (bounce)',
              CartStepper(
                quantity: _animSmoothQty,
                animation: CartStepperAnimation.smooth,
                onQuantityChanged: (qty) =>
                    setState(() => _animSmoothQty = qty),
                onRemove: () => setState(() => _animSmoothQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Custom (elastic)',
              CartStepper(
                quantity: _animCustomQty,
                animation: const CartStepperAnimation(
                  expandDuration: Duration(milliseconds: 500),
                  expandCurve: Curves.elasticOut,
                  enableHaptics: true,
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _animCustomQty = qty),
                onRemove: () => setState(() => _animCustomQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

// =============================================================================
// TAB 3: ASYNC
// =============================================================================
class _AsyncTab extends StatefulWidget {
  const _AsyncTab();

  @override
  State<_AsyncTab> createState() => _AsyncTabState();
}

class _AsyncTabState extends State<_AsyncTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _asyncDefaultQty = 0;
  int _asyncFadingQty = 2;
  int _builtInCircularQty = 1;
  int _builtInLinearQty = 2;
  int _optimisticQty = 3;

  // Debounce mode
  int _debounceQty = 2;
  bool _debounceLoading = false;

  // Error handling
  int _errorQty = 2;
  String? _lastError;
  int _errorBuilderQty = 2;

  // Loading types showcase
  final Map<CartStepperLoadingType, int> _loadingTypeQty = {
    for (var type in CartStepperLoadingType.values) type: 1,
  };

  Future<void> _simulateApiCall({int delayMs = 800}) async {
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Async Loading',
          'Shows loading spinner during API calls',
          [
            _buildRow(
              'ThreeBounce (default)',
              AsyncCartStepper(
                quantity: _asyncDefaultQty,
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall();
                  setState(() => _asyncDefaultQty = qty);
                },
                onRemoveAsync: () async {
                  await _simulateApiCall();
                  setState(() => _asyncDefaultQty = 0);
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'FadingCircle (slow)',
              AsyncCartStepper(
                quantity: _asyncFadingQty,
                loadingConfig: const CartStepperLoadingConfig(
                  type: CartStepperLoadingType.fadingCircle,
                  minimumDuration: Duration(milliseconds: 500),
                ),
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall(delayMs: 1200);
                  setState(() => _asyncFadingQty = qty);
                },
                onRemoveAsync: () async {
                  await _simulateApiCall(delayMs: 1200);
                  setState(() => _asyncFadingQty = 0);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Built-in Loading (No SpinKit)',
          "Use Flutter's native indicators",
          [
            _buildRow(
              'CircularProgressIndicator',
              AsyncCartStepper(
                quantity: _builtInCircularQty,
                loadingConfig: CartStepperLoadingConfig.builtIn,
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall();
                  setState(() => _builtInCircularQty = qty);
                },
                onRemoveAsync: () async {
                  await _simulateApiCall();
                  setState(() => _builtInCircularQty = 0);
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'LinearProgressIndicator',
              AsyncCartStepper(
                quantity: _builtInLinearQty,
                loadingConfig: const CartStepperLoadingConfig(
                  type: CartStepperLoadingType.linear,
                  sizeMultiplier: 1.2,
                ),
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall();
                  setState(() => _builtInLinearQty = qty);
                },
                onRemoveAsync: () async {
                  await _simulateApiCall();
                  setState(() => _builtInLinearQty = 0);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Optimistic Updates',
          'Update UI immediately, revert on error',
          [
            _buildRow(
              'Optimistic (instant UI)',
              AsyncCartStepper(
                quantity: _optimisticQty,
                asyncBehavior: const CartStepperAsyncBehavior(
                  optimisticUpdate: true,
                  revertOnError: true,
                ),
                loadingConfig: const CartStepperLoadingConfig(
                  type: CartStepperLoadingType.pulse,
                  sizeMultiplier: 0.6,
                ),
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall(delayMs: 600);
                  setState(() => _optimisticQty = qty);
                },
                onRemoveAsync: () async {
                  await _simulateApiCall(delayMs: 600);
                  setState(() => _optimisticQty = 0);
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notice: quantity updates instantly while loading',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Debounce Mode (Best UX)',
          'Batch rapid changes into one API call',
          [
            _buildRow(
              'Debounce (500ms)',
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AsyncCartStepper(
                    quantity: _debounceQty,
                    asyncBehavior: const CartStepperAsyncBehavior(
                      debounceDelay: Duration(milliseconds: 500),
                    ),
                    maxQuantity: 99,
                    loadingConfig: const CartStepperLoadingConfig(
                      type: CartStepperLoadingType.threeBounce,
                    ),
                    onQuantityChangedAsync: (qty) async {
                      setState(() => _debounceLoading = true);
                      await _simulateApiCall(delayMs: 800);
                      setState(() {
                        _debounceQty = qty;
                        _debounceLoading = false;
                      });
                    },
                    onRemoveAsync: () async {
                      setState(() => _debounceLoading = true);
                      await _simulateApiCall(delayMs: 800);
                      setState(() {
                        _debounceQty = 0;
                        _debounceLoading = false;
                      });
                    },
                  ),
                  if (_debounceLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Syncing...',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: Colors.green.shade700, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Try this:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Tap +/- rapidly multiple times\n'
                    '• Long-press and hold to increment fast\n'
                    '• Notice: UI updates instantly, but only ONE API call is made after you stop!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Error Handling',
          'Handle async operation errors',
          [
            if (_lastError != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _lastError!,
                        style:
                            TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => _lastError = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            _buildRow(
              'With onError callback',
              AsyncCartStepper(
                quantity: _errorQty,
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall(delayMs: 500);
                  if (qty > 5) {
                    throw Exception('Max 5 items allowed!');
                  }
                  setState(() => _errorQty = qty);
                },
                onError: (error, _) {
                  setState(() => _lastError = error.toString());
                },
                onRemoveAsync: () async {
                  await _simulateApiCall(delayMs: 300);
                  setState(() => _errorQty = 0);
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try incrementing past 5 to trigger an error',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            _buildRow(
              'With errorBuilder (inline)',
              AsyncCartStepper(
                quantity: _errorBuilderQty,
                onQuantityChangedAsync: (qty) async {
                  await _simulateApiCall(delayMs: 500);
                  if (qty > 4) {
                    throw Exception('Stock limit reached');
                  }
                  setState(() => _errorBuilderQty = qty);
                },
                errorBuilder: (context, error, retry) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error.message,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: retry,
                        child: const Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onRemoveAsync: () async {
                  await _simulateApiCall(delayMs: 300);
                  setState(() => _errorBuilderQty = 0);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'All Loading Types',
          'Tap to see each SpinKit animation',
          [
            Wrap(
              spacing: 8,
              runSpacing: 16,
              children: CartStepperLoadingType.values.map((type) {
                final name = type.name;
                return SizedBox(
                  width: 130,
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AsyncCartStepper(
                        quantity: _loadingTypeQty[type]!,
                        size: CartStepperSize.compact,
                        loadingConfig: CartStepperLoadingConfig(
                          type: type,
                          sizeMultiplier: 0.7,
                        ),
                        onQuantityChangedAsync: (qty) async {
                          await _simulateApiCall(delayMs: 1500);
                          setState(() => _loadingTypeQty[type] = qty);
                        },
                        onRemoveAsync: () async {
                          await _simulateApiCall(delayMs: 1500);
                          setState(() => _loadingTypeQty[type] = 0);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

// =============================================================================
// TAB 4: ADVANCED
// =============================================================================
class _AdvancedTab extends StatefulWidget {
  const _AdvancedTab();

  @override
  State<_AdvancedTab> createState() => _AdvancedTabState();
}

class _AdvancedTabState extends State<_AdvancedTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Min/Max
  int _minMaxQty = 5;
  int _stepQty = 10;
  final int _disabledQty = 3;
  int _noDeleteQty = 1;
  int _deleteViaChangeQty = 1;

  // Long press
  int _fastLongPressQty = 50;
  int _slowLongPressQty = 50;

  // Quantity formatters
  int _abbrev1Qty = 1500;
  int _abbrev2Qty = 12500;
  int _abbrev3Qty = 1000000;
  int _maxIndicatorQty = 99;

  // Callbacks
  int _callbacksQty = 5;
  String? _callbackMessage;

  // Auto-collapse
  int _autoCollapseQty = 2;

  // Initially expanded
  int _expandedTrueQty = 3;
  int _expandedFalseQty = 5;

  // Custom icons
  int _customIconsQty = 2;

  // Validation
  int _validationQty = 2;

  // Manual Input
  int _manualInputQty = 5;
  int _manualInputLargeQty = 25;
  int _customInputBuilderQty = 10;

  // v2.0 new features
  double _decimalQty = 1.5;
  int _verticalQty = 3;
  int _rtlQty = 2;
  int _undoQty = 3;
  int _detailedQty = 2;
  String? _detailedMessage;
  int _expandedBuilderQty = 3;
  int _transitionQty = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'Min/Max & Step',
          'Control quantity limits and step values',
          [
            _buildRow(
              'Min: 5, Max: 15',
              CartStepper(
                quantity: _minMaxQty,
                minQuantity: 5,
                maxQuantity: 15,
                onQuantityChanged: (qty) => setState(() => _minMaxQty = qty),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Step: 5',
              AsyncCartStepper(
                quantity: _stepQty,
                minQuantity: 5,
                maxQuantity: 100,
                step: 5,
                quantityFormatter: (q) => '$q items',
                onQuantityChanged: (qty) => setState(() => _stepQty = qty),
                onRemove: () => setState(() => _stepQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Disabled',
              CartStepper(
                quantity: _disabledQty,
                enabled: false,
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'No delete icon',
              CartStepper(
                quantity: _noDeleteQty,
                showDeleteAtMin: false,
                onQuantityChanged: (qty) => setState(() => _noDeleteQty = qty),
                onRemove: () => setState(() => _noDeleteQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Delete via onQuantityChanged',
              AsyncCartStepper(
                quantity: _deleteViaChangeQty,
                minQuantity: 1,
                deleteViaQuantityChange: true,
                onQuantityChanged: (qty) {
                  if (qty < 1) {
                    setState(() => _deleteViaChangeQty = 0);
                  } else {
                    setState(() => _deleteViaChangeQty = qty);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Long Press Configuration',
          'Control delay before rapid increment starts',
          [
            _buildRow(
              'Fast (100ms delay)',
              AsyncCartStepper(
                quantity: _fastLongPressQty,
                maxQuantity: 999,
                longPressConfig: const CartStepperLongPressConfig(
                  initialDelay: Duration(milliseconds: 100),
                  interval: Duration(milliseconds: 50),
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _fastLongPressQty = qty),
                onRemove: () => setState(() => _fastLongPressQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Slow (800ms delay)',
              AsyncCartStepper(
                quantity: _slowLongPressQty,
                maxQuantity: 999,
                longPressConfig: const CartStepperLongPressConfig(
                  initialDelay: Duration(milliseconds: 800),
                  interval: Duration(milliseconds: 150),
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _slowLongPressQty = qty),
                onRemove: () => setState(() => _slowLongPressQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Long-press and hold +/- buttons to see the difference',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Quantity Formatters',
          'Built-in abbreviation for large numbers',
          [
            _buildRow(
              '1,500 → "1.5k"',
              AsyncCartStepper(
                quantity: _abbrev1Qty,
                maxQuantity: 9999999,
                step: 100,
                quantityFormatter: QuantityFormatters.abbreviated,
                onQuantityChanged: (qty) => setState(() => _abbrev1Qty = qty),
                onRemove: () => setState(() => _abbrev1Qty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              '12,500 → "12.5k"',
              AsyncCartStepper(
                quantity: _abbrev2Qty,
                maxQuantity: 9999999,
                step: 500,
                quantityFormatter: QuantityFormatters.abbreviated,
                onQuantityChanged: (qty) => setState(() => _abbrev2Qty = qty),
                onRemove: () => setState(() => _abbrev2Qty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              '1,000,000 → "1M"',
              AsyncCartStepper(
                quantity: _abbrev3Qty,
                maxQuantity: 9999999,
                step: 100000,
                quantityFormatter: QuantityFormatters.abbreviated,
                onQuantityChanged: (qty) => setState(() => _abbrev3Qty = qty),
                onRemove: () => setState(() => _abbrev3Qty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Max indicator (99+)',
              AsyncCartStepper(
                quantity: _maxIndicatorQty,
                maxQuantity: 150,
                quantityFormatter: QuantityFormatters.abbreviatedWithMax(99),
                onQuantityChanged: (qty) =>
                    setState(() => _maxIndicatorQty = qty),
                onRemove: () => setState(() => _maxIndicatorQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Event Callbacks',
          'onMaxReached, onMinReached, onValidationRejected',
          [
            if (_callbackMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _callbackMessage!,
                        style: TextStyle(
                            color: Colors.blue.shade700, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => _callbackMessage = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            _buildRow(
              'With callbacks (min:1, max:10)',
              AsyncCartStepper(
                quantity: _callbacksQty,
                minQuantity: 1,
                maxQuantity: 10,
                onQuantityChanged: (qty) => setState(() => _callbacksQty = qty),
                onMaxReached: () {
                  setState(() => _callbackMessage = 'Max quantity reached!');
                },
                onMinReached: () {
                  setState(() => _callbackMessage = 'Min quantity reached!');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Custom Validator',
          'Prevent changes that fail validation',
          [
            _buildRow(
              'Only even numbers',
              AsyncCartStepper(
                quantity: _validationQty,
                step: 1,
                maxQuantity: 20,
                validator: (current, next) => next % 2 == 0,
                onQuantityChanged: (qty) =>
                    setState(() => _validationQty = qty),
                onValidationRejected: (current, attempted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$attempted is not an even number!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onRemove: () => setState(() => _validationQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Auto-Collapse',
          'Collapses to a badge after inactivity',
          [
            _buildRow(
              'Auto-Collapse (3s)',
              AsyncCartStepper(
                quantity: _autoCollapseQty,
                collapseConfig: const CartStepperCollapseConfig(
                  autoCollapseDelay: Duration(seconds: 3),
                ),
                iconConfig: const CartStepperIconConfig(
                  collapsedBadgeIcon: Icons.shopping_cart,
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _autoCollapseQty = qty),
                onRemove: () => setState(() => _autoCollapseQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wait 3 seconds to see it collapse to badge view',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Initially Expanded',
          'Control initial state explicitly',
          [
            _buildRow(
              'initiallyExpanded: true',
              AsyncCartStepper(
                quantity: _expandedTrueQty,
                collapseConfig: const CartStepperCollapseConfig(
                  initiallyExpanded: true,
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _expandedTrueQty = qty),
                onRemove: () => setState(() => _expandedTrueQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'initiallyExpanded: false',
              AsyncCartStepper(
                quantity: _expandedFalseQty,
                collapseConfig: const CartStepperCollapseConfig(
                  initiallyExpanded: false,
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _expandedFalseQty = qty),
                onRemove: () => setState(() => _expandedFalseQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Custom Icons',
          'Replace default icons',
          [
            _buildRow(
              'Custom increment/decrement',
              AsyncCartStepper(
                quantity: _customIconsQty,
                iconConfig: const CartStepperIconConfig(
                  addIcon: Icons.add_circle,
                  incrementIcon: Icons.arrow_upward,
                  decrementIcon: Icons.arrow_downward,
                  deleteIcon: Icons.cancel,
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _customIconsQty = qty),
                onRemove: () => setState(() => _customIconsQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Decimal / Double Quantities',
          'Generic T extends num support for non-integer quantities',
          [
            _buildRow(
              'Step: 0.5 (double)',
              AsyncCartStepper<double>(
                quantity: _decimalQty,
                minQuantity: 0.5,
                maxQuantity: 10.0,
                step: 0.5,
                quantityFormatter: (q) => q.toStringAsFixed(1),
                onQuantityChanged: (qty) => setState(() => _decimalQty = qty),
                onRemove: () => setState(() => _decimalQty = 0.0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'CartStepper<double> with step: 0.5',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Vertical Layout',
          'CartStepperDirection.vertical for vertical stepper controls',
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Vertical', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 8),
                    AsyncCartStepper(
                      quantity: _verticalQty,
                      direction: CartStepperDirection.vertical,
                      maxQuantity: 20,
                      onQuantityChanged: (qty) =>
                          setState(() => _verticalQty = qty),
                      onRemove: () => setState(() => _verticalQty = 0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Manual Input',
          'Tap on the quantity to type a value directly',
          [
            _buildRow(
              'Tap to edit (max: 99)',
              AsyncCartStepper(
                quantity: _manualInputQty,
                manualInputConfig: CartStepperManualInputConfig(
                  enabled: true,
                  onSubmitted: (qty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Manually set to $qty'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _manualInputQty = qty),
                onRemove: () => setState(() => _manualInputQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the number in the stepper to open keyboard input',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Large size with manual input',
              AsyncCartStepper(
                quantity: _manualInputLargeQty,
                size: CartStepperSize.large,
                maxQuantity: 999,
                manualInputConfig: const CartStepperManualInputConfig(
                  enabled: true,
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _manualInputLargeQty = qty),
                onRemove: () => setState(() => _manualInputLargeQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'Custom input builder',
              AsyncCartStepper(
                quantity: _customInputBuilderQty,
                maxQuantity: 50,
                manualInputConfig: CartStepperManualInputConfig(
                  enabled: true,
                  builder: (context, currentValue, onSubmit, onCancel) {
                    final controller =
                        TextEditingController(text: currentValue.toString());
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 40,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              autofocus: true,
                              onSubmitted: onSubmit,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => onSubmit(controller.text),
                            child: const Icon(Icons.check,
                                color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _customInputBuilderQty = qty),
                onRemove: () => setState(() => _customInputBuilderQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Custom builder with a confirm button',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'RTL / Directionality',
          'Right-to-left layout support',
          [
            _buildRow(
              'LTR (default)',
              CartStepper(
                quantity: _rtlQty,
                textDirection: TextDirection.ltr,
                onQuantityChanged: (qty) => setState(() => _rtlQty = qty),
                onRemove: () => setState(() => _rtlQty = 0),
              ),
            ),
            const SizedBox(height: 16),
            _buildRow(
              'RTL (mirrored)',
              CartStepper(
                quantity: _rtlQty,
                textDirection: TextDirection.rtl,
                onQuantityChanged: (qty) => setState(() => _rtlQty = qty),
                onRemove: () => setState(() => _rtlQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Notice the increment/decrement buttons are swapped in RTL',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Undo After Delete',
          'Shows an undo prompt before finalizing removal',
          [
            _buildRow(
              'Undo (3 seconds)',
              AsyncCartStepper(
                quantity: _undoQty,
                undoConfig: const CartStepperUndoConfig(
                  enabled: true,
                  duration: Duration(seconds: 3),
                ),
                onQuantityChanged: (qty) => setState(() => _undoQty = qty),
                onRemove: () => setState(() => _undoQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Delete an item and watch the undo indicator appear',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Detailed Quantity Changed',
          'Track how the quantity was changed',
          [
            if (_detailedMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined,
                        color: Colors.purple.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _detailedMessage!,
                        style: TextStyle(
                            color: Colors.purple.shade700, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => _detailedMessage = null),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            _buildRow(
              'With onDetailedQuantityChanged',
              CartStepper(
                quantity: _detailedQty,
                onQuantityChanged: (qty) => setState(() => _detailedQty = qty),
                onDetailedQuantityChanged: (newQty, oldQty, changeType) {
                  setState(() {
                    _detailedMessage =
                        '$oldQty → $newQty via ${changeType.name}';
                  });
                },
                onRemove: () => setState(() => _detailedQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap +/- to see the change type reported above',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Custom Expanded Builder',
          'Replace the default stepper controls entirely',
          [
            _buildRow(
              'Custom layout',
              AsyncCartStepper(
                quantity: _expandedBuilderQty,
                maxQuantity: 20,
                expandedBuilder:
                    (context, qty, increment, decrement, isLoading) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD84315),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: decrement,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.remove_circle_outline,
                                color: Colors.white, size: 22),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '$qty',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: increment,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.add_circle_outline,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onQuantityChanged: (qty) =>
                    setState(() => _expandedBuilderQty = qty),
                onRemove: () => setState(() => _expandedBuilderQty = 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Custom Transition Builder',
          'Change the expand/collapse animation',
          [
            _buildRow(
              'Scale transition',
              CartStepper(
                quantity: _transitionQty,
                animation: CartStepperAnimation(
                  transitionBuilder: (context, animation, child) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                ),
                onQuantityChanged: (qty) =>
                    setState(() => _transitionQty = qty),
                onRemove: () => setState(() => _transitionQty = 0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to see scale transition instead of width animation',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

// =============================================================================
// TAB 5: COMPONENTS
// =============================================================================
class _ComponentsTab extends StatefulWidget {
  const _ComponentsTab();

  @override
  State<_ComponentsTab> createState() => _ComponentsTabState();
}

class _ComponentsTabState extends State<_ComponentsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Controller
  late final CartStepperController _controller;

  // Product tiles
  int _productTileQty1 = 1;
  int _productTileQty2 = 0;
  int _productTileQty3 = 2;
  int _productTileQty4 = 0;
  double _productTileWeightQty = 1.5;
  int _productTilePizzaQty = 1;

  // Badge
  int _badgeCount = 5;

  // Group
  List<CartStepperGroupItem> _sizeVariants = [
    const CartStepperGroupItem(id: 's', quantity: 0, label: 'S'),
    const CartStepperGroupItem(id: 'm', quantity: 1, label: 'M'),
    const CartStepperGroupItem(id: 'l', quantity: 0, label: 'L'),
    const CartStepperGroupItem(id: 'xl', quantity: 2, label: 'XL'),
  ];

  // Selection mode group
  List<CartStepperGroupItem> _singleSelectVariants = [
    const CartStepperGroupItem(id: 'red', quantity: 0, label: 'Red'),
    const CartStepperGroupItem(id: 'blue', quantity: 1, label: 'Blue'),
    const CartStepperGroupItem(id: 'green', quantity: 0, label: 'Green'),
  ];

  // Themed
  int _themed1Qty = 2;
  int _themed2Qty = 1;

  @override
  void initState() {
    super.initState();
    _controller = CartStepperController(
      initialQuantity: 3,
      maxQuantity: 10,
      onMaxReached: () => _showMessage('Controller: Max reached!'),
      onMinReached: () => _showMessage('Controller: Min reached!'),
    );
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  int get _totalVariants =>
      _sizeVariants.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'CartStepperController',
          'External state management with ChangeNotifier',
          [
            _buildRow(
              'Controlled (qty: ${_controller.quantity})',
              CartStepper(
                quantity: _controller.quantity,
                maxQuantity: _controller.maxQuantity,
                onQuantityChanged: _controller.setQuantity,
                onRemove: _controller.reset,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _controller.reset,
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _controller.canIncrement
                      ? () => _controller.setQuantity(5)
                      : null,
                  child: const Text('Set to 5'),
                ),
                ElevatedButton(
                  onPressed: _controller.canIncrement
                      ? () => _controller.setQuantity(10)
                      : null,
                  child: const Text('Set to Max'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'canIncrement: ${_controller.canIncrement}\n'
                'canDecrement: ${_controller.canDecrement}\n'
                'isAtMin: ${_controller.isAtMin}\n'
                'isAtMax: ${_controller.isAtMax}',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'CartProductTile',
          'Ready-to-use product cards with integrated stepper',
          [
            CartProductTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.headphones,
                    color: Colors.orange.shade700, size: 28),
              ),
              title: 'Wireless Headphones',
              subtitle: 'Noise cancelling, 30h battery',
              price: '\$79.99',
              quantity: _productTileQty1,
              onQuantityChanged: (qty) =>
                  setState(() => _productTileQty1 = qty),
              onRemove: () => setState(() => _productTileQty1 = 0),
            ),
            const SizedBox(height: 12),
            CartProductTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.keyboard, color: Colors.blue.shade700, size: 28),
              ),
              title: 'Mechanical Keyboard',
              subtitle: 'Cherry MX Blue, RGB Backlit',
              price: '\$129.99',
              quantity: _productTileQty2,
              stepperStyle: CartStepperStyle.dark,
              onQuantityChanged: (qty) =>
                  setState(() => _productTileQty2 = qty),
              onRemove: () => setState(() => _productTileQty2 = 0),
            ),
            const SizedBox(height: 12),
            CartProductTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.mouse, color: Colors.green.shade700, size: 28),
              ),
              title: 'Ergonomic Mouse',
              subtitle: '4000 DPI, Wireless',
              price: '\$49.99',
              quantity: _productTileQty3,
              stepperStyle: const CartStepperStyle(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                borderColor: Color(0xFF2E7D32),
              ),
              backgroundColor: Colors.green.shade50,
              borderRadius: 20,
              onQuantityChanged: (qty) =>
                  setState(() => _productTileQty3 = qty),
              onRemove: () => setState(() => _productTileQty3 = 0),
            ),
            const SizedBox(height: 12),
            CartProductTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.monitor,
                    color: Colors.purple.shade700, size: 28),
              ),
              title: 'Ultra-wide Monitor',
              subtitle: '34", 144Hz, HDR',
              price: '\$499.99',
              quantity: _productTileQty4,
              stepperSize: CartStepperSize.normal,
              maxQuantity: 3,
              stepperStyle: const CartStepperStyle(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                borderColor: Colors.deepPurple,
              ),
              onQuantityChanged: (qty) =>
                  setState(() => _productTileQty4 = qty),
              onRemove: () => setState(() => _productTileQty4 = 0),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navigate to product details'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the monitor tile to see onTap callback',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'CartProductTile - Customized',
          'Double quantities, custom padding, and larger stepper',
          [
            CartProductTile<double>(
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(Icons.coffee, color: Colors.brown.shade700, size: 32),
              ),
              title: 'Premium Coffee Beans',
              subtitle: 'Single origin, medium roast',
              price: '\$${(18.50 * _productTileWeightQty).toStringAsFixed(2)}',
              quantity: _productTileWeightQty,
              minQuantity: 0.25,
              maxQuantity: 5.0,
              step: 0.25,
              stepperSize: CartStepperSize.normal,
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              onQuantityChanged: (qty) =>
                  setState(() => _productTileWeightQty = qty),
              onRemove: () => setState(() => _productTileWeightQty = 0.0),
            ),
            const SizedBox(height: 8),
            Text(
              'CartProductTile<double> with step: 0.25 for weight-based pricing',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            CartProductTile(
              leading: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.local_pizza,
                    color: Colors.red.shade700, size: 32),
              ),
              title: 'Margherita Pizza',
              subtitle: 'Fresh mozzarella, basil',
              price: '\$14.99',
              quantity: _productTilePizzaQty,
              maxQuantity: 5,
              stepperSize: CartStepperSize.large,
              stepperStyle: const CartStepperStyle(
                backgroundColor: Color(0xFFE53935),
                foregroundColor: Colors.white,
                borderColor: Color(0xFFE53935),
                elevation: 4.0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              backgroundColor: Colors.red.shade50,
              borderRadius: 24,
              onQuantityChanged: (qty) =>
                  setState(() => _productTilePizzaQty = qty),
              onRemove: () => setState(() => _productTilePizzaQty = 0),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'CartBadge',
          'Display cart count on icons',
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CartBadge(
                  count: _badgeCount,
                  child: const Icon(Icons.shopping_cart, size: 32),
                ),
                CartBadge(
                  count: _badgeCount,
                  badgeColor: Colors.blue,
                  alignment: Alignment.topLeft,
                  child: const Icon(Icons.shopping_bag, size: 32),
                ),
                CartBadge(
                  count: 150,
                  maxCount: 99,
                  child: const Icon(Icons.favorite, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: _badgeCount.toDouble(),
              min: 0,
              max: 150,
              divisions: 150,
              label: '$_badgeCount',
              onChanged: (v) => setState(() => _badgeCount = v.toInt()),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'CartStepperGroup',
          'Horizontal row for variant selection',
          [
            CartStepperGroup(
              items: _sizeVariants,
              size: CartStepperSize.compact,
              maxTotalQuantity: 10,
              onQuantityChanged: (index, qty) {
                setState(() {
                  _sizeVariants = List.from(_sizeVariants);
                  _sizeVariants[index] =
                      _sizeVariants[index].copyWith(quantity: qty);
                });
              },
              onRemove: (index) {
                setState(() {
                  _sizeVariants = List.from(_sizeVariants);
                  _sizeVariants[index] =
                      _sizeVariants[index].copyWith(quantity: 0);
                });
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Total: $_totalVariants / 10',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'CartStepperGroup - Single Selection',
          'Radio-style: only one item can have quantity > 0',
          [
            CartStepperGroup(
              items: _singleSelectVariants,
              size: CartStepperSize.compact,
              selectionMode: CartStepperSelectionMode.single,
              onQuantityChanged: (index, qty) {
                setState(() {
                  _singleSelectVariants = List.from(_singleSelectVariants);
                  // In single selection mode, reset all others
                  for (var i = 0; i < _singleSelectVariants.length; i++) {
                    if (i == index) {
                      _singleSelectVariants[i] =
                          _singleSelectVariants[i].copyWith(quantity: qty);
                    } else {
                      _singleSelectVariants[i] =
                          _singleSelectVariants[i].copyWith(quantity: 0);
                    }
                  }
                });
              },
              onRemove: (index) {
                setState(() {
                  _singleSelectVariants = List.from(_singleSelectVariants);
                  _singleSelectVariants[index] =
                      _singleSelectVariants[index].copyWith(quantity: 0);
                });
              },
              onTotalChanged: (total) {
                // Total quantity callback
              },
            ),
            const SizedBox(height: 8),
            Text(
              'CartStepperSelectionMode.single',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'CartStepperTheme',
          'Theme multiple steppers consistently',
          [
            CartStepperTheme(
              data: const CartStepperThemeData(
                style: CartStepperStyle(
                  backgroundColor: Color(0xFF6B4EE6),
                  foregroundColor: Colors.white,
                  borderColor: Color(0xFF6B4EE6),
                ),
                size: CartStepperSize.normal,
              ),
              child: Column(
                children: [
                  _buildRow(
                    'Themed 1',
                    ThemedCartStepper(
                      quantity: _themed1Qty,
                      onQuantityChanged: (qty) =>
                          setState(() => _themed1Qty = qty),
                      onRemove: () => setState(() => _themed1Qty = 0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRow(
                    'Themed 2',
                    ThemedCartStepper(
                      quantity: _themed2Qty,
                      onQuantityChanged: (qty) =>
                          setState(() => _themed2Qty = qty),
                      onRemove: () => setState(() => _themed2Qty = 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          'Standalone Components',
          'Use individual widgets separately',
          [
            const Text(
              'AnimatedCounter:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedCounter(
                  value: _badgeCount,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD84315),
                  ),
                ),
                AnimatedCounter(
                  value: _badgeCount,
                  style: const TextStyle(fontSize: 24),
                  formatter: QuantityFormatters.abbreviated,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'StepperButton:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD84315),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: StepperButton(
                    icon: Icons.remove,
                    iconSize: 24,
                    iconColor: Colors.white,
                    enabled: _badgeCount > 0,
                    onTap: () => setState(
                        () => _badgeCount = (_badgeCount - 1).clamp(0, 150)),
                    onLongPressStart: () {},
                    onLongPressEnd: () {},
                    size: 44,
                    splashColor: Colors.white24,
                    highlightColor: Colors.white12,
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD84315),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      '$_badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD84315),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: StepperButton(
                    icon: Icons.add,
                    iconSize: 24,
                    iconColor: Colors.white,
                    enabled: _badgeCount < 150,
                    onTap: () => setState(
                        () => _badgeCount = (_badgeCount + 1).clamp(0, 150)),
                    onLongPressStart: () {},
                    onLongPressEnd: () {},
                    size: 44,
                    splashColor: Colors.white24,
                    highlightColor: Colors.white12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}

// =============================================================================
// TAB 6: REAL WORLD
// =============================================================================
class _RealWorldTab extends StatefulWidget {
  const _RealWorldTab();

  @override
  State<_RealWorldTab> createState() => _RealWorldTabState();
}

class _RealWorldTabState extends State<_RealWorldTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // View toggle
  bool _showCatalog = false;

  final List<_Product> _products = [
    _Product(
      id: '1',
      name: 'iPhone 15 Pro',
      description: '256GB, Natural Titanium',
      price: 999.00,
      quantity: 1,
      image: Icons.phone_iphone,
    ),
    _Product(
      id: '2',
      name: 'AirPods Pro',
      description: '2nd Generation',
      price: 249.00,
      quantity: 2,
      image: Icons.headphones,
    ),
    _Product(
      id: '3',
      name: 'MacBook Air M3',
      description: '13", 8GB RAM, 256GB SSD',
      price: 1299.00,
      quantity: 0,
      image: Icons.laptop_mac,
    ),
    _Product(
      id: '4',
      name: 'Apple Watch Ultra 2',
      description: '49mm, Titanium Case',
      price: 799.00,
      quantity: 0,
      image: Icons.watch,
    ),
    _Product(
      id: '5',
      name: 'iPad Pro 12.9"',
      description: 'M4 chip, 256GB, Wi-Fi',
      price: 1099.00,
      quantity: 1,
      image: Icons.tablet_mac,
    ),
  ];

  // Grocery catalog products
  final List<_Product> _groceries = [
    _Product(
      id: 'g1',
      name: 'Organic Bananas',
      description: 'Bunch of 6',
      price: 2.49,
      quantity: 0,
      image: Icons.breakfast_dining,
    ),
    _Product(
      id: 'g2',
      name: 'Whole Milk',
      description: '1 Gallon',
      price: 4.99,
      quantity: 0,
      image: Icons.water_drop,
    ),
    _Product(
      id: 'g3',
      name: 'Sourdough Bread',
      description: 'Artisan baked, sliced',
      price: 5.99,
      quantity: 0,
      image: Icons.bakery_dining,
    ),
    _Product(
      id: 'g4',
      name: 'Free Range Eggs',
      description: 'Dozen, large',
      price: 6.49,
      quantity: 0,
      image: Icons.egg,
    ),
    _Product(
      id: 'g5',
      name: 'Greek Yogurt',
      description: 'Plain, 32oz',
      price: 5.49,
      quantity: 0,
      image: Icons.icecream,
    ),
    _Product(
      id: 'g6',
      name: 'Avocados',
      description: 'Hass, pack of 4',
      price: 4.99,
      quantity: 0,
      image: Icons.eco,
    ),
  ];

  int get _totalItems =>
      _products.fold(0, (sum, product) => sum + product.quantity);

  double get _totalPrice => _products.fold(
      0.0, (sum, product) => sum + (product.price * product.quantity));

  int get _groceryTotalItems =>
      _groceries.fold(0, (sum, product) => sum + product.quantity);

  double get _groceryTotalPrice => _groceries.fold(
      0.0, (sum, product) => sum + (product.price * product.quantity));

  void _updateQuantity(int index, int qty) {
    setState(() {
      _products[index] = _products[index].copyWith(quantity: qty);
    });
  }

  void _updateGroceryQuantity(int index, int qty) {
    setState(() {
      _groceries[index] = _groceries[index].copyWith(quantity: qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Toggle between views
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _ViewToggleButton(
                  label: 'Shopping Cart',
                  icon: Icons.shopping_cart,
                  isSelected: !_showCatalog,
                  badgeCount: _totalItems,
                  onTap: () => setState(() => _showCatalog = false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ViewToggleButton(
                  label: 'Grocery Store',
                  icon: Icons.storefront,
                  isSelected: _showCatalog,
                  badgeCount: _groceryTotalItems,
                  onTap: () => setState(() => _showCatalog = true),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _showCatalog
              ? _buildGroceryCatalog(theme)
              : _buildShoppingCart(theme),
        ),
      ],
    );
  }

  Widget _buildShoppingCart(ThemeData theme) {
    return Column(
      children: [
        // Cart summary header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Row(
            children: [
              CartBadge(
                count: _totalItems,
                child: Icon(
                  Icons.shopping_cart,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shopping Cart',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_totalItems items',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '\$${_totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Product list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = _products[index];
              return CartProductTile(
                leading: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    product.image,
                    color: Colors.grey[600],
                    size: 32,
                  ),
                ),
                title: product.name,
                subtitle: product.description,
                price: '\$${product.price.toStringAsFixed(2)}',
                quantity: product.quantity,
                maxQuantity: 10,
                stepperSize: CartStepperSize.compact,
                onQuantityChanged: (qty) => _updateQuantity(index, qty),
                onRemove: () => _updateQuantity(index, 0),
              );
            },
          ),
        ),

        // Checkout button
        _buildCheckoutBar(theme, _totalItems, _totalPrice),
      ],
    );
  }

  Widget _buildGroceryCatalog(ThemeData theme) {
    return Column(
      children: [
        // Store header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.storefront, size: 32, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fresh Groceries',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Tap + to add items to your basket',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (_groceryTotalItems > 0)
                CartBadge(
                  count: _groceryTotalItems,
                  badgeColor: Colors.green.shade700,
                  child: Icon(
                    Icons.shopping_basket,
                    size: 28,
                    color: Colors.green.shade700,
                  ),
                ),
            ],
          ),
        ),

        // Grocery list with CartProductTile
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _groceries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final product = _groceries[index];
              final colors = [
                Colors.yellow.shade50,
                Colors.blue.shade50,
                Colors.amber.shade50,
                Colors.orange.shade50,
                Colors.pink.shade50,
                Colors.green.shade50,
              ];
              final iconColors = [
                Colors.yellow.shade800,
                Colors.blue.shade700,
                Colors.amber.shade800,
                Colors.orange.shade700,
                Colors.pink.shade700,
                Colors.green.shade700,
              ];
              return CartProductTile(
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    product.image,
                    color: iconColors[index % iconColors.length],
                    size: 28,
                  ),
                ),
                title: product.name,
                subtitle: product.description,
                price: '\$${product.price.toStringAsFixed(2)}',
                quantity: product.quantity,
                maxQuantity: 20,
                stepperSize: CartStepperSize.compact,
                stepperStyle: const CartStepperStyle(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  borderColor: Color(0xFF2E7D32),
                ),
                borderRadius: 16,
                onQuantityChanged: (qty) => _updateGroceryQuantity(index, qty),
                onRemove: () => _updateGroceryQuantity(index, 0),
              );
            },
          ),
        ),

        // Grocery checkout bar
        if (_groceryTotalItems > 0)
          _buildCheckoutBar(
            theme,
            _groceryTotalItems,
            _groceryTotalPrice,
            color: Colors.green.shade700,
          ),
      ],
    );
  }

  Widget _buildCheckoutBar(
    ThemeData theme,
    int totalItems,
    double totalPrice, {
    Color? color,
  }) {
    final btnColor = color ?? theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: totalItems > 0
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Checkout: $totalItems items for \$${totalPrice.toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              totalItems > 0
                  ? 'Checkout (\$${totalPrice.toStringAsFixed(2)})'
                  : 'Cart is Empty',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected
          ? theme.colorScheme.primaryContainer
          : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (badgeCount > 0)
                CartBadge(
                  count: badgeCount,
                  size: 16,
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey[600],
                  ),
                )
              else
                Icon(
                  icon,
                  size: 20,
                  color:
                      isSelected ? theme.colorScheme.primary : Colors.grey[600],
                ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// HELPERS
// =============================================================================
Widget _buildSection(
  BuildContext context,
  String title,
  String description,
  List<Widget> children,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      const SizedBox(height: 4),
      Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(children: children),
      ),
    ],
  );
}

Widget _buildRow(String label, Widget stepper) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
      stepper,
    ],
  );
}

// =============================================================================
// MODELS
// =============================================================================
class _Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final IconData image;

  const _Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image,
  });

  _Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    IconData? image,
  }) {
    return _Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }
}
