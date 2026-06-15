import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:with_api/feature/products/data/products/models/product_model.dart';
import 'package:with_api/feature/products/data/wishlist/hive/wishlist_hive.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistInitial()) {
   
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
    on<ClearWishlistEvent>(_onClearWishlist);

    add(LoadWishlistEvent());
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      final List<ProductModel> items = HiveWishlistService.getWishlist();
      emit(WishlistLoaded(wishlistItems: items));
    } catch (e) {
      emit(WishlistError(errorMsg: e.toString()));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    if (state is! WishlistLoaded) return;

    final currentItems = List<ProductModel>.from(
      (state as WishlistLoaded).wishlistItems,
    );

    final int itemIndex = currentItems.indexWhere(
      (element) => element.id == event.product.id,
    );

    final bool isCurrentlyFavorite = itemIndex >= 0;

    if (isCurrentlyFavorite) {
      currentItems.removeAt(itemIndex);
    } else {
      currentItems.add(event.product);
    }

    
    emit(WishlistLoaded(wishlistItems: currentItems));

    
    try {
      if (isCurrentlyFavorite) {
        await HiveWishlistService.removeFromWishlist(event.product.id);
      } else {
        await HiveWishlistService.addToWishlist(event.product);
      }
    } catch (e) {
     //
    }
  }

  void _onClearWishlist(ClearWishlistEvent event, Emitter<WishlistState> emit) {
    emit(WishlistInitial());
  }
}
