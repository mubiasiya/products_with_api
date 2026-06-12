import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// Combine all loaded data into this single state class
class ProductLoaded extends ProductState {
  final List<ProductModel> products; // Holds search results
  final List<ProductModel>
  relatedProducts; // Holds detail page related products
  final String activeSearchQuery;
  final int? activeMinPrice;
  final int? activeMaxPrice;
  final ProductSortOrder activeSortOrder;
  final bool isLoadingRelated; // Helpful for detail page spinners

  ProductLoaded({
    required this.products,
    this.relatedProducts = const [],
    required this.activeSearchQuery,
    this.activeMinPrice,
    this.activeMaxPrice,
    required this.activeSortOrder,
    this.isLoadingRelated = false,
  });

  // CRITICAL: This allows updating related products without losing the search products
  ProductLoaded copyWith({
    List<ProductModel>? products,
    List<ProductModel>? relatedProducts,
    String? activeSearchQuery,
    int? activeMinPrice,
    int? activeMaxPrice,
    ProductSortOrder? activeSortOrder,
    bool? isLoadingRelated,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      activeSearchQuery: activeSearchQuery ?? this.activeSearchQuery,
      activeMinPrice: activeMinPrice ?? this.activeMinPrice,
      activeMaxPrice: activeMaxPrice ?? this.activeMaxPrice,
      activeSortOrder: activeSortOrder ?? this.activeSortOrder,
      isLoadingRelated: isLoadingRelated ?? this.isLoadingRelated,
    );
  }
}
