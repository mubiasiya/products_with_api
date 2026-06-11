import 'package:hive_flutter/hive_flutter.dart';
import 'package:with_api/feature/products/data/address/models/address_model.dart';

class HiveAddressService {
  static String? _activeUserId;

  static String _boxName(String userId) => 'address_box_$userId';

  static Future<void> openUserBox(String userId) async {
    _activeUserId = userId;
    if (!Hive.isBoxOpen(_boxName(userId))) {
      await Hive.openBox<List<dynamic>>(_boxName(userId));
    }
  }

  static Box<List<dynamic>> get _box {
    if (_activeUserId == null) throw Exception("No active user session found.");
    return Hive.box<List<dynamic>>(_boxName(_activeUserId!));
  }

  static List<AddressModel> getAddress() {
    final List<dynamic> rawItems =
        _box.get('addresses', defaultValue: []) as List<dynamic>;

    final List<AddressModel> items =
        rawItems.map((item) {
          return AddressModel.fromMap(Map<String, dynamic>.from(item as Map));
        }).toList();

    return items;
  }

  static Future<void> saveAddress(List<AddressModel> items) async {
    final List<Map<String, dynamic>> mapList =
        items.map((item) => item.toMap()).toList();
    await _box.put('addresses', mapList);
  }

  static Future<void> closeUserBox() async {
    if (_activeUserId != null) {
      final String name = _boxName(_activeUserId!);

      if (Hive.isBoxOpen(name)) {
        await Hive.box<List<dynamic>>(name).close();
      }

      _activeUserId = null;
    }
  }
}
