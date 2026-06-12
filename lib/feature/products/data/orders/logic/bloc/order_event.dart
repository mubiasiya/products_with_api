part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class LoadOrdersEvent extends OrderEvent {}

class SaveOrderEvent extends OrderEvent {
  final OrderModel order;
  SaveOrderEvent(this.order);
}
