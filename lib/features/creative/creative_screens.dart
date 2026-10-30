import 'package:flutter/material.dart';
import '../../core/app_state.dart';
import '../../core/widgets.dart';

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  Widget build(BuildContext context) => Scene(
    background: SpotColors.canvas,
    header: PageHeader(
      page == 0 ? 'Drawing Tutorials and\nUnique Techniques' : '',
      back: page == 1 ? () => go(0) : null,
      large: page == 0,
      action: page == 1 ? Icons.more_vert : null,
      onAction: () => toast(context, 'A new creative challenge, every day.'),
    ),
    bottom: page == 0
        ? ProductNavigation(
            index: 0,
            onSelect: (i) => i == 0 ? go(0) : go(1),
            icons: const [
              Icons.home_rounded,
              Icons.brush,
              Icons.menu_book,
              Icons.favorite,
            ],
          )
        : null,
    body: PageBody(
      children: page == 0
          ? [
              surface(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
                child: Column(
                  children: [
                    art('drawing-cover', height: 220, fit: BoxFit.contain),
                    gap(20),
                    label(
                      'Drawing Ideas\nThat Anyone\nCan Try',
                      size: 28,
                      weight: FontWeight.w500,
                      align: TextAlign.center,
                    ),
                    gap(14),
                    label(
                      'Easy drawing ideas\ninspired by real life.',
                      size: 14,
                      color: SpotColors.muted,
                      align: TextAlign.center,
                    ),
                    gap(22),
                    SizedBox(
                      width: 140,
                      child: actionButton('Show More', () => go(1)),
                    ),
                    gap(22),
                    label('12 000 Reviews', size: 15),
                  ],
                ),
              ),
              gap(16),
              surface(
                child: Column(
                  children: [
                    art('job-developer', height: 170),
                    gap(12),
                    label('Find your own creative rhythm', size: 22),
                  ],
                ),
              ),
            ]
          : [
              label(
                'Machinery and\nmechanical parts',
                size: 28,
                weight: FontWeight.w500,
              ),
              gap(6),
              label(
                'Such as old sewing machines,\ndisassembled clocks, robots etc.',
                color: SpotColors.muted,
              ),
              gap(20),
              SizedBox(
                height: 160,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: art(
                    'drawing-carousel',
                    width: 390,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              gap(24),
              label('Your self-portrait', size: 18, weight: FontWeight.w500),
              gap(14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: art('drawing-portrait', height: 190)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(
                          '• Draw a circle in the center of the page\n• Draw a vertical line down the center of the circle',
                          color: SpotColors.muted,
                        ),
                        TextButton(
                          onPressed: () => _lesson(context),
                          child: label(
                            'Continue Tutorial ›',
                            size: 11,
                            color: SpotColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gap(22),
              label('Trees outside your window', size: 18),
              gap(14),
              art('job-developer', height: 180, fit: BoxFit.contain),
              gap(16),
              actionButton(
                state.value('lessonComplete', false)
                    ? 'Tutorial completed ✓'
                    : 'Start this lesson',
                () => _lesson(context),
              ),
            ],
    ),
  );
  void _lesson(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Your self-portrait'),
      content: const Text(
        '1. Draw a light circle.\n2. Add a vertical guide.\n3. Mark the eye line halfway down.\n4. Add the nose, mouth and your own details.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Keep practicing'),
        ),
        FilledButton(
          onPressed: () {
            state.set('lessonComplete', true);
            Navigator.pop(context);
            toast(context, 'Lesson completed. Keep creating!');
          },
          child: const Text('Mark complete'),
        ),
      ],
    ),
  );
}

class IllustrationScreen extends StatelessWidget {
  const IllustrationScreen({
    super.key,
    required this.page,
    required this.go,
    required this.state,
  });
  final int page;
  final ValueChanged<int> go;
  final AppState state;
  @override
  Widget build(BuildContext context) {
    if (page == 0) {
      return Scene(
        background: SpotColors.blue,
        header: PageHeader(
          'Illustration Shop',
          color: Colors.white,
          action: Icons.shopping_cart_outlined,
          onAction: () => go(2),
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Row(
                  children: [
                    avatar('avatar-tim', size: 46),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('Tim Panov', size: 17, color: Colors.white),
                        label('Online', size: 12, color: Colors.white70),
                      ],
                    ),
                  ],
                ),
                gap(30),
                for (final menu in [
                  (Icons.dashboard_outlined, 'Menu'),
                  (Icons.favorite, 'Favourite'),
                  (Icons.menu_book_outlined, 'Recipes'),
                  (Icons.storefront_outlined, 'Our Shops'),
                  (Icons.receipt_long_outlined, 'Orders History'),
                  (Icons.settings_outlined, 'Settings'),
                  (Icons.help_outline, 'Support'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => go(1),
                      child: SizedBox(
                        height: 38,
                        child: Row(
                          children: [
                            Icon(menu.$1, color: Colors.white, size: 21),
                            const SizedBox(width: 10),
                            label(menu.$2, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                gap(45),
                TextButton.icon(
                  onPressed: () => toast(
                    context,
                    'This is a local demo. No account is signed in.',
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                  label: label('Logout', color: Colors.white),
                ),
              ],
            ),
            Positioned(
              left: 208,
              top: 46,
              bottom: 22,
              right: -110,
              child: IgnorePointer(
                child: art(
                  'illustration-preview',
                  fit: BoxFit.contain,
                  radius: 0,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scene(
      header: PageHeader(
        page == 1 ? 'Menu' : 'Popular',
        large: false,
        back: () => go(page == 1 ? 0 : 1),
        action: Icons.more_vert,
        onAction: () =>
            toast(context, 'Original artwork from the Spot UI Kit.'),
      ),
      body: PageBody(
        children: page == 1
            ? [
                section('Main Info'),
                surface(
                  color: SpotColors.canvas,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('15 Transactions', color: SpotColors.muted),
                            gap(6),
                            label(
                              'A broad range of illustrations in\nan international, modern style.',
                              size: 11,
                              color: SpotColors.muted,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => go(2),
                        icon: const Icon(
                          Icons.play_circle_fill,
                          size: 40,
                          color: SpotColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                section('Recommend for you'),
                SizedBox(
                  height: 155,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, i) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () => go(2),
                      child: art(
                        [
                          'illustration-one',
                          'illustration-two',
                          'illustration-three',
                        ][i],
                        width: 118,
                        height: 155,
                      ),
                    ),
                  ),
                ),
                section('Premium illustrations'),
                SizedBox(
                  height: 195,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    separatorBuilder: (_, i) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () => go(2),
                      child: art(
                        i == 0 ? 'illustration-premium' : 'illustration-large',
                        width: 250,
                        height: 195,
                      ),
                    ),
                  ),
                ),
                gap(20),
                actionButton('Explore popular illustrations', () => go(2)),
              ]
            : [
                art('illustration-large', height: 360),
                Transform.translate(
                  offset: const Offset(0, -22),
                  child: Center(
                    child: SizedBox(
                      width: 160,
                      child: actionButton('Add to Cart \$9', () {
                        state.addToCart();
                        toast(
                          context,
                          'Illustration added · ${state.cartCount} items in your bag',
                        );
                      }),
                    ),
                  ),
                ),
                section('Simple illustrations'),
                label(
                  'In a broad area from illustration, which stretches across national borders and multiple media, identifying trends accurately is a bit of a minefield.',
                  color: SpotColors.muted,
                ),
                gap(26),
                actionButton('Proceed to Checkout', () {
                  state.addToCart();
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Your illustration is ready'),
                      content: const Text(
                        'A \$9 illustration has been added to your local shopping bag. Checkout is a demonstration; no payment is taken.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Continue exploring'),
                        ),
                      ],
                    ),
                  );
                }, outlined: true),
              ],
      ),
    );
  }
}
