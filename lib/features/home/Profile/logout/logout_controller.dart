import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logisticdriverapp/features/home/Profile/logout/logout_repo.dart';

final logoutControllerProvider =
    StateNotifierProvider<LogoutController, AsyncValue<void>>(
      (ref) => LogoutController(ref),
    );

class LogoutController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  LogoutController(this.ref) : super(const AsyncData(null));

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(logoutRepositoryProvider);
      await repo.logout();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
