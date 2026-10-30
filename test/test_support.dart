import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadFonts() async {
  await (FontLoader(
    'Inter',
  )..addFont(rootBundle.load('assets/fonts/Inter.ttf'))).load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
}

Future<void> settleImages(WidgetTester tester) async {
  final images = tester.widgetList<Image>(find.byType(Image));
  final context = tester.element(find.byType(Scaffold).first);
  await tester.runAsync(() async {
    await Future.wait(
      images.map((image) => precacheImage(image.image, context)),
    );
  });
  await tester.pumpAndSettle();
}
