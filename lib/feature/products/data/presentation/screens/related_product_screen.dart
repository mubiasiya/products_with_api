import 'package:flutter/material.dart';
import 'package:with_api/feature/products/data/presentation/screens/productDetail_screen.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';


Widget buildRelatedProductsSection(
  BuildContext context,
  List<ProductModel> relatedProducts,
) {
  if (relatedProducts.isEmpty) return const SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'You Might Also Like',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.4,
          ),
        ),
      ),
      SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 16.0),
          itemCount: relatedProducts.length,
          itemBuilder: (context, index) {
            final product = relatedProducts[index];

          
            final String fallbackImage =
                product.images.isNotEmpty
                    ? product.images.first
                    : product.category.image;

            return GestureDetector(
              onTap: () {
               
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(product: product),
                  ),
                );
              },
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(right: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          fallbackImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, 
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
