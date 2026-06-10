part of 'wishlist_cubit.dart';

@immutable
sealed class WishlistState {}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<ProductModel> wishlistItems;

  WishlistLoaded({required this.wishlistItems});
}

final class wishlistError extends WishlistState {
  final String errormsg;

  wishlistError({required this.errormsg});
}
