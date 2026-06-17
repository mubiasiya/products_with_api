import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:with_api/feature/products/data/presentation/screens/productDetail_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/bottom_appBar.dart';
import 'package:with_api/feature/products/data/presentation/widgets/cart_icon.dart';
import 'package:with_api/feature/products/data/presentation/widgets/error_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/icon_button.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/product_card.dart';
import 'package:with_api/feature/products/data/presentation/widgets/search_bar.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_bloc.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_event.dart';
import 'package:with_api/feature/products/data/products/logic/bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController search = TextEditingController();

  double _currentMinPrice = 0;
  double _currentMaxPrice = 1000;

  void _showFilterBottomSheet(
    BuildContext context,
    ProductLoaded currentLoadedState,
  ) {
    double minPrice = (currentLoadedState.activeMinPrice ?? 0).toDouble();
    double maxPrice = (currentLoadedState.activeMaxPrice ?? 1000).toDouble();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by Price Range',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${minPrice.round()}'),
                      Text('\$${maxPrice.round()}'),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 0.0,
                    max: 1000.0,
                    divisions: 100,
                    activeColor: Colors.black,
                    inactiveColor: Colors.grey.shade300,
                    labels: RangeLabels(
                      '\$${minPrice.round()}',
                      '\$${maxPrice.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setSheetState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentMinPrice = minPrice;
                          _currentMaxPrice = maxPrice;
                        });

                        context.read<ProductBloc>().add(
                          FilterProductsEvent(
                            searchQuery: search.text,
                            minPrice: minPrice.round(),
                            maxPrice: maxPrice.round(),
                          ),
                        );
                        Navigator.pop(sheetContext);
                      },
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    context.read<ProductBloc>().add(
      FilterProductsEvent(
        searchQuery: search.text,
        minPrice: _currentMinPrice.round(),
        maxPrice: _currentMaxPrice.round(),
      ),
    );
    
    super.initState();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: iconButton(Icons.arrow_back_ios, () {
          context.pop();
        }),
        actions: [
          iconButton(Icons.favorite_border, () {
            context.push('/wishlist');
          }),
          CartIcon(),
          iconButton(Icons.person, () {
             context.push('/account');
          }),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.white,
        onRefresh: () async {
          context.read<ProductBloc>().add(
            FilterProductsEvent(
              searchQuery: search.text,
              minPrice: _currentMinPrice.round(),
              maxPrice: _currentMaxPrice.round(),
            ),
          );
        },
        child: Column(
          children: [
            Searchbar(search),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded &&
                    state.products.isNotEmpty &&
                    search.text.isNotEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Price Range:',
                        style: TextStyle(color: Colors.black),
                      ),
                      IconButton(
                        icon: Icon(Icons.tune, color: Colors.black),
                        onPressed: () {
                          _showFilterBottomSheet(context, state);
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductInitial) {
                    return const Center(
                      child: Text(
                        'Type something in the search bar to find products.',
                      ),
                    );
                  }

                  if (state is ProductLoading) {
                    return Loading();
                  }

                  if (state is ProductError) {
                    return error_Screen(state.message);
                  }

                  if (state is ProductLoaded) {
                    final loadedState = state;
                    final productList = loadedState.products;

                    if (loadedState.activeSearchQuery.isEmpty) {
                      return const Center(
                        child: Text(
                          'Type something in the search bar to find products.',
                        ),
                      );
                    }

                    if (productList.isEmpty) {
                      return const Center(
                        child: Text('No products match your filters.'),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: productList.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisExtent: 320,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        return productCard(product, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductDetails(product: product),
                            ),
                          );
                        }, context);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded &&
              state.products.isNotEmpty &&
              search.text.isNotEmpty) {
            return bottomAppBar(
              context: context,
              currentSearch: search.text,
              minPrice: state.activeMinPrice,
              maxPrice: state.activeMaxPrice,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
