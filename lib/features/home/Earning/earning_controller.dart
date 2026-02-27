import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'earning_model.dart';
import 'earning_repo.dart';

final earningsControllerProvider =
    StateNotifierProvider<EarningsController, AsyncValue<List<EarningModel>>>((
      ref,
    ) {
      final repo = ref.watch(earningRepositoryProvider);
      return EarningsController(repo);
    });

class EarningsController extends StateNotifier<AsyncValue<List<EarningModel>>> {
  final EarningRepository repository;
  EarningsController(this.repository) : super(const AsyncValue.loading()) {
    fetchEarnings();
  }

  Future<void> fetchEarnings() async {
    state = const AsyncValue.loading();
    try {
      final data = await repository.getEarnings();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final earningsSummaryControllerProvider =
    StateNotifierProvider<
      EarningsSummaryController,
      AsyncValue<EarningSummary>
    >((ref) {
      final repo = ref.watch(earningRepositoryProvider);
      return EarningsSummaryController(repo);
    });

class EarningsSummaryController
    extends StateNotifier<AsyncValue<EarningSummary>> {
  final EarningRepository repository;
  EarningsSummaryController(this.repository)
    : super(const AsyncValue.loading()) {
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    state = const AsyncValue.loading();
    try {
      final data = await repository.getEarningsSummary();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
