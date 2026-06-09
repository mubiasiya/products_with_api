import 'package:flutter/material.dart';

// import 'package:product_list/feature/logic/cubit/cart_cubit.dart'; // 💡 Replace with your exact package path

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<CartCubit, CartState>(
    //   builder: (context, state) {
        int totalItems = 0;
    //     if (state is CartUpdated) {
    //       totalItems = state.cart.items.fold(0, (sum, item) => sum + item.qty);
    //     }

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 28,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),

            if (totalItems > 0)
              Positioned(
                right: 6,
                top: 1,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$totalItems',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
//       },
//     );
  }
}
