import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_state.dart';


Widget Searchbar(TextEditingController search) {
  return BlocConsumer<ProductBloc, ProductState>(
    listenWhen: (previous, current) {
     
      if (previous is ProductLoaded && current is ProductLoaded) {
        return previous.activeSearchQuery != current.activeSearchQuery;
      }
      return false;
    },
    listener: (context, state) {
      if (state is ProductLoaded && state.activeSearchQuery.isEmpty) {
        search.clear();
      }
    },
    builder: (context, state) {
      
      bool showClearButton = false;
      if (state is ProductLoaded) {
        showClearButton = state.activeSearchQuery.isNotEmpty;
      }

      return Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: search,
          onChanged: (value) {
          
            context.read<ProductBloc>().add(
              FilterProductsEvent(searchQuery: value),
            );
          },
          decoration: InputDecoration(
            hintText: 'Search products',
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            suffixIcon:
                showClearButton
                    ? IconButton(
                      onPressed: () {
                        search.clear();
                        context.read<ProductBloc>().add(
                          FilterProductsEvent(searchQuery: ''),
                        );
                      },
                      icon: const Icon(Icons.clear, color: Colors.black),
                    )
                    : null,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    },
  );
}
