import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'skip_stop_model.dart';
import 'skip_stop_repo.dart';

final skipStopControllerProvider =
    StateNotifierProvider<SkipStopController, AsyncValue<SkipStopResponse>>((
      ref,
    ) {
      final repo = ref.watch(skipStopRepositoryProvider);
      return SkipStopController(repo);
    });

class SkipStopController extends StateNotifier<AsyncValue<SkipStopResponse>> {
  final SkipStopRepository repository;

  SkipStopController(this.repository) : super(const AsyncValue.loading());

  Future<void> requestSkip({
    required int orderId,
    required int stopId,
    required String reason,
  }) async {
    state = const AsyncValue.loading();
    try {
      await repository.requestSkip(
        orderId: orderId,
        stopId: stopId,
        reason: reason,
      );
      // After creating skip, fetch updated status
      final updatedStatus = await repository.getSkipStatus(
        orderId: orderId,
        stopId: stopId,
      );
      state = AsyncValue.data(updatedStatus);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchSkipStatus({
    required int orderId,
    required int stopId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await repository.getSkipStatus(
        orderId: orderId,
        stopId: stopId,
      );
      state = AsyncValue.data(res);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
