import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/widgets.dart';

class CommerceScreen extends StatefulWidget {
  const CommerceScreen({
    super.key,
    required this.product,
    required this.page,
    required this.go,
    required this.state,
  });
  final String product;
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  State<CommerceScreen> createState() => _CommerceScreenState();
}

class _CommerceScreenState extends State<CommerceScreen> {
  int quantity = 1, size = 2, color = 0, tab = 0, brand = 0;
  String query = '';
  final form = GlobalKey<FormState>();
  void add(String name, double price) {
    widget.state.set('selectedProduct', name);
    widget.state.set('selectedPrice', price);
    widget.state.set('selectedQuantity', quantity);
    widget.state.set('cartCount', widget.state.cartCount + quantity);
    toast(context, '$name added to your shopping bag');
  }

  @override
  Widget build(BuildContext context) => switch (widget.product) {
    'shop' => _shop(context),
    'shoe' => _shoe(context),
    _ => _brush(context),
  };
  Widget _shop(BuildContext context) {
    if (widget.page == 2) return _checkout(context);
    final home = widget.page == 0;
    return Scene(
      header: PageHeader(
        home ? 'The Top Shop' : 'Details',
        large: home,
        back: home ? null : () => widget.go(0),
        action: home ? Icons.shopping_cart_outlined : Icons.more_vert,
        onAction: () =>
            home ? widget.go(2) : toast(context, 'Made for everyday comfort.'),
      ),
      bottom: home
          ? ProductNavigation(
              index: 0,
              onSelect: (i) => i == 2
                  ? widget.go(2)
                  : i == 3
                  ? toast(context, 'Tap a product to view details and save it.')
                  : widget.go(i == 0 ? 0 : 1),
              icons: const [
                Icons.home_rounded,
                Icons.local_activity_outlined,
                Icons.local_shipping_outlined,
                Icons.favorite,
              ],
            )
          : null,
      body: PageBody(
        children: home
            ? [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, size: 18),
                  ),
                  onChanged: (value) => setState(() => query = value),
                ),
                gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final t in ['Sort by', 'Product', 'Style', 'Size'])
                      PopupMenuButton<String>(
                        onSelected: (v) => toast(context, '$t: $v'),
                        itemBuilder: (_) => [
                          for (final x in ['All', 'Newest', 'Popular'])
                            PopupMenuItem(value: x, child: Text(x)),
                        ],
                        child: Row(
                          children: [
                            label(t, size: 11),
                            const Icon(Icons.keyboard_arrow_down, size: 15),
                          ],
                        ),
                      ),
                  ],
                ),
                gap(12),
                label(
                  'Filters: T-Shirt ×   Casual ×',
                  size: 11,
                  color: SpotColors.muted,
                ),
                gap(18),
                if (query.isEmpty ||
                    'cotton t-shirt slim fit'.contains(
                      query.toLowerCase(),
                    )) ...[
                  _shopCard('shirt-white', 'Cotton T-Shirt\nSlim Fit', 17),
                  gap(22),
                ],
                if (query.isEmpty ||
                    'sleeveless t-shirt'.contains(query.toLowerCase()))
                  _shopCard('shirt-model', 'Sleeveless T-shirt', 11),
                if (query.isNotEmpty &&
                    !'cotton t-shirt slim fit sleeveless t-shirt'.contains(
                      query.toLowerCase(),
                    ))
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: label(
                      'No products found. Try “shirt”.',
                      color: SpotColors.muted,
                    ),
                  ),
              ]
            : [
                Choices(
                  labels: const [
                    'Details',
                    'Comments',
                    'Composition',
                    'Others',
                  ],
                  selected: tab,
                  onChanged: (i) => setState(() => tab = i),
                  color: SpotColors.ink,
                ),
                gap(16),
                art('shirt-pink', height: 245, width: double.infinity),
                gap(16),
                label('Sleeveless T-shirt', size: 19, weight: FontWeight.w500),
                gap(6),
                label(
                  switch (tab) {
                    1 =>
                      '“Soft, comfortable and a perfect fit.”\n4.8 / 5 · 128 customer reviews',
                    2 =>
                      '100% cotton. Machine wash cold. Made for easy, everyday wear.',
                    3 =>
                      'Free returns within 30 days. Standard delivery in 3–5 business days.',
                    _ =>
                      'On a warm day or layering under knitwear, this top is a necessary piece for wardrobe.',
                  },
                  size: 13,
                  color: SpotColors.muted,
                ),
                gap(18),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        'Size',
                        ['XS', 'S', 'M', 'L', 'XL'],
                        size,
                        (v) => setState(() => size = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown(
                        'Color',
                        ['Pink', 'White', 'Black'],
                        color,
                        (v) => setState(() => color = v),
                      ),
                    ),
                  ],
                ),
                gap(16),
                Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label('Quantity', size: 11, color: SpotColors.muted),
                          _stepper(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Promo Code',
                          hintText: 'Enter code',
                        ),
                        onSubmitted: (value) {
                          final valid = value.trim().toUpperCase() == 'SPOT10';
                          widget.state.set('promoApplied', valid);
                          toast(
                            context,
                            valid
                                ? 'SPOT10 applied: 10% off this demo order'
                                : 'Try SPOT10 for a demo discount',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                gap(18),
                actionButton(
                  'Add to Bag',
                  () => add('Sleeveless T-shirt', 11),
                  color: SpotColors.ink,
                  icon: Icons.shopping_bag_outlined,
                ),
                gap(10),
                actionButton(
                  'Go to Confirmation',
                  () => widget.go(2),
                  outlined: true,
                  color: SpotColors.ink,
                ),
              ],
      ),
    );
  }

  Widget _shopCard(String image, String title, int price) => InkWell(
    onTap: () => widget.go(1),
    child: Column(
      children: [
        Stack(
          children: [
            art(image, height: 245, width: double.infinity),
            Positioned(
              top: 12,
              right: 12,
              child: surface(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                radius: 20,
                child: label('\$$price', size: 12),
              ),
            ),
          ],
        ),
        gap(14),
        Row(
          children: [
            Expanded(child: label(title, size: 18)),
            SizedBox(
              width: 148,
              child: actionButton(
                'Get Started',
                () => widget.go(1),
                color: SpotColors.ink,
                icon: Icons.shopping_bag_outlined,
                height: 44,
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _checkout(BuildContext context) {
    final product = widget.state.value('selectedProduct', 'Sleeveless T-Shirt');
    final price = widget.state.value<num>('selectedPrice', 11).toDouble();
    final qty = widget.state.value('selectedQuantity', 1);
    final subtotal = price * qty + (widget.state.cartCount == 0 ? 17 : 0);
    final discount = widget.state.value('promoApplied', false)
        ? subtotal * .1
        : 0.0;
    return Scene(
      header: PageHeader(
        'Confirmation',
        large: false,
        back: () => widget.go(1),
        action: Icons.close,
        onAction: () => widget.go(0),
      ),
      body: PageBody(
        children: [
          section('Shopping Bag'),
          Row(
            children: [
              Expanded(child: label('$product × $qty', size: 13)),
              label('\$${(price * qty).toStringAsFixed(0)}', size: 13),
            ],
          ),
          if (widget.state.cartCount == 0) ...[
            gap(8),
            Row(
              children: [
                Expanded(child: label('Cotton T-Shirt Slim Fit', size: 13)),
                label('\$17', size: 13),
              ],
            ),
          ],
          gap(14),
          const Divider(color: Color(0xFFEEEEF1)),
          section('Credit Card'),
          Form(
            key: form,
            child: Column(
              children: [
                _field(
                  'Cardholder Name',
                  'Timofei Panov',
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter a cardholder name'
                      : null,
                ),
                gap(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _field(
                        'Card Number',
                        '4242 4242 4242 4242',
                        keyboard: TextInputType.number,
                        validator: (v) => v!.replaceAll(' ', '').length != 16
                            ? 'Use a 16-digit demo card'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        'Exp Date',
                        '03/28',
                        validator: (v) =>
                            RegExp(r'^\d{2}/\d{2}$').hasMatch(v ?? '')
                            ? null
                            : 'MM/YY',
                      ),
                    ),
                  ],
                ),
                gap(12),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        'CVC',
                        '000',
                        keyboard: TextInputType.number,
                        validator: (v) => v?.length == 3 ? null : '3 digits',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: _field('Country', 'USA')),
                  ],
                ),
              ],
            ),
          ),
          section('Payment Information'),
          for (final row in [
            ('Subtotal', subtotal),
            if (discount > 0) ('Discount', -discount),
            ('Delivery', 4.0),
            ('Total', subtotal - discount + 4),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: label(row.$1, color: SpotColors.muted)),
                  label(
                    '\$${row.$2.toStringAsFixed(2)}',
                    weight: row.$1 == 'Total'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ],
              ),
            ),
          gap(18),
          actionButton('Confirm Order', () {
            if (form.currentState!.validate()) {
              widget.state.set('cartCount', 0);
              widget.state.set('promoApplied', false);
              widget.state.set('orders', widget.state.value('orders', 0) + 1);
              showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  icon: const Icon(
                    Icons.check_circle,
                    color: SpotColors.green,
                    size: 48,
                  ),
                  title: const Text('Order confirmed'),
                  content: Text(
                    'Your demo order #${1000 + widget.state.value('orders', 0)} is ready. No payment was taken.',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        widget.go(0);
                      },
                      child: const Text('Back to shop'),
                    ),
                  ],
                ),
              );
            }
          }, color: SpotColors.ink),
        ],
      ),
    );
  }

  Widget _shoe(BuildContext context) {
    final home = widget.page == 0;
    return Scene(
      header: PageHeader(
        home ? 'ShoeShop' : '',
        back: home ? null : () => widget.go(0),
        action: Icons.menu,
        onAction: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                label('Your shopping bag', size: 24),
                gap(16),
                label('${widget.state.cartCount} items saved on this device'),
                gap(18),
                actionButton('Continue shopping', () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      ),
      body: PageBody(
        children: home
            ? [
                Stack(
                  children: [
                    art('shoe-hero', height: 160, width: double.infinity),
                    Positioned(
                      left: 18,
                      top: 14,
                      bottom: 14,
                      child: SizedBox(
                        width: 128,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label(
                              'Shoe Shops\nat now in\nyour city',
                              size: 21,
                              color: Colors.white,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 64,
                              height: 30,
                              child: FilledButton(
                                onPressed: () => widget.go(1),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: SpotColors.ink,
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  'Shop',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                gap(18),
                Choices(
                  labels: const ['NIKE', 'ADIDAS', 'PUMA', 'REEBOK'],
                  selected: brand,
                  onChanged: (i) => setState(() => brand = i),
                  color: SpotColors.ink,
                ),
                gap(14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: .83,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (final item in [
                      ('Nike Air Max 90 Premium', 'shoe-red', 125),
                      ('Nike Air Max 90 Premium', 'shoe-blue', 135),
                      ('Nike Air Max 270 React', 'shoe-mint', 147),
                      ('Nike Air Max 270 React', 'shoe-pink', 139),
                      ('Nike Air Max 270', 'shoe-grey', 129),
                      ('Nike Air Max 270', 'shoe-black', 145),
                    ])
                      InkWell(
                        onTap: () => widget.go(1),
                        child: surface(
                          color: const Color(0xFFF5F5F5),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              label(
                                brand == 0
                                    ? item.$1
                                    : '${['Nike', 'Adidas', 'Puma', 'Reebok'][brand]} Collection',
                                size: 12,
                                lines: 2,
                              ),
                              Expanded(
                                child: art(item.$2, fit: BoxFit.contain),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  label(
                                    '\$185.00',
                                    size: 9,
                                    color: SpotColors.muted,
                                  ),
                                  label(
                                    '\$${item.$3}.00',
                                    size: 12,
                                    weight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ]
            : [
                surface(
                  color: const Color(0xFFF5F5F5),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label(
                        'Nike Air Max 90\nPremium',
                        size: 23,
                        weight: FontWeight.w500,
                      ),
                      gap(10),
                      art(
                        'shoe-detail',
                        height: 218,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      gap(18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '\$185.00',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: SpotColors.muted,
                            ),
                          ),
                          label('\$125.00', size: 21, weight: FontWeight.w600),
                        ],
                      ),
                    ],
                  ),
                ),
                section(
                  'Choose Size',
                  action: 'What is my size?',
                  onAction: () => toast(
                    context,
                    'EU sizes: 38 = 24 cm · 40 = 25.5 cm · 42 = 27 cm',
                  ),
                ),
                Choices(
                  labels: const ['38', '39', '40', '41', '42', '43'],
                  selected: size,
                  onChanged: (i) => setState(() => size = i),
                  color: SpotColors.ink,
                ),
                gap(16),
                label(
                  'The Nike Air Max 90 Premium pays tribute to the steadfast Royal Mail workers in London. Nike-Air cushioning provides comfort for all-day wear, while fabric and leather add durability.',
                  size: 13,
                  color: SpotColors.muted,
                ),
                gap(22),
                Row(
                  children: [
                    SizedBox(
                      width: 64,
                      child: actionButton(
                        widget.state.favorite('shoe') ? '♥' : '♡',
                        () => widget.state.toggle('favorite.shoe'),
                        color: SpotColors.ink,
                        outlined: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: actionButton(
                        'Add to Bag',
                        () => add('Nike Air Max 90 · EU ${38 + size}', 125),
                        color: SpotColors.ink,
                      ),
                    ),
                  ],
                ),
              ],
      ),
    );
  }

  Widget _brush(BuildContext context) {
    if (widget.page == 0) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/brush-hero.png',
              fit: BoxFit.cover,
            ),
          ),
          Scene(
            background: Colors.transparent,
            header: PageHeader(
              'T-Brush Shop',
              color: Colors.white,
              action: Icons.shopping_cart_outlined,
              onAction: () =>
                  toast(context, '${widget.state.cartCount} items in your bag'),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                label(
                  'Modern luxury meets\neveryday brushing',
                  size: 15,
                  color: Colors.white70,
                ),
                gap(380),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    separatorBuilder: (_, i) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () => widget.go(1),
                      child: surface(
                        width: 235,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            art(
                              i == 0 ? 'brush-mini' : 'brush-card',
                              width: 74,
                              height: 120,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  label('New Electric\ntoothbrushes', size: 14),
                                  gap(5),
                                  label(
                                    'The ultimate clean',
                                    size: 11,
                                    color: SpotColors.muted,
                                  ),
                                  gap(6),
                                  label(
                                    'Show all stuff',
                                    size: 11,
                                    color: SpotColors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                gap(20),
              ],
            ),
          ),
        ],
      );
    }
    if (widget.page == 1) {
      return Scene(
        background: SpotColors.canvas,
        header: const SizedBox.shrink(),
        bottom: ProductNavigation(
          index: 0,
          onSelect: (i) => widget.go(i == 0 ? 0 : 2),
          icons: const [
            Icons.home_rounded,
            Icons.credit_card,
            Icons.local_activity,
            Icons.shopping_basket,
            Icons.grid_view,
          ],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () => widget.go(2),
                  child: art(
                    'brush-glacier',
                    height: 256,
                    width: double.infinity,
                    radius: 0,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: PageHeader(
                    'Toothbrushes',
                    large: false,
                    color: Colors.white,
                    back: () => widget.go(0),
                    action: Icons.tune,
                    onAction: () =>
                        toast(context, 'Showing all electric toothbrushes.'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: label('Glacier Toothbrush', size: 21)),
                      label('\$79.99', size: 18, color: SpotColors.blue),
                    ],
                  ),
                  gap(12),
                  label(
                    'The built-in timer ensures you brush for a dentist-recommended two minutes, with 30-second prompts to tell you when it’s time to switch quadrants.',
                    color: SpotColors.muted,
                  ),
                  section(
                    'Maybe you will like it',
                    action: 'View all',
                    onAction: () => widget.go(2),
                  ),
                  InkWell(
                    onTap: () => widget.go(2),
                    child: surface(
                      child: Row(
                        children: [
                          art('brush-card', height: 135, width: 94),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                label('Goby', color: SpotColors.pink),
                                label('Top electric\ntoothbrush', size: 18),
                                gap(12),
                                label('\$60', size: 20, color: SpotColors.blue),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  gap(16),
                  actionButton('View electric toothbrush', () => widget.go(2)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Scene(
      background: SpotColors.canvas,
      header: const SizedBox.shrink(),
      bottom: ProductNavigation(
        index: 1,
        onSelect: (i) => widget.go(i == 0 ? 0 : 1),
        icons: const [
          Icons.home_rounded,
          Icons.credit_card,
          Icons.local_activity,
          Icons.shopping_basket,
          Icons.grid_view,
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              art('brush-pink', height: 340, width: double.infinity, radius: 0),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: () => widget.go(1),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  tooltip: 'Close',
                  onPressed: () => widget.go(0),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: label('Goby', color: SpotColors.muted)),
                    label('\$60.00', size: 20, color: SpotColors.blue),
                  ],
                ),
                label(
                  'Black Electric\nToothbrush',
                  size: 24,
                  weight: FontWeight.w500,
                ),
                gap(16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          label('Color', size: 11, color: SpotColors.muted),
                          gap(6),
                          Row(
                            children: [
                              for (var i = 0; i < 3; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () => setState(() => color = i),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: [
                                          SpotColors.ink,
                                          SpotColors.rose,
                                          Colors.white,
                                        ][i],
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: color == i
                                              ? SpotColors.blue
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        label('Qty', size: 11, color: SpotColors.muted),
                        _stepper(),
                      ],
                    ),
                  ],
                ),
                gap(12),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: label('Description', size: 13),
                  children: [
                    label(
                      'A powerful, gentle clean. Two brushing modes, a two-minute timer and a rechargeable battery.',
                      size: 12,
                      color: SpotColors.muted,
                    ),
                  ],
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: label('Delivery and payment', size: 13),
                  children: [
                    label(
                      'Standard delivery in 3–5 business days. Free returns within 30 days.',
                      size: 12,
                      color: SpotColors.muted,
                    ),
                  ],
                ),
                gap(12),
                actionButton(
                  'Add to Bag · \$${60 * quantity}',
                  () => add('Goby Electric Toothbrush', 60),
                  color: SpotColors.ink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepper() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        tooltip: 'Decrease quantity',
        onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
        icon: const Icon(Icons.remove, size: 16),
        constraints: const BoxConstraints(minWidth: 30, minHeight: 36),
        padding: EdgeInsets.zero,
      ),
      label('$quantity', size: 13),
      IconButton(
        tooltip: 'Increase quantity',
        onPressed: quantity < 9 ? () => setState(() => quantity++) : null,
        icon: const Icon(Icons.add, size: 16),
        constraints: const BoxConstraints(minWidth: 30, minHeight: 36),
        padding: EdgeInsets.zero,
      ),
    ],
  );
  Widget _dropdown(
    String hint,
    List<String> options,
    int selected,
    ValueChanged<int> onChanged,
  ) => DropdownButtonFormField<int>(
    initialValue: selected.clamp(0, options.length - 1),
    decoration: InputDecoration(labelText: hint),
    items: List.generate(
      options.length,
      (i) => DropdownMenuItem(value: i, child: label(options[i], size: 12)),
    ),
    onChanged: (v) {
      if (v != null) onChanged(v);
    },
  );
  Widget _field(
    String hint,
    String initial, {
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) => TextFormField(
    initialValue: initial,
    keyboardType: keyboard,
    style: const TextStyle(fontSize: 12),
    validator: validator,
    decoration: InputDecoration(
      labelText: hint,
      labelStyle: const TextStyle(fontSize: 11),
    ),
  );
}
