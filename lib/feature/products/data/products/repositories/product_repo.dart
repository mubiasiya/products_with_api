import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/products/services/api/product_api.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<ProductModel>> fetchFilteredCatalog({
    String? searchQuery,
    int? minPrice,
    int? maxPrice,
  }) async {
    try {
      final String rawJson = await _apiService.getRawProductsData(
        title: searchQuery,
        priceMin: minPrice,
        priceMax: maxPrice,
      );

      final List<ProductModel> productList = productModelFromJson(rawJson);
      return productList;
    } catch (e) {
      print(e);
      throw Exception('Repository failing to process catalog data: $e');
    }
  }

  Future<List<ProductModel>> fetchRelatedProducts(String slug) async {
    try {
      final String rawJson = await _apiService.getRelatedProducts(slug);
      final List<ProductModel> productList = productModelFromJson(rawJson);
      return productList;
    } catch (e) {
      throw Exception('Repository failing to process related data: $e');
    }
  }

  Future<List<ProductModel>> catwiseProducts(int categoryId) async {
    try {
      final String rawJson = await _apiService.getCateWiseProducts(categoryId);
      final List<ProductModel> productList = productModelFromJson(rawJson);
      return productList;
    } catch (e) {
      throw Exception('Repository failing to process related data: $e');
    }
  }

  Future<List<ProductModel>> fetchtrendingProducts() async {
    try {
      final String rawJson = await _apiService.fetchRandomProducts();
      final List<ProductModel> productList = productModelFromJson(rawJson);
      productList.shuffle();
      return productList.take(4).toList();
    } catch (e) {
      throw Exception('Repository failing to process related data: $e');
    }
  }
}
