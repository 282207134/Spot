import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/widgets.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/wellness/wellness_screens.dart';
import '../features/creative/creative_screens.dart';
import '../features/creative/vacancy_screen.dart';
import '../features/creative/music_screen.dart';
import '../features/commerce/commerce_screens.dart';
import '../features/finance/finance_screens.dart';
import 'screen_registry.dart';

class SpotApp extends StatelessWidget {
  const SpotApp({
    super.key,
    required this.state,
    this.initialScreen,
    this.captureMode = false,
  });
  final AppState state;
  final String? initialScreen;
  final bool captureMode;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Spot — Everyday, beautifully',
    debugShowCheckedModeBanner: false,
    theme: spotTheme(),
    home: SpotShell(
      state: state,
      initialScreen: initialScreen,
      captureMode: captureMode,
    ),
  );
}

class SpotShell extends StatefulWidget {
  const SpotShell({
    super.key,
    required this.state,
    this.initialScreen,
    this.captureMode = false,
  });
  final AppState state;
  final String? initialScreen;
  final bool captureMode;
  @override
  State<SpotShell> createState() => _SpotShellState();
}

class _SpotShellState extends State<SpotShell> {
  Product? product;
  int page = 0;
  @override
  void initState() {
    super.initState();
    if (widget.initialScreen != null) {
      for (final p in products) {
        final index = screenSlugs[p.id]!.indexOf(widget.initialScreen!);
        if (index >= 0) {
          product = p;
          page = index;
          break;
        }
      }
    }
  }

