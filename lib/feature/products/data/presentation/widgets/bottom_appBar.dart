import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';

Widget bottomAppBar({
  required BuildContext context,
  required String currentSearch,
  required int? minPrice,
  required int? maxPrice,
}) {
  return BottomAppBar(
    color: Colors.white,
    elevation: 4,
    child: Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(
                FilterProductsEvent(
                  searchQuery: currentSearch,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  sortOrder: ProductSortOrder.highToLow,
                ),
              );
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
            onPressed: () {
              context.read<ProductBloc>().add(
                FilterProductsEvent(
                  searchQuery: currentSearch,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  sortOrder: ProductSortOrder.lowToHigh,
                ),
              );
            },
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
