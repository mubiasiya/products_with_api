part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class RecentOrders extends OrderState {
  final List<OrderModel> items;
  RecentOrders({required this.items});
}
