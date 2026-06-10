import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/cart/logic/cubit/cart_cubit.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';
import 'package:with_api/feature/products/data/presentation/widgets/scaff_msg.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/wishlist/logic/cubit/wishlist_cubit.dart';

Widget productCard(
  ProductModel product,
  void Function()? onTap,
  BuildContext context,
) {
  return Card(
    elevation: 2,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child:
                    product.images.isNotEmpty
                        ? Image.network(
                          product.images[0],
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  radius: 18,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      bool isWishlisted = false;
                      if (state is WishlistLoaded) {
                        isWishlisted = state.wishlistItems.any(
                          (item) => item.id == product.id,
                        );
                      }
                      return IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          context.read<WishlistCubit>().toggleWishlist(product);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ), // Stack close

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(25)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        context.read<CartCubit>().onCartAdd(
                          CartItem(product: product, qty: 1),
                        );
                        scaff_msg('Added to cart !', context);
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
