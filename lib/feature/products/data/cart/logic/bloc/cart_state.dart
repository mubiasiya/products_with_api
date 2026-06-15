part of 'cart_bloc.dart';

@immutable
sealed class CartState {
  final CartModel cart;
  CartState({required this.cart});
}

final class CartInitial extends CartState {
  CartInitial({required super.cart});
}

final class CartUpdated extends CartState {
  CartUpdated({required super.cart});
}

final class CartEmpty extends CartState {
  CartEmpty({required super.cart});
}
