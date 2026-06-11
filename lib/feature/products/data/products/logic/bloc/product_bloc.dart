import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/products/repositories/product_repo.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<FilterProductsEvent>(_onFilterProducts);
    on<FetchRelatedProductsEvent>(_onFetchRelatedProducts);
  }

  Future<void> _onFilterProducts(
    FilterProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    final String? currentSearch = event.searchQuery;
    final int? currentMin = event.minPrice;
    final int? currentMax = event.maxPrice;
    final ProductSortOrder currentSort =
        event.sortOrder ?? ProductSortOrder.none;

    if (currentSearch == null || currentSearch.trim().isEmpty) {
      emit(
        ProductLoaded(
          products: [],
          activeSearchQuery: '',
          activeMinPrice: currentMin,
          activeMaxPrice: currentMax,
          activeSortOrder: currentSort,
        ),
      );
      return;
    }

    emit(ProductLoading());

    try {
      List<ProductModel> filteredProducts = await _productRepository
          .fetchFilteredCatalog(
            searchQuery: currentSearch,
            minPrice: currentMin,

            maxPrice:
                (currentMax != null && currentMax >= 1000) ? null : currentMax,
          );

      if (currentMin != null || currentMax != null) {
        filteredProducts =
            filteredProducts.where((product) {
              final bool matchesMin =
                  currentMin == null || product.price >= currentMin;
              final bool matchesMax =
                  currentMax == null || product.price <= currentMax;
              return matchesMin && matchesMax;
            }).toList();
      }

      if (currentSort == ProductSortOrder.lowToHigh) {
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (currentSort == ProductSortOrder.highToLow) {
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      }

      emit(
        ProductLoaded(
          products: filteredProducts,
          activeSearchQuery: currentSearch,
          activeMinPrice: currentMin,
          activeMaxPrice: currentMax,
          activeSortOrder: currentSort,
        ),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onFetchRelatedProducts(
    FetchRelatedProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
   
    if (state is! ProductLoaded) return;

    final currentState = state as ProductLoaded;

    try {
    
      final List<ProductModel> related = await _productRepository
          .fetchRelatedProducts(event.slug);

     
      emit(currentState.copyWith(relatedProducts: related));
    } catch (_) {
     
      emit(currentState.copyWith(relatedProducts: const []));
    }
  }
}
