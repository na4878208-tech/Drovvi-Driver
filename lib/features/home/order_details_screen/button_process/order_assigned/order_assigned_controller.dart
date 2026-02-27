import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../order_detail_repo.dart';
import 'order_assigned_model.dart';
final startOrderControllerProvider =
    StateNotifierProvider<StartOrderController, AsyncValue<StartOrderResponse>>(
  (ref) {
    final repo = ref.watch(orderRepositoryProvider);
    return StartOrderController(repo);
  },
);

class StartOrderController
    extends StateNotifier<AsyncValue<StartOrderResponse>> {
  final OrderRepository repository;

  StartOrderController(this.repository)
      : super(AsyncValue.data(
            StartOrderResponse(success: false, message: '', pickupOtp: '')));

   Future<StartOrderResponse> startOrder(int orderId) async {
    try {
      state = const AsyncValue.loading();
      final result = await repository.startOrder(orderId);
      state = AsyncValue.data(result);
      return result; // 🔥 THIS IS THE KEY
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
