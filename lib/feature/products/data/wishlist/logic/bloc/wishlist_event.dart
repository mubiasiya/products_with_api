part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

class LoadWishlistEvent extends WishlistEvent {}

class ToggleWishlistEvent extends WishlistEvent {
  final ProductModel product;
  ToggleWishlistEvent(this.product);
}

class ClearWishlistEvent extends WishlistEvent {}
