part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItem item;
  AddToCartEvent(this.item);
}

class UpdateCartItemCountEvent extends CartEvent {
  final CartItem item;
  final int count;
  UpdateCartItemCountEvent(this.item, this.count);
}

class DeleteCartItemEvent extends CartEvent {
  final CartItem item;
  DeleteCartItemEvent(this.item);
}

class ClearCartEvent extends CartEvent {}