  void open(Product value) => setState(() {
    product = value;
    page = 0;
  });
  void go(int index) =>
      setState(() => page = index.clamp(0, product!.screens.length - 1));
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, child) {
      if (product == null) return CatalogScreen(onOpen: open);
      final p = product!;
      final feature = _feature(p);
      if (widget.captureMode) return Scaffold(body: _phone(feature, p));
      return LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),
            body: SafeArea(
              child: Row(
                children: [
                  if (wide) _rail(p),
                  Expanded(
                    child: Column(
                      children: [
                        _toolbar(p, wide),
                        Expanded(
                          child: wide
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      30,
                                      4,
                                      30,
                                      24,
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 375 / 812,
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 5,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x16000618),
                                              blurRadius: 35,
                                              offset: Offset(0, 15),
                                            ),
                                          ],
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: SizedBox(
                                            width: 375,
                                            height: 812,
                                            child: _phone(feature, p),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : feature,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  Widget _feature(Product p) => switch (p.id) {
    'hydration' => HydrationScreen(
      key: ValueKey(p.id),
      page: page,
      go: go,
      state: widget.state,
    ),
    'journal' => JournalScreen(page: page, go: go, state: widget.state),
    'fitness' => FitnessScreen(
      key: ValueKey(p.id),
      page: page,
      go: go,
      state: widget.state,
    ),
    'drawing' => DrawingScreen(page: page, go: go, state: widget.state),
    'illustration' => IllustrationScreen(
      page: page,
      go: go,
      state: widget.state,
    ),
    'vacancy' => VacancyScreen(
      key: ValueKey(p.id),
      page: page,
      go: go,
      state: widget.state,
    ),
    'player' => MusicScreen(
      key: ValueKey(p.id),
      page: page,
      go: go,
      state: widget.state,
    ),
    'banking' || 'finance' || 'subscription' => FinanceScreen(
      key: ValueKey(p.id),
      product: p.id,
      page: page,
      go: go,
      state: widget.state,
    ),
    _ => CommerceScreen(
      key: ValueKey(p.id),
      product: p.id,
      page: page,
      go: go,
      state: widget.state,
    ),
  };
  Widget _toolbar(Product p, bool wide) => Container(
    height: wide ? 74 : 48,
    padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 8),
    color: wide ? Colors.transparent : Colors.white,
    child: Row(
      children: [
        IconButton(
          tooltip: 'All collections',
          onPressed: () => setState(() => product = null),
          icon: Icon(
            wide ? Icons.arrow_back : Icons.grid_view_outlined,
            size: 20,
          ),
        ),
        if (wide) ...[
          const SizedBox(width: 6),
          label(p.name, size: 18, weight: FontWeight.w600),
          const SizedBox(width: 12),
          Expanded(
            child: label(
              p.subtitle,
              size: 11,
              color: SpotColors.muted,
              lines: 1,
            ),
          ),
        ] else
          Expanded(child: label(p.name, size: 13, weight: FontWeight.w600)),

        IconButton(
          tooltip: 'Previous screen',
          onPressed: page > 0 ? () => go(page - 1) : null,
          icon: const Icon(Icons.chevron_left, size: 20),
        ),
        label(
          '${page + 1} / ${p.screens.length}',
          size: 11,
          color: SpotColors.muted,
        ),
        IconButton(
          tooltip: 'Next screen',
          onPressed: page < p.screens.length - 1 ? () => go(page + 1) : null,
          icon: const Icon(Icons.chevron_right, size: 20),
        ),
      ],
    ),
  );
  Widget _rail(Product p) => Container(
    width: 250,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 28, 22, 28),
          child: Row(
            children: [
              const Icon(Icons.blur_circular, color: SpotColors.ink, size: 32),
              const SizedBox(width: 10),
              label('spot', size: 28, weight: FontWeight.w700),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: label(
            'COLLECTIONS',
            size: 10,
            color: SpotColors.muted,
            weight: FontWeight.w600,
          ),
        ),
        gap(12),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final item in products)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    dense: true,
                    selected: p.id == item.id,
                    selectedTileColor: const Color(0xFFEEF3FF),
                    selectedColor: SpotColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    leading: Icon(item.icon, size: 20),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: label(
                      '${item.screens.length}',
                      size: 10,
                      color: SpotColors.muted,
                    ),
                    onTap: () => open(item),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEF2)),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('SPOT UI KIT', size: 10, weight: FontWeight.w600),
              gap(6),
              label(
                '13 collections · 30 screens',
                size: 11,
                color: SpotColors.muted,
              ),
              gap(6),
              label(
                '${widget.state.cartCount} items in your shopping bag',
                size: 11,
                color: SpotColors.muted,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _phone(Widget child, Product p) {
    final dark =
        p.id == 'player' ||
        (p.id == 'fitness' && page == 0) ||
        (p.id == 'subscription' && page == 0) ||
        (p.id == 'illustration' && page == 0) ||
        (p.id == 'toothbrush' && page < 2);
    final bg = dark
        ? (p.id == 'illustration'
              ? SpotColors.blue
              : p.id == 'toothbrush'
              ? (page == 0 ? const Color(0xFF167CF9) : const Color(0xFF808487))
              : p.id == 'player'
              ? const Color(0xFF666B76)
              : p.id == 'fitness'
              ? SpotColors.ink
              : const Color(0xFF969AA4))
        : (['hydration', 'drawing', 'toothbrush'].contains(p.id)
              ? SpotColors.canvas
              : Colors.white);
    final foreground = dark ? Colors.white : SpotColors.ink;
    return ColoredBox(
      color: bg,
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 7, 18, 0),
              child: Row(
                children: [
                  label(
                    '9:41',
                    size: 13,
                    color: foreground,
                    weight: FontWeight.w500,
                  ),
                  const Spacer(),
                  Icon(Icons.signal_cellular_alt, size: 16, color: foreground),
                  const SizedBox(width: 3),
                  Icon(Icons.wifi, size: 15, color: foreground),
                  const SizedBox(width: 5),
                  Icon(Icons.battery_full, size: 19, color: foreground),
                ],
              ),
            ),
          ),
          Expanded(child: child),
          SizedBox(
            height: 26,
            child: Center(
              child: Container(
                width: 130,
                height: 5,
                decoration: BoxDecoration(
                  color: foreground,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
