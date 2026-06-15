import 'package:bloc/bloc.dart';
import 'package:with_api/feature/products/data/address/hive/address_hive.dart';
import 'package:with_api/feature/products/data/address/models/address_model.dart';
import 'package:with_api/feature/products/data/auth/services/shared_pref/auth_shared.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
   
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);

    add(LoadAddressesEvent());
  }

  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final String userId = await PreferenceService.getUserId();
      await HiveAddressService.openUserBox(userId);

      final List<AddressModel> items = HiveAddressService.getAddress();
      emit(AddressLoaded(items));
    } catch (e) {
      emit(AddressError(errorMsg: "Failed to load addresses: ${e.toString()}"));
    }
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final bool shouldBeDefault = currentItems.isEmpty;
    final processedAddress = event.newAddress.copyWith(
      isDefault: shouldBeDefault,
    );

    currentItems.add(processedAddress);

    emit(AddressLoaded(currentItems));
    await HiveAddressService.saveAddress(currentItems);
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final index = currentItems.indexWhere(
      (element) => element.id == event.updatedAddress.id,
    );

    if (index >= 0) {
      currentItems[index] = event.updatedAddress;
      emit(AddressLoaded(currentItems));
      await HiveAddressService.saveAddress(currentItems);
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final updatedItems =
        currentItems.map((address) {
          if (address.id == event.id) {
            return address.copyWith(isDefault: true);
          } else {
            return address.copyWith(isDefault: false);
          }
        }).toList();

    emit(AddressLoaded(updatedItems));
    await HiveAddressService.saveAddress(updatedItems);
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    final currentItems = List<AddressModel>.from(
      (state as AddressLoaded).addresses,
    );

    final bool wasDefault = currentItems.any(
      (element) => element.id == event.id && element.isDefault,
    );

    currentItems.removeWhere((element) => element.id == event.id);

    if (wasDefault && currentItems.isNotEmpty) {
      currentItems[0] = currentItems[0].copyWith(isDefault: true);
    }

    emit(AddressLoaded(currentItems));
    await HiveAddressService.saveAddress(currentItems);
  }
}
