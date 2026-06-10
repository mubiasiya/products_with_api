
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';

class CartModel {
  final List<CartItem> items;

  CartModel({required this.items});

  double get totalCartPrice {
    return items.fold(
      0.0,
      (total, item) => total + item.product.price * item.qty,
    );
  }

  double get vat {
    return totalCartPrice * 0.05;
  }

  double get grandTotal {
    return totalCartPrice + vat + 5;
  }

  Map<String, dynamic> toMap() {
    return {'items': items.map((item) => item.toMap()).toList()};
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      items:
          (map['items'] as List<dynamic>?)?.map((item) {
            final Map<String, dynamic> safeItemMap = Map<String, dynamic>.from(
              item as Map,
            );
            return CartItem.fromMap(safeItemMap);
          }).toList() ??
          [],
    );
  }
}
