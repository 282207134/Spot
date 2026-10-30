import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spot_app/app/screen_registry.dart';
import 'package:spot_app/app/spot_app.dart';
import 'package:spot_app/core/app_state.dart';
import 'test_support.dart';

void main() {
  setUpAll(loadFonts);
  testWidgets('all screens fit compact phones and a short desktop window', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final errors = <String>[];
    for (final size in [const Size(320, 693), const Size(800, 600)]) {
      await tester.binding.setSurfaceSize(size);
      for (final product in products) {
        for (final slug in screenSlugs[product.id]!) {
          await tester.pumpWidget(
            SpotApp(
              key: ValueKey('$slug-$size'),
              state: AppState(),
              initialScreen: slug,
              captureMode: size.width < 760,
            ),
          );
          await tester.pumpAndSettle();
          final error = tester.takeException();
          if (error != null) errors.add('$size $slug: $error');
        }
      }
    }
    expect(errors, isEmpty, reason: errors.join('\n'));
  });
}
