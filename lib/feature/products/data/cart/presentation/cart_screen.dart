import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/cart/logic/cubit/cart_cubit.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';
import 'package:with_api/feature/products/data/cart/presentation/cart_bottom.dart';
import 'package:with_api/feature/products/data/presentation/widgets/icon_button.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        actions: [
          iconButton(Icons.favorite_border, () {
            Navigator.pushNamed(context, '/wishlist');
          }),
          iconButton(Icons.person, () {
            Navigator.pushNamed(context, '/account');
          }),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return Loading();
          }

          if (state is CartEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: state.cart.items.length,
                  itemBuilder: (context, index) {
                    final CartItem item = state.cart.items[index];
                    return _buildCartItemCard(context, item);
                  },
                ),
              ),

              _buildCheckoutSummary(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => cartProductDetails(product: item.product),
        //   ),
        // );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,

                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Image.network(
                      item.product.images.first,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: -21,
                    right: 55,
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        context.read<CartCubit>().onCartItemDelete(item);
                      },

                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        // Minus Button
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: const Icon(
                            Icons.remove,
                            size: 16,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            context.read<CartCubit>().onCartUpdateCount(
                              item,
                              item.qty - 1,
                            );
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${item.qty}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //add button
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            context.read<CartCubit>().onCartUpdateCount(
                              item,
                              item.qty + 1,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                cart_row(
                  'Sub Total',
                  '\$${state.cart.totalCartPrice.toStringAsFixed(2)}',
                ),
                cart_row('VAT', '\$${state.cart.vat.toStringAsFixed(2)}'),
                cart_row('Shipping', '\$5.00'),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),

                    const SizedBox(width: 5),
                    Text(
                      '\$${state.cart.grandTotal.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder:
                //         (context) => CheckoutScreen(
                //           cart: state.cart,
                //           subtotal: state.cart.totalCartPrice,
                //           vat: state.cart.vat,
                //           tot_Amount: state.cart.grandTotal,
                //         ),
                //   ),
                // );
              },
              child: const Text(
                'Proceed to buy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget cartProductDetails({required ProductModel product}) {}
}
