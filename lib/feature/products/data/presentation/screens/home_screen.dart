import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/address/logic/cubit/address_cubit.dart';
import 'package:with_api/feature/products/data/presentation/screens/category_by_products_screen.dart';
import 'package:with_api/feature/products/data/presentation/screens/search_product_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/cart_icon.dart';
import 'package:with_api/feature/products/data/presentation/widgets/icon_button.dart';
import 'package:with_api/feature/products/data/products/models/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: non_constant_identifier_names
  final List<Category> Categories = [
    Category(
      id: 1,
      name: "Clothes",
      slug: "clothes",
      image: "https://i.imgur.com/QkIa5tT.jpeg",
    ),
    Category(
      id: 2,
      name: "Electronics",
      slug: "electronics",
      image: "https://i.imgur.com/ZANVnHE.jpeg",
    ),
    Category(
      id: 3,
      name: "Furniture",
      slug: "furniture",
      image: "https://i.imgur.com/Qphac99.jpeg",
    ),
    Category(
      id: 4,
      name: "Shoes",
      slug: "shoes",
      image: "https://i.imgur.com/qNOjJje.jpeg",
    ),
    Category(
      id: 5,
      name: "Miscellaneous",
      slug: "miscellaneous",
      image: "https://i.imgur.com/BG8J0Fj.jpg",
    ),
  ];

  // Mock Data for Promo Ads Banners
  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'Super Summer Sale',
      'subtitle': 'Up to 50% OFF',
      'tag': 'Limited Time',
      'color': const Color(0xFF6C63FF),
    },
    {
      'title': 'New Electronics Arrivals',
      'subtitle': 'Free Shipping Included',
      'tag': 'New',
      'color': const Color(0xFF111111),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchAndFilter(),
            _buildSectionHeader('Special Offers', () {}),
            _buildPromoCarousel(),
            buildCategorySection(Categories),
            _buildSectionHeader('Trending Products', () {}),
            // _buildProductGrid(),
            const SizedBox(height: 24), // Bottom structural padding
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Expanded(
            child: BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state is AddressLoaded) {
                  if (state.addresses.isEmpty) {
                    return Text('');
                  }

                  final defaultAddress =
                      state.addresses.where((address) {
                        return address.isDefault == true;
                      }).toList();

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.delivery_dining,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'DELIVER TO',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.1,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Colors.grey.shade500,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${defaultAddress[0].fullName} ',
                                  ),
                                  TextSpan(
                                    text:
                                        '• ${defaultAddress[0].fullAddressLine}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink(); // Using shrink container over empty string widget
              },
            ),
          ),
        ],
      ),
      actions: [
        iconButton(Icons.favorite_border, () {
          Navigator.pushNamed(context, '/wishlist');
        }),
        CartIcon(),
        iconButton(Icons.person, () {
          Navigator.pushNamed(context, '/account');
        }),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductScreen(),
                    ),
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade600,
                  ),
                  hintText: 'Search products, brands...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAllTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextButton(
            onPressed: onSeeAllTap,
            child: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ).text('See All'),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _promoBanners.length,
        itemBuilder: (context, index) {
          final banner = _promoBanners[index];
          return Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: banner['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white.withOpacity(0.08),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          banner['tag'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        banner['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        banner['subtitle'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCategorySection(List<Category> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CHOOSE COLLECTION',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Our Collections',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 165, // Slightly increased height for enhanced layout spacing
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductsByCategoryPage(
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 115,
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 🌟 1. Base Premium Text Card with subtle gradient & shadow
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 28,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.grey.shade50],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  left: 10.0,
                                  right: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        category.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      size: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 🌟 2. Luxury Floating Circle Frame with Drop Shadow
                      Positioned(
                        top: 0,
                        left: 22,
                        right: 22,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.12),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(
                            3.5,
                          ), // Inner layout ring gap
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade100,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              category.image,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                            ),
                          ),
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
  //   Widget _buildProductGrid() {
  //     final List<ProductModel> products = [
  //       ProductModel(
  //         id: 21,
  //         title: 'Minimalist Leather Watch',
  //         category: 'Accessories',
  //         price: 189.00,
  //         description: 'Premium minimalist watch with genuine leather strap.',
  //         image:
  //             'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&q=80',
  //         rate: 4.5,
  //         count: 120,
  //       ),
  //       ProductModel(
  //         id: 22,
  //         title: 'Wireless Headphones',
  //         category: 'Electronics',
  //         price: 299.99,
  //         description: 'High-fidelity noise-cancelling wireless headphones.',
  //         image:
  //             'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&q=80',
  //         rate: 4.8,
  //         count: 85,
  //       ),
  //       ProductModel(
  //         id: 23,
  //         title: 'Premium Ceramic Coffee Mug',
  //         category: 'Kitchenware',
  //         price: 34.50,
  //         description: 'Handcrafted ceramic mug designed to keep beverages hot.',
  //         image:
  //             'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&q=80',
  //         rate: 4.2,
  //         count: 240,
  //       ),
  //       ProductModel(
  //         id: 24,
  //         title: 'Ergonomic Suede Office Chair',
  //         category: 'Furniture',
  //         price: 450.00,
  //         description: 'Suede adjustable office chair with lumbar support.',
  //         image:
  //             'https://images.unsplash.com/photo-1505797149-43b0069ec26b?w=500&q=80',
  //         rate: 4.7,
  //         count: 45,
  //       ),
  //     ];

  //     return GridView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       itemCount: products.length,
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: 0.61,
  //         crossAxisSpacing: 16,
  //         mainAxisSpacing: 16,
  //       ),
  //       itemBuilder: (context, index) {
  //         final ProductModel product = products[index];

  //         return GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ProductDetails(product: product),
  //               ),
  //             );
  //           },

  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(color: Colors.grey.shade100),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black.withOpacity(0.02),
  //                   blurRadius: 10,
  //                   offset: const Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   child: Stack(
  //                     children: [
  //                       Container(
  //                         width: double.infinity,
  //                         decoration: BoxDecoration(
  //                           color: Colors.grey.shade50,
  //                           borderRadius: const BorderRadius.vertical(
  //                             top: Radius.circular(20),
  //                           ),
  //                         ),
  //                         child: ClipRRect(
  //                           borderRadius: const BorderRadius.vertical(
  //                             top: Radius.circular(20),
  //                           ),
  //                           child: Image.network(
  //                             product.image,
  //                             fit: BoxFit.cover,
  //                             errorBuilder:
  //                                 (context, error, stackTrace) => const Center(
  //                                   child: Icon(
  //                                     Icons.broken_image_rounded,
  //                                     color: Colors.grey,
  //                                   ),
  //                                 ),
  //                           ),
  //                         ),
  //                       ),

  //                       Positioned(
  //                         top: 10,
  //                         right: 10,
  //                         child: CircleAvatar(
  //                           radius: 16,
  //                           backgroundColor: Colors.white.withOpacity(0.9),
  //                           child: BlocBuilder<WishlistCubit, WishlistState>(
  //                             builder: (context, state) {
  //                               bool isWishlisted = false;
  //                               if (state is WishlistLoaded) {
  //                                 isWishlisted = state.wishlistItems.any(
  //                                   (item) => item.id == product.id,
  //                                 );
  //                               }
  //                               return IconButton(
  //                                 onPressed: () {
  //                                   context.read<WishlistCubit>().toggleWishlist(
  //                                     product,
  //                                   );
  //                                 },
  //                                 icon: Icon(
  //                                   isWishlisted
  //                                       ? Icons.favorite
  //                                       : Icons.favorite_border,
  //                                   size: 20,
  //                                   color: Colors.redAccent,
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),

  //                 Padding(
  //                   padding: const EdgeInsets.all(12.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         product.category.toUpperCase(),
  //                         style: TextStyle(
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.grey.shade400,
  //                           letterSpacing: 0.7,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         product.title,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           color: Colors.black87,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8),

  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             '\$${product.price.toStringAsFixed(2)}',
  //                             style: const TextStyle(
  //                               fontSize: 15,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black,
  //                             ),
  //                           ),

  //                           Row(
  //                             children: [
  //                               Icon(
  //                                 Icons.star_rounded,
  //                                 color: Colors.amber.shade600,
  //                                 size: 16,
  //                               ),
  //                               const SizedBox(width: 2),
  //                               Text(
  //                                 product.rate.toString(),
  //                                 style: const TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 8),

  //                               GestureDetector(
  //                                 onTap: () {
  //                                   context.read<CartCubit>().onCartAdd(
  //                                     CartItem(product: product, qty: 1),
  //                                   );
  //                                   scaff_msg('Added to cart', context);
  //                                 },
  //                                 child: Container(
  //                                   padding: const EdgeInsets.all(6),
  //                                   decoration: const BoxDecoration(
  //                                     color: Colors.black,
  //                                     shape: BoxShape.circle,
  //                                   ),
  //                                   child: const Icon(
  //                                     Icons.add_rounded,
  //                                     color: Colors.white,
  //                                     size: 16,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
}

extension StringTextExtension on TextStyle {
  Widget text(String data) => Text(data, style: this);
}
