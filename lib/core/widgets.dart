import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'spot_theme.dart';
export 'spot_theme.dart';

Text label(
  String text, {
  double size = 14,
  Color color = SpotColors.ink,
  FontWeight weight = FontWeight.w400,
  TextAlign? align,
  int? lines,
}) => Text(
  text,
  textAlign: align,
  maxLines: lines,
  overflow: lines == null ? null : TextOverflow.ellipsis,
  style: TextStyle(
    fontSize: size,
    color: color,
    fontWeight: weight,
    height: 1.4,
    letterSpacing: size >= 24 ? -1.1 : -0.35,
  ),
);
Widget gap([double size = 16]) => SizedBox(height: size);
Widget art(
  String name, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  double radius = 8,
}) => ClipRRect(
  borderRadius: BorderRadius.circular(radius),
  child: Image.asset(
    'assets/images/$name.png',
    width: width,
    height: height,
    fit: fit,
    filterQuality: FilterQuality.medium,
    semanticLabel: name.replaceAll('-', ' '),
  ),
);
Widget surface({
  required Widget child,
  Color color = Colors.white,
  EdgeInsets padding = const EdgeInsets.all(18),
  double radius = 10,
  double? width,
  double? height,
}) => Container(
  width: width,
  height: height,
  padding: padding,
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
  ),
  child: child,
);
Widget section(
  String title, {
  String? action,
  VoidCallback? onAction,
  Color color = SpotColors.ink,
}) => Padding(
  padding: const EdgeInsets.only(top: 20, bottom: 12),
  child: Row(
    children: [
      Expanded(
        child: label(title, size: 18, color: color, weight: FontWeight.w500),
      ),
      if (action != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 32),
          ),
          child: label(action, size: 11, color: SpotColors.blue),
        ),
    ],
  ),
);
Widget actionButton(
  String text,
  VoidCallback onTap, {
  Color color = SpotColors.blue,
  bool outlined = false,
  IconData? icon,
  double height = 48,
}) => SizedBox(
  height: height,
  width: double.infinity,
  child: outlined
      ? OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color.withValues(alpha: .45)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: label(text, color: color),
        )
      : FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Flexible(child: label(text, color: Colors.white)),
            ],
          ),
        ),
);
void toast(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.padding = 24});
  final List<Widget> children;
  final double padding;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(padding, 8, padding, 24),
    children: children,
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader(
    this.title, {
    super.key,
    this.subtitle,
    this.back,
    this.action,
    this.onAction,
    this.avatar,
    this.color = SpotColors.ink,
    this.large = true,
  });
  final String title;
  final String? subtitle, avatar;
  final VoidCallback? back, onAction;
  final IconData? action;
  final Color color;
  final bool large;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 18, 20),
    child: Row(
      children: [
        if (back != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: back,
              icon: Icon(Icons.arrow_back, color: color, size: 21),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 40),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null) ...[
                label(subtitle!, size: 12, color: color.withValues(alpha: .6)),
                gap(5),
              ],
              label(
                title,
                size: large ? 28 : 17,
                weight: FontWeight.w500,
                color: color,
              ),
            ],
          ),
        ),
        if (avatar != null) art(avatar!, width: 48, height: 48, radius: 30),
        if (action != null)
          IconButton(
            onPressed: onAction,
            tooltip: action == Icons.grid_view_outlined
                ? 'All collections'
                : 'More options',
            icon: Icon(action, color: color, size: 22),
          ),
      ],
    ),
  );
}

class ProductNavigation extends StatelessWidget {
  const ProductNavigation({
    super.key,
    required this.index,
    required this.onSelect,
    this.dark = false,
    this.icons = const [
      Icons.home_rounded,
      Icons.credit_card_outlined,
      Icons.bar_chart_rounded,
      Icons.grid_view_rounded,
    ],
  });
  final int index;
  final ValueChanged<int> onSelect;
  final bool dark;
  final List<IconData> icons;
  @override
  Widget build(BuildContext context) => Container(
    height: 62,
    color: dark ? Colors.black : Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        icons.length,
        (i) => IconButton(
          tooltip: ['Home', 'Browse', 'Activity', 'More', 'Favorites'][i],
          onPressed: () => onSelect(i),
          icon: Icon(
            icons[i],
            size: 21,
            color: i == index
                ? SpotColors.blue
                : (dark ? Colors.white54 : const Color(0xFFC5C7CC)),
          ),
        ),
      ),
    ),
  );
}

class Choices extends StatelessWidget {
  const Choices({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.color = SpotColors.blue,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final Color color;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(
        labels.length,
        (i) => Padding(
          padding: const EdgeInsets.only(right: 7),
          child: ChoiceChip(
            label: Text(labels[i], style: const TextStyle(fontSize: 11)),
            selected: i == selected,
            onSelected: (_) => onChanged(i),
            showCheckmark: false,
            selectedColor: color.withValues(alpha: .16),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: i == selected ? color : const Color(0xFFE8E9ED),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
    ),
  );
}

class RingChart extends StatelessWidget {
  const RingChart({
    super.key,
    this.size = 160,
    this.values = const [.76, .86, .92],
    this.colors = const [SpotColors.blue, SpotColors.green, SpotColors.pink],
    this.center,
  });
  final double size;
  final List<double> values;
  final List<Color> colors;
  final Widget? center;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _RingPainter(values, colors),
      child: Center(child: center),
    ),
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.values, this.colors);
  final List<double> values;
  final List<Color> colors;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    for (var i = values.length - 1; i >= 0; i--) {
      final r = size.width / 2 - 5 - (values.length - 1 - i) * 14;
      final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);
      canvas.drawArc(
        rect,
        0,
        2 * math.pi,
        false,
        paint..color = const Color(0xFFE6E7EB),
      );
      canvas.drawArc(
        rect,
        -math.pi / 2 + .1,
        values[i].clamp(0, 1) * 2 * math.pi,
        false,
        paint..color = colors[i],
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.values != values;
}

class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    this.values = const [.86, .6, .72, .48, 1, .69, .52],
    this.color = SpotColors.blue,
    this.labels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.height = 180,
  });
  final List<double> values;
  final Color color;
  final List<String> labels;
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        values.length,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: (height - 28) * values[i],
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: i == 4 ? 1 : .25),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                gap(8),
                label(labels[i], size: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget metric(String title, String value, {Color color = SpotColors.ink}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(title, size: 11, color: color.withValues(alpha: .6)),
        gap(3),
        label(value, size: 16, color: color),
      ],
    );
Widget avatar(String name, {double size = 40}) =>
    art(name, width: size, height: size, radius: size);

class Scene extends StatelessWidget {
  const Scene({
    super.key,
    required this.header,
    required this.body,
    this.bottom,
    this.background = Colors.white,
  });
  final Widget header, body;
  final Widget? bottom;
  final Color background;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: background,
    child: Column(
      children: [
        header,
        Expanded(child: body),
        ?bottom,
      ],
    ),
  );
}
