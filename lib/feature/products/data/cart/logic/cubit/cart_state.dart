part of 'cart_cubit.dart';

@immutable
// ignore: must_be_immutable
sealed class CartState {
  final CartModel cart;

  CartState({required this.cart});
}

// ignore: must_be_immutable
final class CartInitial extends CartState {
  CartInitial({required super.cart});
}

final class CartUpdated extends CartState {
  CartUpdated({required super.cart});
}

final class CartEmpty extends CartState {
  CartEmpty({required super.cart});
}
