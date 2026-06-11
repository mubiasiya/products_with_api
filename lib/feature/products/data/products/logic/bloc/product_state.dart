import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<ProductModel> relatedProducts;
  final String activeSearchQuery;
  final int? activeMinPrice;
  final int? activeMaxPrice;
  final ProductSortOrder activeSortOrder;

  ProductLoaded({
    required this.products,
    this.relatedProducts = const [],
    required this.activeSearchQuery,
    this.activeMinPrice,
    this.activeMaxPrice,
    this.activeSortOrder = ProductSortOrder.none,
  });


ProductLoaded copyWith({
  List<ProductModel>? products,
  List<ProductModel>? relatedProducts,
  String? activeSearchQuery,
  int? activeMinPrice,
  int? activeMaxPrice,
  ProductSortOrder? activeSortOrder,
}) {
  return ProductLoaded(
    products: products ?? this.products,
    relatedProducts: relatedProducts ?? this.relatedProducts,
    activeSearchQuery: activeSearchQuery ?? this.activeSearchQuery,
    activeMinPrice: activeMinPrice ?? this.activeMinPrice,
    activeMaxPrice: activeMaxPrice ?? this.activeMaxPrice,
    activeSortOrder: activeSortOrder ?? this.activeSortOrder,
  );
}
}


class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
