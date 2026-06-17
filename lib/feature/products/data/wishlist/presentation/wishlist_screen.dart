import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:with_api/feature/products/data/presentation/widgets/cart_icon.dart';
import 'package:with_api/feature/products/data/presentation/widgets/icon_button.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';
import 'package:with_api/feature/products/data/wishlist/logic/bloc/wishlist_bloc.dart';
import 'package:with_api/feature/products/data/wishlist/presentation/wishlist_card.dart';


class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        actions: [
          CartIcon(),
          iconButton(Icons.person, () {
           
            context.push('/account');
          }),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return Loading();
          }

          if (state is WishlistError) {
            return Center(child: Text(state.errorMsg));
          }

          if (state is WishlistLoaded) {
            final wishlistItems = state.wishlistItems;

            if (wishlistItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your wishlist is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on products to add them here.',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return buildWishlistCard(context, product);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
