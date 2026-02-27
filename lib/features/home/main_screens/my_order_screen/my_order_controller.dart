import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'my_order_modal.dart';
import 'my_order_repo.dart';

final myOrdersControllerProvider =
    StateNotifierProvider<MyOrdersController, AsyncValue<List<OrderModel>>>((
      ref,
    ) {
      final repo = ref.watch(orderRepositoryProvider);
      return MyOrdersController(repo);
    });

class MyOrdersController extends StateNotifier<AsyncValue<List<OrderModel>>> {
  final OrderRepository repository;

  MyOrdersController(this.repository) : super(const AsyncValue.loading()) {
    fetchMyOrders();
  }

  Future<void> fetchMyOrders() async {
    state = const AsyncValue.loading();
    try {
      final orders = await repository.getMyOrders();
      state = AsyncValue.data(orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
