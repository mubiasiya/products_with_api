import 'package:bloc/bloc.dart';
import 'package:with_api/feature/products/data/address/hive/address_hive.dart';
import 'package:with_api/feature/products/data/address/models/address_model.dart';
import 'package:with_api/feature/products/data/auth/services/shared_pref/auth_shared.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    emit(AddressLoading());
    try {
      final String userId = await PreferenceService.getUserId();

      await HiveAddressService.openUserBox(userId);

      final List<AddressModel> items = HiveAddressService.getAddress();
      emit(AddressLoaded(items));
    } catch (e) {
      emit(
        AddressError(error_msg: "Failed to load addresses: ${e.toString()}"),
      );
    }
  }

  Future<void> addAddress(AddressModel newAddress) async {
    if (state is! AddressLoaded) return;
    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final bool shouldBeDefault = currentItems.isEmpty;
    final processedAddress = newAddress.copyWith(isDefault: shouldBeDefault);

    currentItems.add(processedAddress);

    emit(AddressLoaded(currentItems));
    await HiveAddressService.saveAddress(currentItems);
  }

  Future<void> updateAddress(AddressModel updatedAddress) async {
    if (state is! AddressLoaded) return;
    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final index = currentItems.indexWhere(
      (element) => element.id == updatedAddress.id,
    );
    if (index >= 0) {
      currentItems[index] = updatedAddress;
      emit(AddressLoaded(currentItems));
      await HiveAddressService.saveAddress(currentItems);
    }
  }

  Future<void> setDefaultAddress(String id) async {
    if (state is! AddressLoaded) return;
    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final updatedItems =
        currentItems.map((address) {
          if (address.id == id) {
            return address.copyWith(isDefault: true);
          } else {
            return address.copyWith(isDefault: false);
          }
        }).toList();

    emit(AddressLoaded(updatedItems));
    await HiveAddressService.saveAddress(updatedItems);
  }

  Future<void> deleteAddress(String id) async {
    if (state is! AddressLoaded) return;
    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final bool wasDefault = currentItems.any(
      (element) => element.id == id && element.isDefault,
    );

    currentItems.removeWhere((element) => element.id == id);

    if (wasDefault && currentItems.isNotEmpty) {
      currentItems[0] = currentItems[0].copyWith(isDefault: true);
    }

    emit(AddressLoaded(currentItems));
    await HiveAddressService.saveAddress(currentItems);
  }
}
