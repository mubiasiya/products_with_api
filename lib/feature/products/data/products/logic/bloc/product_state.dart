import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final String activeSearchQuery;
  final int? activeMinPrice;
  final int? activeMaxPrice;
  final ProductSortOrder activeSortOrder;

  ProductLoaded({
    required this.products,
    required this.activeSearchQuery,
    this.activeMinPrice,
    this.activeMaxPrice,
    this.activeSortOrder = ProductSortOrder.none,
  });
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
