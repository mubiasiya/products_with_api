import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/presentation/screens/category_product_card.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_state.dart';

class ProductsByCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductsByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductsByCategoryPage> createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(
      FetchCatWiseProductsEvent(cateId: widget.categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 3),
            );
          }

          if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found in ${widget.categoryName}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.66,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return CategoryProductCard(product: product);
              },
            );
          }

          if (state is ProductError) {
            return Center(
              child: Text(
                'Something went wrong: ${state.message}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
