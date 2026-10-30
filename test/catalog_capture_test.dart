import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot_app/app/spot_app.dart';
import 'package:spot_app/core/app_state.dart';
import 'test_support.dart';

void main() {
  testWidgets('save the collection overview and desktop layout', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    await tester.binding.setSurfaceSize(const Size(1180, 880));
    addTearDown(() async {
      tester.view.resetDevicePixelRatio();
      await tester.binding.setSurfaceSize(null);
    });
    await loadFonts();
    for (final item in [('catalog', null), ('desktop', 'hydration-home')]) {
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: SpotApp(
            key: ValueKey(item.$1),
            state: AppState(),
            initialScreen: item.$2,
          ),
        ),
      );
      final images = tester.widgetList<Image>(find.byType(Image));
      final context = tester.element(find.byType(Scaffold).first);
      await tester.runAsync(
        () => Future.wait(images.map((im) => precacheImage(im.image, context))),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 1.5);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File(
          'docs/${item.$1}.png',
        ).writeAsBytesSync(bytes!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
