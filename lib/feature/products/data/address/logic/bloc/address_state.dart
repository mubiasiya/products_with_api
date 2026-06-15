part of 'address_bloc.dart';

sealed class AddressState {}

final class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  AddressLoaded(this.addresses);
}

class AddressError extends AddressState {
  final String errorMsg; // Standardized to camelCase

  AddressError({required this.errorMsg});
}
