import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:with_api/feature/products/data/cart/hive/cart_service.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';
import 'package:with_api/feature/products/data/cart/models/cart_model.dart';


part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartEmpty(cart: CartModel(items: []))) {
    loadInitialCart();
  }

  void loadInitialCart() {
    final savedCart = HiveCartService.getCart();

    if (savedCart.items.isNotEmpty) {
      emit(CartUpdated(cart: savedCart));
    } else {
      emit(CartEmpty(cart: savedCart));
    }
  }

  void onCartAdd(CartItem item) {
    final List<CartItem> currentItems = List.from(state.cart.items);

    final int existingIndex = currentItems.indexWhere(
      (element) => element.product.id == item.product.id,
    );

    if (existingIndex >= 0) {
      currentItems[existingIndex] = CartItem(
        product: currentItems[existingIndex].product,
        qty: currentItems[existingIndex].qty + 1,
      );
    } else {
      currentItems.add(item);
    }

    final updatedCart = CartModel(items: currentItems);
    HiveCartService.saveCart(updatedCart);

    emit(CartUpdated(cart: CartModel(items: currentItems)));
  }

  void onCartUpdateCount(CartItem item, int count) {
    if (count == 0) {
      return;
    }

    final List<CartItem> currentItems = List.from(state.cart.items);

    final int Index = currentItems.indexWhere(
      (element) => element.product.id == item.product.id,
    );

    currentItems[Index] = CartItem(product: item.product, qty: count);

    final updatedCart = CartModel(items: currentItems);
    HiveCartService.saveCart(updatedCart);

    emit(CartUpdated(cart: CartModel(items: currentItems)));
  }

  void onCartItemDelete(CartItem item) {
    final List<CartItem> currentItems = List.from(state.cart.items);
    currentItems.removeWhere(
      (element) => element.product.id == item.product.id,
    );

    if (currentItems.isEmpty) {
      HiveCartService.clearCart();
      emit(CartEmpty(cart: CartModel(items: [])));
      return;
    }

    final updatedCart = CartModel(items: currentItems);
    HiveCartService.saveCart(updatedCart);

    emit(CartUpdated(cart: CartModel(items: currentItems)));
  }

  void onCartClear() {
    HiveCartService.clearCart();

    emit(CartEmpty(cart: CartModel(items: [])));
  }
}
