import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/cart/logic/cubit/cart_cubit.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';
import 'package:with_api/feature/products/data/presentation/screens/related_product_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/scaff_msg.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_state.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/wishlist/logic/cubit/wishlist_cubit.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<ProductBloc>().add(
      FetchRelatedProductsEvent(widget.product.slug),
    );
    print(widget.product.slug);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imagesToDisplay =
        widget.product.images.isNotEmpty
            ? widget.product.images
            : [widget.product.category.image];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 18,
              ), // Styled arrow
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.9),
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  bool isWishlisted = false;
                  if (state is WishlistLoaded) {
                    isWishlisted = state.wishlistItems.any(
                      (item) => item.id == widget.product.id,
                    );
                  }
                  return IconButton(
                    onPressed: () {
                      context.read<WishlistCubit>().toggleWishlist(
                        widget.product,
                      );
                    },
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 23,
                      color: Colors.redAccent,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32),
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          top: kToolbarHeight + 10,
                        ),
                        child: Hero(
                          tag: 'product_image_${widget.product.id}',
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: imagesToDisplay.length,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (int index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Image.network(
                                  imagesToDisplay[index],
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            imagesToDisplay.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentPage == index ? 22 : 8,
                              decoration: BoxDecoration(
                                color:
                                    _currentPage == index
                                        ? Colors.black
                                        : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            widget.product.category.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 16),
                        const Text(
                          'About this item',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            if (state is ProductDetailsLoaded) {
                              if (state.relatedProducts.isEmpty) {
                                return const Center(child: SizedBox.shrink());
                              }
                              return buildRelatedProductsSection(
                                context,
                                state.relatedProducts,
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),

                        // BlocBuilder<ProductBloc, ProductState>(
                        //   builder: (context, state) {
                        //     if (state is ProductLoaded &&
                        //         state.relatedProducts.isNotEmpty) {
                        //       return buildRelatedProductsSection(
                        //         context,
                        //         state.relatedProducts,
                        //       );
                        //     }
                        //     return const SizedBox.shrink();
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomActionBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Price',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Text(
                '\$${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              bool isProductInCart = state.cart.items.any(
                (element) => element.product.id == widget.product.id,
              );

              return Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (isProductInCart) {
                        Navigator.pushNamed(context, '/cart');
                      } else {
                        context.read<CartCubit>().onCartAdd(
                          CartItem(product: widget.product, qty: 1),
                        );
                        scaff_msg('Added to cart !', context);
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        isProductInCart ? 'Go to Cart' : 'Add to Cart',
                        key: ValueKey<bool>(isProductInCart),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
