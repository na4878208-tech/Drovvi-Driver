import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'earning_model.dart';
import 'earning_repo.dart';

/// Earnings List Controller
final earningsControllerProvider =
    StateNotifierProvider<EarningsController, AsyncValue<List<EarningModel>>>((
      ref,
    ) {
      final repo = ref.watch(earningRepositoryProvider);
      return EarningsController(repo);
    });

class EarningsController extends StateNotifier<AsyncValue<List<EarningModel>>> {
  final EarningRepository repository;
  List<EarningModel> _earnings = [];
  String currentPeriod = "week";
  int currentPage = 1;
  final int perPage = 10;
  bool hasMore = true;

  EarningsController(this.repository) : super(const AsyncValue.loading());

  /// Fetch earnings with pagination
  Future<void> fetchEarnings({String? period, bool loadMore = false}) async {
    if (!loadMore) {
      state = const AsyncValue.loading();
      _earnings = [];
      currentPage = 1;
      hasMore = true;
      currentPeriod = period ?? currentPeriod;
    }

    if (!hasMore) return;

    try {
      final data = await repository.getEarnings(
        period: currentPeriod,
        page: currentPage,
        perPage: perPage,
      );

      if (data.length < perPage) {
        hasMore = false;
      } else {
        currentPage += 1;
      }

      _earnings.addAll(data);
      state = AsyncValue.data([..._earnings]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh earnings
  Future<void> refreshEarnings({String? period}) async {
    await fetchEarnings(period: period, loadMore: false);
  }

  /// Load next page
  Future<void> loadMore() async {
    await fetchEarnings(loadMore: true);
  }

  /// Update period filter
  Future<void> updatePeriod(String period) async {
    await fetchEarnings(period: period, loadMore: false);
  }
}

/// Earnings Summary Controller
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
  String currentPeriod = "week";

  EarningsSummaryController(this.repository)
    : super(const AsyncValue.loading()) {
    fetchSummary();
  }

  Future<void> fetchSummary({String? period}) async {
    state = const AsyncValue.loading();
    currentPeriod = period ?? currentPeriod;
    try {
      final data = await repository.getEarningsSummary(period: currentPeriod);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshSummary({String? period}) async {
    await fetchSummary(period: period);
  }
}
