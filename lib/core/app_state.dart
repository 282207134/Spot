import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One small local store shared by the independent product demos.
class AppState extends ChangeNotifier {
  AppState([this.preferences]) {
    final saved = preferences?.getString('spot.v1');
    if (saved != null) {
      try {
        final decoded = jsonDecode(saved);
        if (decoded is Map<String, dynamic>) _data.addAll(decoded);
      } on FormatException {
        /* Use defaults for an invalid local save. */
      }
    }
  }
  final SharedPreferences? preferences;
  final Map<String, dynamic> _data = {};
  T value<T>(String key, T fallback) =>
      _data[key] is T ? _data[key] as T : fallback;
  int get water => value('water', 900);
  int get cartCount => value('cartCount', 0);
  int get calories => value('calories', 923);
  double get balance => (value<num>('balance', 16180.34)).toDouble();
  bool favorite(String id) => value('favorite.$id', false);
  void set(String key, Object value) {
    _data[key] = value;
    notifyListeners();
    _save();
  }

  void toggle(String key) => set(key, !value(key, false));
  void addWater(int amount) => set('water', water + amount);
  void addToCart() => set('cartCount', cartCount + 1);
  void addMeal() => set('calories', calories + 340);
  bool transfer(double amount) {
    if (amount <= 0 || !amount.isFinite || amount > balance) return false;
    set('balance', double.parse((balance - amount).toStringAsFixed(2)));
    set('lastTransfer', amount);
    return true;
  }

  Future<void> _save() async {
    try {
      await preferences?.setString('spot.v1', jsonEncode(_data));
    } catch (_) {
      /* In-memory state stays usable if storage is unavailable. */
    }
  }
}
