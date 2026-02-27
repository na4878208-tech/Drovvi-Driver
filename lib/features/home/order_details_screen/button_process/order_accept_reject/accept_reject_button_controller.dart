import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../order_detail_controller.dart';
import '../../order_detail_repo.dart';

final orderActionControllerProvider =
    StateNotifierProvider<OrderActionController, AsyncValue<void>>((ref) {
      final repo = ref.watch(orderRepositoryProvider);
      return OrderActionController(repo, ref);
    });

class OrderActionController extends StateNotifier<AsyncValue<void>> {
  final OrderRepository repository;
  final Ref ref;

  OrderActionController(this.repository, this.ref)
    : super(const AsyncValue.data(null));

  /// ACCEPT
  Future<String> acceptOrder(int orderId) async {
    state = const AsyncValue.loading();
    try {
      final order = await repository.acceptOrder(orderId);

      // refresh order details
      final _ = ref.refresh(orderDetailsControllerProvider(orderId));

      // ✅ Server ka success message
      return "Order accepted: ${order.orderNumber}";
    } catch (e, st) {
      state = AsyncValue.error(e, st);

      // ❌ Server ka error message
      return e.toString().replaceAll('Exception: ', '');
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  /// REJECT
  Future<void> rejectOrder(int orderId) async {
    state = const AsyncValue.loading();
    try {
      await repository.rejectOrder(orderId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
