import 'package:flutter/material.dart';
import '../../app/screen_registry.dart';
import '../../core/widgets.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.onOpen});
  final ValueChanged<Product> onOpen;
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String query = '';
  static const covers = {
    'hydration': 'avatar-john',
    'drawing': 'drawing-cover',
    'vacancy': 'job-featured',
    'shop': 'shirt-white',
    'toothbrush': 'brush-mini',
    'banking': 'avatar-tim',
    'illustration': 'illustration-large',
    'journal': 'meal-breakfast',
    'finance': 'game-machinarium',
    'player': 'music-dance',
    'shoe': 'shoe-red',
    'fitness': 'meal-snack',
    'subscription': 'game-alto',
  };
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F8FB),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shown = products
              .where(
                (p) => '${p.name} ${p.subtitle}'.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
          final width = constraints.maxWidth;
          final count = width > 1000
              ? 4
              : width > 720
              ? 3
              : width > 430
              ? 2
              : 2;
          final padding = width > 720 ? 48.0 : 22.0;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(padding, 34, padding, 30),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: SpotColors.ink,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Icon(
                              Icons.blur_circular,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 10),
                          label('spot', size: 25, weight: FontWeight.w700),
                          const Spacer(),
                          surface(
                            color: Colors.white,
                            radius: 24,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: label(
                              'UI COLLECTION',
                              size: 9,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      gap(38),
                      label(
                        'A little of\neverything.',
                        size: width > 720 ? 58 : 40,
                        weight: FontWeight.w600,
                      ),
                      gap(12),
                      label(
                        '13 collections. 30 beautifully crafted screens.\nChoose a world and make yourself at home.',
                        size: 14,
                        color: SpotColors.muted,
                      ),
                      gap(24),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Find a collection',
                            prefixIcon: Icon(Icons.search, size: 21),
                            fillColor: Colors.white,
                          ),
                          onChanged: (v) => setState(() => query = v),
                        ),
                      ),
                      gap(10),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: width > 720 ? 270 : 234,
                  ),
                  itemCount: shown.length,
                  itemBuilder: (context, index) {
                    final product = shown[index];
                    return Semantics(
                      button: true,
                      label: 'Open ${product.name}',
                      child: InkWell(
                        onTap: () => widget.onOpen(product),
                        borderRadius: BorderRadius.circular(16),
                        child: surface(
                          radius: 16,
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: product.color.withValues(alpha: .3),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(17),
                                    child: art(
                                      covers[product.id]!,
                                      fit: BoxFit.contain,
                                      radius: 8,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  14,
                                  10,
                                  14,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          label(
                                            product.name,
                                            size: width > 720 ? 18 : 14,
                                            weight: FontWeight.w600,
                                            lines: 1,
                                          ),
                                          gap(4),
                                          label(
                                            '${product.screens.length} screens',
                                            size: 10,
                                            color: SpotColors.muted,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_outward,
                                      size: 18,
                                      color: product.color == SpotColors.blue
                                          ? SpotColors.blue
                                          : SpotColors.ink,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(padding, 30, padding, 34),
                sliver: SliverToBoxAdapter(
                  child: label(
                    shown.isEmpty
                        ? 'No collections found. Try “music” or “shop”.'
                        : 'Made for the everyday. Designed to explore.',
                    size: 12,
                    color: SpotColors.muted,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
