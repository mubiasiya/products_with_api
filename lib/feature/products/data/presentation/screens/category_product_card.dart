import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/cart/logic/cubit/cart_cubit.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';
import 'package:with_api/feature/products/data/presentation/screens/productDetail_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/scaff_msg.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/wishlist/logic/cubit/wishlist_cubit.dart';

class CategoryProductCard extends StatelessWidget {
  final ProductModel product;

  const CategoryProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(19),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    width: double.infinity,
                    child: Image.network(
                      product.images.isNotEmpty
                          ? product.images.first
                          : product.category.image,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (blocContext, state) {
                        bool isWishlisted = false;
                        if (state is WishlistLoaded) {
                          isWishlisted = state.wishlistItems.any(
                            (item) =>
                                item.id.toString() == product.id.toString(),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            context.read<WishlistCubit>().toggleWishlist(
                              product,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),

                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          final bool isProductInCart = state.cart.items.any(
                            (element) =>
                                element.product.id.toString() ==
                                product.id.toString(),
                          );

                          return GestureDetector(
                            onTap: () {
                              if (isProductInCart) {
                                context.read<CartCubit>().onCartItemDelete(
                                  CartItem(product: product, qty: 1),
                                );
                                scaff_msg('Removed from cart !', context);
                              } else {
                                context.read<CartCubit>().onCartAdd(
                                  CartItem(product: product, qty: 1),
                                );
                                scaff_msg('Added to cart !', context);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    isProductInCart
                                        ? Colors.green.shade600
                                        : Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                ) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  isProductInCart
                                      ? Icons.shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  key: ValueKey<bool>(isProductInCart),
                                  size: 16,
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
