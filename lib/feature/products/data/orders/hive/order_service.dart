import 'package:hive_flutter/hive_flutter.dart';
import 'package:with_api/feature/products/data/orders/models/order_model.dart';

class HiveOrderService {
  static String? _activeUserId;

  static String _boxName(String userId) => 'orders_box_$userId';

  static Future<void> openUserBox(String userId) async {
    _activeUserId = userId;
    if (!Hive.isBoxOpen(_boxName(userId))) {
      await Hive.openBox(_boxName(userId));
    }
  }

  static Box get _box {
    if (_activeUserId == null) throw Exception("No active user session found.");
    return Hive.box(_boxName(_activeUserId!));
  }

  static List<OrderModel> getOrders() {
    final List<dynamic> rawOrders =
        _box.get('order_history', defaultValue: []) ?? [];

    return rawOrders.map((item) {
      final Map<String, dynamic> cleanOrderMap = _deepCastMap(item as Map);
      return OrderModel.fromMap(cleanOrderMap);
    }).toList();
  }

  static Future<void> saveOrder(OrderModel newOrder) async {
    final List<OrderModel> currentOrders = getOrders();
    currentOrders.insert(0, newOrder);

    final List<Map<String, dynamic>> mapList =
        currentOrders.map((order) => order.toMap()).toList();

    await _box.put('order_history', mapList);
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

  static Map<String, dynamic> _deepCastMap(Map<dynamic, dynamic> dynamicMap) {
    return dynamicMap.map((key, value) {
      final String stringKey = key.toString();

      if (value is Map) {
        return MapEntry(stringKey, _deepCastMap(value));
      } else if (value is List) {
        final cleanedList =
            value.map((element) {
              if (element is Map) {
                return _deepCastMap(element);
              }
              return element;
            }).toList();
        return MapEntry(stringKey, cleanedList);
      }

      return MapEntry(stringKey, value);
    });
  }
}
