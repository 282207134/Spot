import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/spot_app.dart';
import 'core/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences? preferences;
  try {
    preferences = await SharedPreferences.getInstance();
  } catch (_) {
    /* The app also works without local storage. */
  }
  const initial = String.fromEnvironment('SCREEN');
  runApp(
    SpotApp(
      state: AppState(preferences),
      initialScreen: initial.isEmpty ? null : initial,
    ),
  );
}
