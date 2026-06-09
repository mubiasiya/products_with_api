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
    final Uri baseUri = Uri.parse(ApiEndpoints.products);
    final Map<String, String> queryParameters = {};

   
    if (title != null && title.trim().isNotEmpty) {
      queryParameters['title'] = title.trim();
    }

    // 2. Add minimum price filter
    if (priceMin != null) {
      queryParameters['price_min'] = priceMin.toString();
    }

    // 3. Add maximum price filter
    if (priceMax != null) {
      queryParameters['price_max'] = priceMax.toString();
    }

    // 4. Add category filter
    if (categoryId != null) {
      queryParameters['categoryId'] = categoryId.toString();
    }

    // This dynamically combines all added parameters with proper '?' and '&' syntax
    final Uri finalUrl = baseUri.replace(
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    // Check your debug console to see the exact generated URL structure!
    print('Generated Request URL: $finalUrl');

    final response = await _client.get(finalUrl);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Server error: HTTP ${response.statusCode}');
    }
  }
}
