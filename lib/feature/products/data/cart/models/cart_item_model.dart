

import 'package:with_api/feature/products/data/products/models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int qty;

  const CartItem({required this.product, required this.qty});

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: ProductModel.fromJson(
        Map<String, dynamic>.from(map['product'] as Map),
      ),
      qty: map['qty'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'product': product.toJson(), 'qty': qty};
  }
}
