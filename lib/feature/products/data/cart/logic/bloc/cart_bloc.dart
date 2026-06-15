import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:with_api/feature/products/data/cart/hive/cart_service.dart';
import 'package:with_api/feature/products/data/cart/models/cart_item_model.dart';
import 'package:with_api/feature/products/data/cart/models/cart_model.dart';


part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial(cart: CartModel(items: []))) {
   
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemCountEvent>(_onUpdateCartItemCount);
    on<DeleteCartItemEvent>(_onDeleteCartItemEvent);
    on<ClearCartEvent>(_onClearCart);

   
    add(LoadCartEvent());
  }

  void _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) {
    final savedCart = HiveCartService.getCart();

    if (savedCart.items.isNotEmpty) {
      emit(CartUpdated(cart: savedCart));
    } else {
      emit(CartEmpty(cart: savedCart));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final List<CartItem> currentItems = List.from(state.cart.items);

    final int existingIndex = currentItems.indexWhere(
      (element) => element.product.id == event.item.product.id,
    );

    if (existingIndex >= 0) {
      currentItems[existingIndex] = CartItem(
        product: currentItems[existingIndex].product,
        qty: currentItems[existingIndex].qty + 1,
      );
    } else {
      currentItems.add(event.item);
    }

    final updatedCart = CartModel(items: currentItems);
    HiveCartService.saveCart(updatedCart);

    emit(CartUpdated(cart: updatedCart));
  }

  void _onUpdateCartItemCount(
    UpdateCartItemCountEvent event,
    Emitter<CartState> emit,
  ) {
    if (event.count == 0) return;

    final List<CartItem> currentItems = List.from(state.cart.items);

    final int index = currentItems.indexWhere(
      (element) => element.product.id == event.item.product.id,
    );

    if (index >= 0) {
      currentItems[index] = CartItem(
        product: event.item.product,
        qty: event.count,
      );

      final updatedCart = CartModel(items: currentItems);
      HiveCartService.saveCart(updatedCart);

      emit(CartUpdated(cart: updatedCart));
    }
  }

  void _onDeleteCartItemEvent(
    DeleteCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    final List<CartItem> currentItems = List.from(state.cart.items);
    currentItems.removeWhere(
      (element) => element.product.id == event.item.product.id,
    );

    if (currentItems.isEmpty) {
      HiveCartService.clearCart();
      emit(CartEmpty(cart: CartModel(items: [])));
      return;
    }

    final updatedCart = CartModel(items: currentItems);
    HiveCartService.saveCart(updatedCart);

    emit(CartUpdated(cart: updatedCart));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    HiveCartService.clearCart();
    emit(CartEmpty(cart: CartModel(items: [])));
  }
}
