import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'home_modal.dart';
import 'home_repo.dart';

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, AsyncValue<DashboardModel?>>((
      ref,
    ) {
      final repo = ref.watch(dashboardRepositoryProvider);
      return DashboardController(repo);
    });

class DashboardController extends StateNotifier<AsyncValue<DashboardModel?>> {
  final DashboardRepository repository;
  bool isUpdatingStatus = false; // track loading

  DashboardController(this.repository) : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final model = await repository.fetchDashboard();
      state = AsyncValue.data(model);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggle online/offline
  Future<void> toggleAvailability(bool value) async {
    if (state.value == null) return;

    final driver = state.value!.driverInfo;

    /// ❌ Suspended
    if (driver.status == "suspended") {
      throw Exception("Your account is suspended");
    }

    /// ❌ On trip → cannot go offline
    if (driver.status == "on_trip" && value == false) {
      throw Exception("You cannot go offline while on a trip");
    }

    try {
      isUpdatingStatus = true;

      final result = await repository.updateAvailability(value);

      final newStatus = result['status'];

      /// update local dashboard state
      final current = state.value!;

      final updatedDriver = current.driverInfo.copyWith(status: newStatus);

      state = AsyncData(current.copyWith(driverInfo: updatedDriver));
    } finally {
      isUpdatingStatus = false;
    }
  }
}
