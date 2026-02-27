import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'pick_up_button.repo.dart';
import '../../../order_details_screen/order_detail_controller.dart';

final confirmPickupControllerProvider =
    StateNotifierProvider<ConfirmPickupController, AsyncValue<void>>((ref) {
  final repo = ref.watch(confirmPickupRepositoryProvider);
  return ConfirmPickupController(repo, ref);
});

class ConfirmPickupController extends StateNotifier<AsyncValue<void>> {
  final ConfirmPickupRepository repository;
  final Ref ref;

  ConfirmPickupController(this.repository, this.ref)
      : super(const AsyncValue.data(null));

  Future<void> confirmPickup({
    required int orderId,
    required String otp,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await repository.confirmPickup(orderId: orderId, otp: otp);

      print("✅ Pickup Confirmed");
      print("📦 Delivery OTP: ${res.deliveryOtp}");

      // Refresh order details
      // ignore: unused_result
      ref.refresh(orderDetailsControllerProvider(orderId));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow; // so UI can show proper error
    }
  }
}
