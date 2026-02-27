import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import 'button_process/multi_stop_button/stop_arrived/stop_action_model.dart';
import 'order_detail_modal.dart';
import 'order_detail_repo.dart';

final orderDetailsControllerProvider =
    StateNotifierProvider.family<
      OrderDetailsController,
      AsyncValue<OrderModel>,
      int
    >((ref, id) {
      final repo = ref.watch(orderRepositoryProvider);
      final controller = OrderDetailsController(repo);

      // Safe: schedule async fetch after widget mounted
      Future.microtask(() => controller.fetchOrderDetails(id));

      return controller;
    });

class OrderDetailsController extends StateNotifier<AsyncValue<OrderModel>> {
  final OrderRepository repository;
  bool _isMounted = true;

  OrderDetailsController(this.repository) : super(const AsyncValue.loading());

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> fetchOrderDetails(int id) async {
    state = const AsyncValue.loading();
    try {
      final result = await repository.fetchOrderDetails(id);

      if (!_isMounted) return;

      state = AsyncValue.data(result);
    } catch (e, st) {
      if (!_isMounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  /// 🔹 Refresh method to refetch the same order
  Future<void> refresh([int? id]) async {
    final orderId = id ?? (state.value?.id ?? 0);
    if (orderId == 0) return;

    await fetchOrderDetails(orderId);
  }
}
