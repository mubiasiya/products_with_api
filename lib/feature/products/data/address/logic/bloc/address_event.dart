part of 'address_bloc.dart';

sealed class AddressEvent {}

class LoadAddressesEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final AddressModel newAddress;
  AddAddressEvent(this.newAddress);
}

class UpdateAddressEvent extends AddressEvent {
  final AddressModel updatedAddress;
  UpdateAddressEvent(this.updatedAddress);
}

class SetDefaultAddressEvent extends AddressEvent {
  final String id;
  SetDefaultAddressEvent(this.id);
}

class DeleteAddressEvent extends AddressEvent {
  final String id;
  DeleteAddressEvent(this.id);
}
