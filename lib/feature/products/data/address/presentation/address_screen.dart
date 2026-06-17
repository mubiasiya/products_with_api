import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:with_api/feature/products/data/address/logic/bloc/address_bloc.dart';
import 'package:with_api/feature/products/data/address/models/address_model.dart';
import 'package:with_api/feature/products/data/presentation/widgets/back_button.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: back_button(context),
        title: const Text('My Addresses'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return Loading();
          }

          if (state is AddressLoaded) {
            final addresses = state.addresses;

            if (addresses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 70,
                      color: theme.colorScheme.primary.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No saved addresses found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(context, addresses[index], theme);
              },
            );
          }

          if (state is AddressError) {
            return Center(
              child: Text(
                state.errorMsg,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _showAddressFormBottomSheet(context),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Add New Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    AddressModel address,
    ThemeData theme,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (address.isDefault)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(color: primaryColor),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Icon, Name & Default Badge
                  Row(
                    children: [
                      Icon(
                        address.isDefault
                            ? Icons.home_rounded
                            : Icons.location_on_outlined,
                        color:
                            address.isDefault ? primaryColor : theme.hintColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Main Address Block
                  Text(
                    address.fullAddressLine,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.75),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Contact Label
                  Text(
                    'Phone: ${address.mobileNumber}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action Row
                  Row(
                    children: [
                      if (!address.isDefault)
                        TextButton.icon(
                          onPressed:
                              () => context.read<AddressBloc>().add(
                                SetDefaultAddressEvent(address.id),
                              ),
                          icon: const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 16,
                          ),
                          label: const Text('Set as Default'),
                          style: TextButton.styleFrom(
                            foregroundColor: primaryColor,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      const Spacer(),

                      // Simple interactive icons without cluttered boxes
                      IconButton(
                        onPressed:
                            () => _showAddressFormBottomSheet(
                              context,
                              address: address,
                            ),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: theme.hintColor,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed:
                            () => _confirmDeleteDialog(context, address.id),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                        ),
                        color: theme.colorScheme.error.withOpacity(0.8),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressFormBottomSheet(
    BuildContext context, {
    AddressModel? address,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormWidget(addressToEdit: address),
    );
  }

  void _confirmDeleteDialog(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Remove Address?'),
            content: const Text(
              'Are you sure you want to permanently delete this delivery location?',
            ),
            actions: [
              TextButton(
                onPressed: () =>context.pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AddressBloc>().add(
                    DeleteAddressEvent(addressId),
                  );
                context.pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }
}

class _AddressFormWidget extends StatefulWidget {
  final AddressModel? addressToEdit;
  const _AddressFormWidget({this.addressToEdit});

  @override
  State<_AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<_AddressFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _emirateController;
  late TextEditingController _areaController;
  late TextEditingController _buildingController;
  late TextEditingController _flatController;
  late TextEditingController _landmarkController;

  @override
  void initState() {
    super.initState();
    final editTarget = widget.addressToEdit;
    _nameController = TextEditingController(text: editTarget?.fullName ?? '');
    _mobileController = TextEditingController(
      text: editTarget?.mobileNumber ?? '',
    );
    _emirateController = TextEditingController(text: editTarget?.emirate ?? '');
    _areaController = TextEditingController(text: editTarget?.area ?? '');
    _buildingController = TextEditingController(
      text: editTarget?.buildingName ?? '',
    );
    _flatController = TextEditingController(text: editTarget?.flatNumber ?? '');
    _landmarkController = TextEditingController(
      text: editTarget?.landmark ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emirateController.dispose();
    _areaController.dispose();
    _buildingController.dispose();
    _flatController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<AddressBloc>();

      if (widget.addressToEdit == null) {
        final newAddress = AddressModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),

          fullName: _nameController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          emirate: _emirateController.text.trim(),
          area: _areaController.text.trim(),
          buildingName: _buildingController.text.trim(),
          flatNumber: _flatController.text.trim(),
          landmark:
              _landmarkController.text.trim().isEmpty
                  ? null
                  : _landmarkController.text.trim(),
          isDefault:
              false, // First item handling can be added in the Cubit level
        );

        bloc.add(AddAddressEvent(newAddress));
      } else {
        final updatedAddress = widget.addressToEdit!.copyWith(
          fullName: _nameController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          emirate: _emirateController.text.trim(),
          area: _areaController.text.trim(),
          buildingName: _buildingController.text.trim(),
          flatNumber: _flatController.text.trim(),
          landmark:
              _landmarkController.text.trim().isEmpty
                  ? null
                  : _landmarkController.text.trim(),
        );

        bloc.add(UpdateAddressEvent(updatedAddress));
      }

      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.addressToEdit == null
                    ? 'Add Delivery Address'
                    : 'Edit Address Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name*',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Please enter full name'
                            : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number*',
                  prefixIcon: Icon(Icons.phone_android_rounded),
                ),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Please enter mobile number'
                            : null,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emirateController,
                      decoration: const InputDecoration(
                        labelText: 'Emirate*',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      validator:
                          (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextFormField(
                      controller: _areaController,
                      decoration: const InputDecoration(
                        labelText: 'Area*',
                        prefixIcon: Icon(Icons.location_city_rounded),
                      ),
                      validator:
                          (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _buildingController,
                decoration: const InputDecoration(
                  labelText: 'Building Name / House Name*',
                  prefixIcon: Icon(Icons.domain_rounded),
                ),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Please enter building name'
                            : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _flatController,
                decoration: const InputDecoration(
                  labelText: 'Flat / Villa / Room No.*',
                  prefixIcon: Icon(Icons.room_preferences_rounded),
                ),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Please enter flat/room number'
                            : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _landmarkController,
                decoration: const InputDecoration(
                  labelText: 'Landmark (Optional)',
                  prefixIcon: Icon(Icons.assistant_navigation),
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  widget.addressToEdit == null
                      ? 'Save Address'
                      : 'Update Address',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
