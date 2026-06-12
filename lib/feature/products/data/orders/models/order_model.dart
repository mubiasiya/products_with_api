// Import your new wrapper model

import 'package:with_api/feature/products/data/address/models/address_model.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';

class OrderModel {
  final String orderId;
  final DateTime dateTime;
  final List<CartItem> items; // Updated to hold quantity data
  final double totalAmount;
  final String paymentMethod;
  final AddressModel deliveryAddress;

  OrderModel({
    required this.orderId,
    required this.dateTime,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'dateTime': dateTime.toIso8601String(),
      'items':
          items
              .map((item) => item.toMap())
              .toList(), // Serializes product + quantity
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress.toMap(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      items:
          List<dynamic>.from(map['items'] ?? [])
              .map((item) => CartItem.fromMap(Map<String, dynamic>.from(item)))
              .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      deliveryAddress: AddressModel.fromMap(
        Map<String, dynamic>.from(map['deliveryAddress']),
      ),
    );
  }
}
