import 'package:flutter/material.dart';
import 'package:with_api/feature/products/data/presentation/screens/search_product_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/cart_icon.dart';
import 'package:with_api/feature/products/data/presentation/widgets/icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded, 'apiValue': ''},

    {
      'name': 'Electronics',
      'icon': Icons.devices_rounded,
      'apiValue': 'electronics',
    },

    {'name': 'Jewelry', 'icon': Icons.diamond_rounded, 'apiValue': 'jewelery'},

    {
      'name': 'Men\'s Wear',
      'icon': Icons.man_rounded,
      'apiValue': "men's clothing",
    },

    {
      'name': 'Women\'s Wear',
      'icon': Icons.woman_rounded,
      'apiValue': 'women\'s clothing',
    },

    {
      'name': 'Shoes & Kicks',
      'icon': Icons.ice_skating_rounded,
      'apiValue': 'shoes',
    },

    {
      'name': 'Beauty & Care',
      'icon': Icons.face_retouching_natural_rounded,
      'apiValue': 'beauty',
    },

    {
      'name': 'Groceries',
      'icon': Icons.local_grocery_store_rounded,
      'apiValue': 'groceries',
    },
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
            _buildSectionHeader('Categories', () {}),
            _buildCategoryList(),
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
          const Icon(Icons.location_on_rounded, color: Colors.black, size: 22),
          const SizedBox(width: 6),

          // Expanded(
          //   child:

          //    BlocBuilder<AddressCubit, AddressState>(
          //     builder: (context, state) {
          //       if (state is AddressLoaded) {
          //         if (state.addresses.isEmpty) {
          //           return Text('');
          //         }

          //         final primaryAddress = state.addresses.first;

          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Text(
          //               'Deliver to',
          //               style: TextStyle(
          //                 fontSize: 11,
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //             Text(
          //               ' ${primaryAddress.title} , ${primaryAddress.fullAddress}',
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(
          //                 fontSize: 13,
          //                 color: Colors.grey.shade500,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         );
          //       }
          //       return const SizedBox.shrink(); // Using shrink container over empty string widget
          //     },
          //   ),
          // ),
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

  Widget _buildCategoryList() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => cate_wise(cat: category['apiValue']),
              //   ),
              // );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                children: [
                  Icon(category['icon'], color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
