import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/address/logic/cubit/address_cubit.dart';
import 'package:with_api/feature/products/data/address/models/address_model.dart';
import 'package:with_api/feature/products/data/cart/logic/cubit/cart_cubit.dart';
import 'package:with_api/feature/products/data/cart/models/cart_model.dart';
import 'package:with_api/feature/products/data/orders/logic/bloc/order_bloc.dart';
import 'package:with_api/feature/products/data/orders/models/order_model.dart';
import 'package:with_api/feature/products/data/presentation/screens/success_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/back_button.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final CartModel cart;
  final double subtotal;
  final double vat;
  final double tot_Amount;
  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.vat,
    required this.tot_Amount,
    required this.cart,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddressIndex = 0;
  int _selectedPaymentIndex = 0;
  bool _hasSetInitialAddress = false; // Prevents reset loops during UI rebuilds

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Credit / Debit Card',
      'icon': Icons.credit_card_rounded,
      'subtitle': 'Visa, Mastercard, Amex',
    },
    {
      'name': 'Google Pay / Apple Pay',
      'icon': Icons.account_balance_wallet_rounded,
      'subtitle': 'Instant & Secure',
    },
    {
      'name': 'Cash on Delivery',
      'icon': Icons.local_shipping_rounded,
      'subtitle': 'Pay when package arrives',
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: back_button(context),
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Deliver To',
              buttonText: '+ Add New',
              onTap: () {
                Navigator.pushNamed(context, '/address');
              },
            ),

            BlocConsumer<AddressCubit, AddressState>(
              listener: (context, state) {
                if (state is AddressLoaded &&
                    !_hasSetInitialAddress &&
                    state.addresses.isNotEmpty) {
                  final defaultIdx = state.addresses.indexWhere(
                    (addr) => addr.isDefault,
                  );
                  setState(() {
                    _selectedAddressIndex = defaultIdx != -1 ? defaultIdx : 0;
                    _hasSetInitialAddress = true;
                  });
                }
              },
              builder: (context, state) {
                if (state is AddressLoading) {
                  return Loading();
                }

                if (state is AddressLoaded) {
                  if (state.addresses.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Please add an address to proceed.',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return _buildAddressList(state.addresses);
                }

                return const SizedBox(
                  height: 140,
                  child: Center(child: Text('Failed to load addresses.')),
                );
              },
            ),

            const SizedBox(height: 12),

            _buildSectionHeader('Payment Method'),
            _buildPaymentList(),

            const SizedBox(height: 12),

            _buildSectionHeader('Order Summary'),
            _buildOrderSummaryCard(),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomPayButton(),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    String? buttonText,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (buttonText != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressList(List<AddressModel> savedAddresses) {
    return SizedBox(
      height: 145,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection:
            Axis.horizontal, // Changed to horizontal layout to support cards side-by-side
        physics: const BouncingScrollPhysics(),
        itemCount: savedAddresses.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedAddressIndex == index;
          final addr = savedAddresses[index];

          return GestureDetector(
            onTap: () => setState(() => _selectedAddressIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width * 0.78,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons
                        .location_on_rounded, // Standard clean location icon mapping
                    color: isSelected ? Colors.black : Colors.grey.shade400,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                addr.fullName, // Model translation update
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (addr.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'DEFAULT',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            addr.fullAddressLine, // Model translation update
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          addr.mobileNumber, // Model translation update
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_off_rounded,
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedPaymentIndex == index;
        final payment = _paymentMethods[index];
        return GestureDetector(
          onTap: () => setState(() => _selectedPaymentIndex = index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey.shade100,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(payment['icon'], color: Colors.black87),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment['subtitle'],
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<int>(
                  value: index,
                  groupValue: _selectedPaymentIndex,
                  activeColor: Colors.black,
                  onChanged: (value) {
                    setState(() => _selectedPaymentIndex = value!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            '\$ ${widget.subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'VAT (5%)',
            ' \$ ${widget.vat.toStringAsFixed(2)}',
            isDiscount:
                false, 
          ),
          _buildSummaryRow('Shipping Fee', '\$ 5.00'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1),
          ),
          _buildSummaryRow(
            'Total Amount',
            '\$ ${widget.tot_Amount.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 13,
              fontWeight: FontWeight.bold,
              color:
                  isDiscount
                      ? Colors.green
                      : (isTotal ? Colors.black : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPayButton() {
    final addressState = context.watch<AddressCubit>().state;

    bool hasValidAddress = false;
    List<AddressModel> currentAddresses = [];

    if (addressState is AddressLoaded) {
      currentAddresses = addressState.addresses;
      if (currentAddresses.isNotEmpty) {
        hasValidAddress =
            _selectedAddressIndex >= 0 &&
            _selectedAddressIndex < currentAddresses.length;
      }
    }

    final bool hasValidPayment =
        _selectedPaymentIndex >= 0 &&
        _selectedPaymentIndex < _paymentMethods.length;

    final bool isButtonEnabled = hasValidAddress && hasValidPayment;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Text(
                '\$${widget.tot_Amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  isButtonEnabled
                      ? () async {
                        final addressState = context.read<AddressCubit>().state;
                        if (addressState is! AddressLoaded ||
                            addressState.addresses.isEmpty) {
                          return;
                        }

                        final String finalizedOrderId =
                            '#FS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

                        final chosenAddress =
                            addressState.addresses[_selectedAddressIndex];

                        final purchasedProducts = widget.cart.items;

                        final newOrder = OrderModel(
                          orderId: finalizedOrderId,
                          dateTime: DateTime.now(),
                          items: purchasedProducts,
                          totalAmount: widget.tot_Amount,
                          paymentMethod:
                              _paymentMethods[_selectedPaymentIndex]['name'],
                          deliveryAddress: chosenAddress,
                        );
                         
                         context.read<OrderBloc>().add(SaveOrderEvent(newOrder));
                        context.read<CartCubit>().onCartClear();
                        

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PaymentSuccessScreen(
                                  amount: widget.tot_Amount,
                                  pay_method:
                                      _paymentMethods[_selectedPaymentIndex]['name'],
                                  orderId: finalizedOrderId,
                                ),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
