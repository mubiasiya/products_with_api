part of 'address_cubit.dart';





sealed class AddressState {}

final class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  AddressLoaded(this.addresses);
}

class AddressError extends AddressState{
final String error_msg;

  AddressError({required this.error_msg});
}
