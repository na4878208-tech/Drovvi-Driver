import 'package:logisticdriverapp/constants/api_url.dart';
import 'package:logisticdriverapp/constants/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'token_manager.dart';

part 'dio.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Attach token if available
        final token = await LocalStorage.getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },

      onError: (error, handler) async {
        final requestPath = error.requestOptions.path;

        // Only trigger session expired dialog for token-protected requests
        final hasToken = error.requestOptions.headers.containsKey(
          "Authorization",
        );

        // List of public endpoints that never trigger session expiration
        final publicPaths = [
          ApiUrls.login,
          ApiUrls.forgotPassword,
          ApiUrls.otpforgotPassword,
          ApiUrls.resendotpforgotPassword,
        ];

        if (hasToken &&
            !publicPaths.contains(requestPath) &&
            error.response?.statusCode == 401) {
          await SessionManager.handleSessionExpired();
        }

        return handler.next(error);
      },
    ),
  );

  return dio;
}
