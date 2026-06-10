import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/wishlist/hive/wishlist_hive.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial()) {
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    emit(WishlistLoading());
    try {
      final List<ProductModel> items = HiveWishlistService.getWishlist();
      emit(WishlistLoaded(wishlistItems: items));
    } catch (e) {
      emit(wishlistError(errormsg: e.toString()));
    }
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (state is! WishlistLoaded) return;

    final currentItems = List<ProductModel>.from(
      (state as WishlistLoaded).wishlistItems,
    );

    final int itemIndex = currentItems.indexWhere(
      (element) => element.id == product.id,
    );

    bool isCurrentlyFavorite = itemIndex >= 0;

   
    if (isCurrentlyFavorite) {
      currentItems.removeAt(itemIndex);
    } else {
      currentItems.add(product);
    }
    emit(WishlistLoaded(wishlistItems: currentItems));

    
    try {
      if (isCurrentlyFavorite) {
        await HiveWishlistService.removeFromWishlist(product.id);
      } else {
        await HiveWishlistService.addToWishlist(product);
      }
    } catch (e) {
    //
    }
  }

  void clearWishlistState() {
    emit(WishlistInitial());
  }
}
