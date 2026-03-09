import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../constants/local_storage.dart';
import 'login_modal.dart';
import 'login_repo.dart';

class LoginController extends StateNotifier<AsyncValue<LoginModel?>> {
  final LoginRepository repository;

  LoginController(this.repository) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      final result = await repository.login(
        email: email,
        password: password,
      );

      // ✅ TOKEN SAVE FOR AUTH SESSION
      final token = result.data.accessToken;

      if (token.isNotEmpty) {
        await LocalStorage.saveToken(token);
      }

      state = AsyncData(result);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<LoginModel?>>((ref) {
  final repo = ref.watch(loginRepositoryProvider);
  return LoginController(repo);
});