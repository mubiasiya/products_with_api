import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:with_api/feature/products/data/orders/logic/bloc/order_bloc.dart';
import 'package:with_api/feature/products/data/orders/models/order_model.dart';
import 'package:with_api/feature/products/data/presentation/widgets/back_button.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        leading: back_button(context),
        title: const Text('My Orders'),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          print("Current Order UI State: $state");
          if (state is OrderInitial) {
            return Loading();
          }

          if (state is RecentOrders) {
            final orders = state.items;

            if (orders.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            );
          }

          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 44,
                color: Color(0xFF86868B),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Once you place an order, your complete purchase history will show up right here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF86868B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final String formattedDate = DateFormat(
      'MMM dd, yyyy • hh:mm a',
    ).format(order.dateTime);

    
    final int itemLength = order.items.isEmpty ? 0 : order.items.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E8ED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.amber),
          child: ExpansionTile(
            backgroundColor: Colors.grey[100],
            collapsedBackgroundColor: Colors.white,
            tilePadding: const EdgeInsets.all(18),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderId,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                    _buildStatusChip(),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFF86868B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$itemLength ${itemLength == 1 ? "Item" : "Items"} purchased',
                    style: const TextStyle(
                      color: Color(0xFF6E6E73),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF1D1D1F),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              const Divider(
                color: Color(0xFFF5F5F7),
                height: 24,
                thickness: 1.5,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: Color(0xFF6E6E73),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Items Ordered',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF86868B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

             
              ...order.items.map((orderItem) {
                final product = orderItem.product; 
                final quantity = orderItem.qty;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8, left: 28),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey.shade300,
                          child: Image.network(
                            product.images.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6E6E73),
                                  ),
                                ),
                              
                                Text(
                                  'Qty: x$quantity',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D1D1F),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Divider(
                color: Color(0xFFF5F5F7),
                height: 24,
                thickness: 1.5,
              ),
              _buildDetailRow(
                icon: Icons.local_shipping_outlined,
                title: 'Shipping Address',
                content: order.deliveryAddress.fullAddressLine,
              ),
              const SizedBox(height: 14),
              _buildDetailRow(
                icon: Icons.payment_outlined,
                title: 'Payment Method',
                content: order.paymentMethod,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Text(
        'Success',
        style: TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6E6E73)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF86868B),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
