import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constants/colors.dart';
import '../document_controller.dart';
import '../document_modal.dart';
import '../update documents/updates_document_screen.dart';

class DocumentDetailScreen extends ConsumerWidget {
  final int documentId;

  const DocumentDetailScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// REFRESH API EVERY TIME SCREEN BUILDS
    final detail = ref.watch(documentDetailProvider(documentId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Document Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, size: 18),
        ),

        /// EDIT BUTTON IN APPBAR
        actions: [
          detail.when(
            data: (doc) {
              final DriverDocumentModel document = DriverDocumentModel(
                id: doc.id,
                documentType: doc.documentType,
                documentTypeDisplay: doc.documentTypeDisplay,
                documentNumber: doc.documentNumber,
                documentUrl: doc.documentUrl,
                status: doc.status,
                issueDate: doc.issueDate,
                expiryDate: doc.expiryDate,
                isExpired: doc.isExpired,
                isExpiringSoon: doc.isExpiringSoon,
              );

              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  /// GO TO UPDATE SCREEN
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateDocumentScreen(document: document),
                    ),
                  );

                  /// REFRESH DATA AFTER RETURN
                  // ignore: unused_result
                  ref.refresh(documentDetailProvider(documentId));
                },
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],

        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
      ),

      /// BODY
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result
          ref.refresh(documentDetailProvider(documentId));
        },

        child: detail.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (e, _) => Center(child: Text("Error: $e")),

          data: (doc) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                /// DOCUMENT IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    doc.documentUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 25),

                /// TYPE
                _infoCard(
                  "Document Type",
                  doc.documentTypeDisplay,
                  Icons.description,
                ),

                /// NUMBER
                _infoCard(
                  "Document Number",
                  doc.documentNumber,
                  Icons.confirmation_number,
                ),

                /// ISSUE DATE
                _infoCard("Issue Date", doc.issueDate, Icons.date_range),

                /// EXPIRY DATE
                _infoCard("Expiry Date", doc.expiryDate, Icons.event),

                /// FILE SIZE
                _infoCard("File Size", doc.fileSizeHuman, Icons.storage),

                /// FILE TYPE
                _infoCard("File Type", doc.fileMimeType, Icons.file_present),

                /// STATUS
                _statusCard(doc.status),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.electricTeal),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(String status) {
    Color color = Colors.orange;

    if (status == "approved") color = Colors.green;
    if (status == "rejected") color = Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          status.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
