import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart'; // Verified your exact model path

class HiveWishlistService {
  static String? _activeUserId;

  static String _boxName(String userId) => 'wishlist_box_$userId';

  static Future<void> openUserBox(String userId) async {
    _activeUserId = userId;
    final name = _boxName(userId);
    if (!Hive.isBoxOpen(name)) {
      await Hive.openBox(name);
    }
  }

  static Box get _box {
    if (_activeUserId == null) throw Exception("No active user session found.");
    return Hive.box(_boxName(_activeUserId!));
  }

 
  static bool isFavorite(int productId) {
    return _box.containsKey(productId.toString());
  }

  
  static Future<void> addToWishlist(ProductModel product) async {
    
    final String jsonString = jsonEncode(product.toJson());
    await _box.put(product.id.toString(), jsonString);
  }

  
  static Future<void> removeFromWishlist(int productId) async {
    await _box.delete(productId.toString());
  }

 
  static List<ProductModel> getWishlist() {
    final List<ProductModel> list = [];

    for (var value in _box.values) {
      if (value is String) {
        try {
          final Map<String, dynamic> itemMap = jsonDecode(value);
        
          list.add(ProductModel.fromJson(itemMap));
        } catch (_) {
         
        }
      }
    }
    return list;
  }

  static Future<void> closeUserBox() async {
    if (_activeUserId != null) {
      final String name = _boxName(_activeUserId!);
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).close();
      }
      _activeUserId = null;
    }
  }
}
