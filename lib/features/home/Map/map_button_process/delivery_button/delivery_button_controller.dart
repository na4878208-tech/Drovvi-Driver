import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../order_details_screen/order_detail_controller.dart';
import 'delivery_button_repo.dart';

final confirmDeliveryControllerProvider =
    StateNotifierProvider<ConfirmDeliveryController, AsyncValue<void>>((ref) {
  final repo = ref.watch(confirmDeliveryRepositoryProvider);
  return ConfirmDeliveryController(repo, ref);
});

class ConfirmDeliveryController extends StateNotifier<AsyncValue<void>> {
  final ConfirmDeliveryRepository repository;
  final Ref ref;

  ConfirmDeliveryController(this.repository, this.ref)
      : super(const AsyncValue.data(null));

  Future<void> confirmDelivery({
    required int orderId,
    required String otp,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await repository.confirmDelivery(orderId: orderId, otp: otp);

      if (kDebugMode) {
        print("✅ Delivery Confirmed");
      }
      if (kDebugMode) {
        print("📦 Order Number: ${res.orderNumber}");
      }
      if (kDebugMode) {
        print("💰 Earning: ${res.earning}");
      }
      if (kDebugMode) {
        print("🕒 Completed At: ${res.completedAt}");
      }
      if (kDebugMode) {
        print("🚗 Driver Status: ${res.driverStatus}");
      }

      // Refresh order details to update status
      // ignore: unused_result
      ref.refresh(orderDetailsControllerProvider(orderId));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
