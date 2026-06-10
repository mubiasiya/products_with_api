import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:with_api/feature/products/data/cart/models/cart_model.dart';


class HiveCartService {
  static String? _activeUserId;

  static String _boxName(String userId) => 'cart_box_$userId';

  static Future<void> openUserBox(String userId) async {
    _activeUserId = userId;
    if (!Hive.isBoxOpen(_boxName(userId))) {
      await Hive.openBox<dynamic>(_boxName(userId));
    }
  }

  static Box<dynamic> get _box {
    if (_activeUserId == null) throw Exception("No active user session found.");
    return Hive.box<dynamic>(_boxName(_activeUserId!));
  }

  static Future<void> saveCart(CartModel cart) async {
    final String jsonString = jsonEncode(cart.toMap());
    await _box.put('cart_json', jsonString);
  }

  static CartModel getCart() {
    final String? jsonString = _box.get('cart_json');

    if (jsonString != null && jsonString.isNotEmpty) {
      final decodedMap = jsonDecode(jsonString);
      return CartModel.fromMap(Map<String, dynamic>.from(decodedMap));
    }

    return CartModel(items: []);
  }

  static Future<void> clearCart() async {
    await _box.delete('cart_json');
  }

  static Future<void> closeUserBox() async {
    if (_activeUserId != null) {
      await Hive.box(_boxName(_activeUserId!)).close();
      _activeUserId = null;
    }
  }
}
