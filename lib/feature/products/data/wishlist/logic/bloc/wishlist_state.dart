part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistState {}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<ProductModel> wishlistItems;

  WishlistLoaded({required this.wishlistItems});
}

final class WishlistError extends WishlistState {
  
  final String errorMsg; 

  WishlistError({required this.errorMsg});
}
