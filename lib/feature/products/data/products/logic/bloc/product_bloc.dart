import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/models/product_model.dart';
import 'package:with_api/feature/products/data/products/repositories/product_repo.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    // on<LoadProductsEvent>(_onLoadProducts);
    on<FilterProductsEvent>(_onFilterProducts);
  }

  
  // Future<void> _onLoadProducts(
  //   LoadProductsEvent event,
  //   Emitter<ProductState> emit,
  // ) async {
  //   emit(ProductLoading());
  //   try {
  //     final products = await _productRepository.fetchFilteredCatalog();
  //     emit(ProductLoaded(products: products));
  //   } catch (e) {
  //     emit(ProductError(e.toString().replaceAll('Exception: ', '')));
  //   }
  // }

 
  Future<void> _onFilterProducts(
  FilterProductsEvent event,
  Emitter<ProductState> emit,
) async {
  String currentSearch = event.searchQuery ?? '';
  int? currentMin = event.minPrice;
  int? currentMax = event.maxPrice;
  ProductSortOrder currentSort = event.sortOrder ?? ProductSortOrder.none;

  // Retain previous active filters from state if not overwritten by this event
  if (state is ProductLoaded) {
    final currentState = state as ProductLoaded;
    currentSearch = event.searchQuery ?? currentState.activeSearchQuery;
    currentMin = event.minPrice ?? currentState.activeMinPrice;
    currentMax = event.maxPrice ?? currentState.activeMaxPrice;
    currentSort = event.sortOrder ?? currentState.activeSortOrder;
  }

  // If user cleared text completely, clear items instantly
  if (currentSearch.trim().isEmpty) {
    emit(ProductLoaded(
      products: [],
      activeSearchQuery: '',
      activeMinPrice: currentMin,
      activeMaxPrice: currentMax,
      activeSortOrder: currentSort,
    ));
    return;
  }

  emit(ProductLoading());

  try {
   
    List<ProductModel> filteredProducts = await _productRepository.fetchFilteredCatalog(
      searchQuery: currentSearch,
      minPrice: currentMin,
      maxPrice: currentMax,
    );

    
    if (currentSort == ProductSortOrder.lowToHigh) {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (currentSort == ProductSortOrder.highToLow) {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    emit(ProductLoaded(
      products: filteredProducts,
      activeSearchQuery: currentSearch,
      activeMinPrice: currentMin,
      activeMaxPrice: currentMax,
      activeSortOrder: currentSort,
    ));
  } catch (e) {
    emit(ProductError(e.toString()));
  }
}
}
