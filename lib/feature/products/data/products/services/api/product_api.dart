// lib/core/services/api_service.dart
import 'package:http/http.dart' as http;
import 'package:with_api/feature/core/constants/api_endPoints.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<String> getRawProductsData({
    String? title,
    int? priceMin,
    int? priceMax,
    int? categoryId,
  }) async {
    String baseUri = '${ApiEndpoints.products}?';
    if (title != null && title.trim().isNotEmpty) {
      baseUri += 'title=$title';
    }

    if (priceMin != null) {
      baseUri += '&price_min=$priceMin';
    }

    if (priceMax != null) {
      baseUri += '&price_max=$priceMax';
    }

    if (categoryId != null) {
      baseUri += '&categoryId=$categoryId';
    }

    final Uri finalUrl = Uri.parse(baseUri);

    print('Generated Request URL: $finalUrl');

    final response = await _client.get(finalUrl);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Server error: HTTP ${response.statusCode}');
    }
  }

  Future<String> getRelatedProducts(String slug) async {
    String baseUri = ApiEndpoints.products;
    final url = Uri.parse('$baseUri/slug/$slug/related');
    print(url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to related products endpoint: $e');
    }
  }

  Future<String> getCateWiseProducts(int categoryId) async {
    String baseUri = ApiEndpoints.categories;
    final url = Uri.parse('$baseUri/$categoryId/products');
    print(url);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Server returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to related products endpoint: $e');
    }
  }
}
