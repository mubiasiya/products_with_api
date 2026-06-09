import 'package:flutter/material.dart';



Widget bottomAppBar(BuildContext context) {
  return BottomAppBar(
    color: Colors.white,
    elevation: 4,
    child: Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              // context.read<ProductCubit>().updateSortOrder(
              //   ProductSort.priceHighToLow,
              // );
            },
            icon: const Icon(
              Icons.arrow_downward,
              size: 16,
              color: Colors.black,
            ),
            label: const Text(
              'Price: High to Low',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),

        const SizedBox(
          height: 34,
          child: VerticalDivider(color: Colors.black, thickness: 1),
        ),

        Expanded(
          child: TextButton.icon(
            onPressed:(){},
                // () => context.read<ProductCubit>().updateSortOrder(
                //   ProductSort.priceLOwToHigh,
                // ),
            icon: const Icon(Icons.arrow_upward, size: 16, color: Colors.black),
            label: const Text(
              'Price: Low to High',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}
