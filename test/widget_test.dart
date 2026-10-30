import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spot_app/app/screen_registry.dart';
import 'package:spot_app/app/spot_app.dart';
import 'package:spot_app/core/app_state.dart';
import 'test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadFonts);
  test('store rejects invalid withdrawals and persists local values', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final state = AppState(preferences);
    expect(state.transfer(-1), isFalse);
    expect(state.transfer(double.nan), isFalse);
    expect(state.transfer(20000), isFalse);
    expect(state.balance, 16180.34);
    expect(state.transfer(80.34), isTrue);
    expect(state.balance, 16100);
    state.addWater(250);
    state.toggle('favorite.shoe');
    await Future<void>.delayed(Duration.zero);
    final restored = AppState(preferences);
    expect(restored.water, 1150);
    expect(restored.favorite('shoe'), isTrue);
    expect(restored.balance, 16100);
  });
  testWidgets('all 30 screens render and save actual Flutter screenshots', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() async {
      tester.view.resetDevicePixelRatio();
      await tester.binding.setSurfaceSize(null);
    });
    final output = Directory('docs/screenshots')..createSync(recursive: true);
    final boundary = GlobalKey();
    final errors = <String>[];
    for (final product in products) {
      for (final slug in screenSlugs[product.id]!) {
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundary,
            child: SpotApp(
              key: ValueKey(slug),
              state: AppState(),
              initialScreen: slug,
              captureMode: true,
            ),
          ),
        );
        await settleImages(tester);
        final error = tester.takeException();
        if (error != null) errors.add('$slug: $error');
        await tester.runAsync(() async {
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = await render.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          File(
            '${output.path}/$slug.png',
          ).writeAsBytesSync(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    }
    expect(
      output
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.png'))
          .length,
      30,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    expect(errors, isEmpty, reason: errors.join('\n'));
  });
  testWidgets('hydration logs a drink and updates the daily total', (
    tester,
  ) async {
    final state = AppState();
    await tester.pumpWidget(
      SpotApp(
        state: state,
        initialScreen: 'hydration-detail',
        captureMode: true,
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Add more drinks'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Add more drinks'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('250 ml'));
    await tester.pumpAndSettle();
    expect(state.water, 1150);
    expect(find.text('1150 ml today'), findsOneWidget);
  });
  testWidgets('shopping bag and demo checkout complete a local order', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final state = AppState();
    await tester.pumpWidget(
      SpotApp(state: state, initialScreen: 'shop-detail', captureMode: true),
    );
    await settleImages(tester);
    await tester.enterText(find.byType(TextField), 'SPOT10');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(state.value('promoApplied', false), isTrue);
    await tester.scrollUntilVisible(
      find.text('Add to Bag'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Add to Bag'));
    await tester.pumpAndSettle();
    expect(state.cartCount, 1);
    await tester.pump(const Duration(seconds: 3));
    await tester.ensureVisible(find.text('Go to Confirmation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Go to Confirmation'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Confirm Order'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Discount'), findsOneWidget);
    expect(find.text('\$13.90'), findsOneWidget);
    await tester.tap(find.text('Confirm Order'));
    await tester.pumpAndSettle();
    expect(find.text('Order confirmed'), findsOneWidget);
    expect(state.value('orders', 0), 1);
    expect(state.cartCount, 0);
  });
  testWidgets('wallet validates amounts and updates the displayed balance', (
    tester,
  ) async {
    final state = AppState();
    await tester.pumpWidget(
      SpotApp(state: state, initialScreen: 'finance-home', captureMode: true),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Withdraw'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '999999');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(find.text('Insufficient balance'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '180.34');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    expect(state.balance, 16000);
    expect(find.text('\$ 16,000.00'), findsOneWidget);
  });
  testWidgets('catalog searches and opens the matching collection', (
    tester,
  ) async {
    await tester.pumpWidget(SpotApp(state: AppState()));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'music');
    await tester.pumpAndSettle();
    expect(find.text('Spot Music'), findsOneWidget);
    expect(find.text('ShoeShop'), findsNothing);
    await tester.ensureVisible(find.text('Spot Music'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spot Music'));
    await tester.pumpAndSettle();
    expect(find.text('Media Library'), findsOneWidget);
  });
}
