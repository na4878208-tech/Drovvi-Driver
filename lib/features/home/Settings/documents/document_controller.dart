import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'document details/document_details_model.dart';
import 'document_modal.dart';
import 'document_repo.dart';

/// ---------------- REPOSITORY PROVIDER ----------------
final driverDocumentRepoProvider = Provider<DriverDocumentRepository>((ref) {
  return DriverDocumentRepository();
});

/// ---------------- CONTROLLER PROVIDER ----------------
final driverDocumentControllerProvider =
    StateNotifierProvider<
      DriverDocumentController,
      AsyncValue<DriverDocumentsResponse>
    >((ref) {
      final repo = ref.watch(driverDocumentRepoProvider);

      return DriverDocumentController(repo);
    });

/// DOCUMENT DETAIL PROVIDER
final documentDetailProvider = FutureProvider.family<
    DriverDocumentDetailModel,
    int>((ref, id) async {

  final repo = ref.watch(driverDocumentRepoProvider);

  return repo.getDocumentDetail(id);
});

/// ---------------- CONTROLLER ----------------
class DriverDocumentController
    extends StateNotifier<AsyncValue<DriverDocumentsResponse>> {
  final DriverDocumentRepository repo;

  DriverDocumentController(this.repo) : super(const AsyncLoading()) {
    loadDocuments();
  }

  /// Load Documents
  Future<void> loadDocuments() async {
    try {
      state = const AsyncLoading();

      final response = await repo.getDocuments();

      state = AsyncData(response);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  /// Refresh Documents
  Future<void> refreshDocuments() async {
    try {
      final response = await repo.getDocuments();

      state = AsyncData(response);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  /// Delete Document
  Future<void> deleteDocument(int id) async {
    try {
      await repo.deleteDocument(id);

      await loadDocuments();
    } catch (e) {
      print("Delete document error: $e");
    }
  }
}
