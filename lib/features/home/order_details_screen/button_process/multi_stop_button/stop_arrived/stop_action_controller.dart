import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../order_detail_controller.dart';
import 'stop_action_repo.dart';
import 'stop_action_model.dart';

final stopActionControllerProvider =
    StateNotifierProvider<StopActionController, AsyncValue<void>>((ref) {
      final repo = ref.watch(stopActionRepositoryProvider);
      return StopActionController(repo, ref);
    });

class StopActionController extends StateNotifier<AsyncValue<void>> {
  final StopActionRepository repository;
  final Ref ref;
  bool _isMounted = true;

  StopActionController(this.repository, this.ref)
    : super(const AsyncValue.data(null));

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  /// 🚏 ARRIVED
  Future<StopActionResponse> arrivedStop({
    required int orderId,
    required int stopId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await repository.arrivedStop(
        orderId: orderId,
        stopId: stopId,
      );

      if (!_isMounted) return res;

      if (kDebugMode) {
        print("🚏 STOP ARRIVED");
        print("📍 StopId: ${res.data?.stopId}");
        print("📦 Type: ${res.data?.stopType}");
        print("🕒 Arrival: ${res.data?.arrivalTime}");
      }

      ref.invalidate(orderDetailsControllerProvider(orderId));

      state = const AsyncValue.data(null);
      return res;
    } catch (e, st) {
      if (_isMounted) {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }

  /// ✅ COMPLETE (OTP Optional)
  Future<StopActionResponse> completeStop({
    required int orderId,
    required int stopId,
    String? otp, // 🔥 OPTIONAL
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await repository.completeStop(
        orderId: orderId,
        stopId: stopId,
        otp: otp, // pass only when provided
      );

      if (!_isMounted) return res;

      if (kDebugMode) {
        print("✅ STOP COMPLETED");
        print("📍 StopId: ${res.data?.stopId}");
        print("📦 Order Status: ${res.data?.orderStatus}");
        print("🏁 Order Completed: ${res.data?.isOrderCompleted}");
      }

      ref.invalidate(orderDetailsControllerProvider(orderId));

      state = const AsyncValue.data(null);
      return res;
    } catch (e, st) {
      if (_isMounted) {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }
}
