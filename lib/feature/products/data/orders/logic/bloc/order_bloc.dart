import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart'; // All imports go here!
import 'package:with_api/feature/products/data/orders/hive/order_service.dart';
import 'package:with_api/feature/products/data/orders/models/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<SaveOrderEvent>(_onSaveOrder);
  }

  FutureOr<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderInitial());

    try {
      
      final recentOrders = HiveOrderService.getOrders();

      emit(RecentOrders(items: recentOrders));
    } catch (e) {
      debugPrint("Hive Order Fetch Error: $e");

      emit(RecentOrders(items: const []));
    }
  }

  FutureOr<void> _onSaveOrder(SaveOrderEvent event, Emitter<OrderState> emit) {
    HiveOrderService.saveOrder(event.order);
    final recentOrders = HiveOrderService.getOrders();
    emit(RecentOrders(items: recentOrders));
  }
  
}
