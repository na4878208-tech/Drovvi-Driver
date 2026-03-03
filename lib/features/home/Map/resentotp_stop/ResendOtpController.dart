import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:logisticdriverapp/constants/dio.dart';
import 'package:logisticdriverapp/features/home/Map/resentotp_stop/OrderRepository_stop.dart';

class ResendOtpController extends StateNotifier<AsyncValue<void>> {
  final OrderrepositoryStop repository;

  ResendOtpController(this.repository)
      : super(const AsyncData(null));

  Future<void> resendOtp({
    required int orderId,
    required int stopId,
  }) async {
    try {
      state = const AsyncLoading();

      final response = await repository.resendOtp(
        orderId: orderId,
        stopId: stopId,
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}




final orderRepositoryProvider = Provider<OrderrepositoryStop>((ref) {
  final dio = ref.read(dioProvider);
  return OrderrepositoryStop(dio);
});

final resendOtpControllerProvider =
    StateNotifierProvider<ResendOtpController, AsyncValue<void>>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return ResendOtpController(repo);
});