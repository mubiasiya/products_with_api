enum ProductSortOrder { none, lowToHigh, highToLow }

abstract class ProductEvent {}

class FilterProductsEvent extends ProductEvent {
  final String? searchQuery;
  final int? minPrice;
  final int? maxPrice;
  final ProductSortOrder? sortOrder;

  FilterProductsEvent({
    this.searchQuery,
    this.minPrice,
    this.maxPrice,
    this.sortOrder,
  });
}

class FetchRelatedProductsEvent extends ProductEvent {
  final String slug;
  FetchRelatedProductsEvent(this.slug);
}

class FetchCatWiseProductsEvent extends ProductEvent {
  final int cateId;

  FetchCatWiseProductsEvent({required this.cateId});
}
