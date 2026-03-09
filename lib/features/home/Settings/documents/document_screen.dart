import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constants/colors.dart';
import 'document_card_screen.dart';
import 'document_controller.dart';
import 'upload document/upload_document_screen.dart';

class DriverDocumentsScreen extends ConsumerStatefulWidget {
  const DriverDocumentsScreen({super.key});

  @override
  ConsumerState<DriverDocumentsScreen> createState() =>
      _DriverDocumentsScreenState();
}

class _DriverDocumentsScreenState extends ConsumerState<DriverDocumentsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(driverDocumentControllerProvider.notifier).loadDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(driverDocumentControllerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Documents",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => context.go("/setting"),
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.pureWhite,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadDocumentScreen()),
          ).then((_) {
            ref.read(driverDocumentControllerProvider.notifier).loadDocuments();
          });
        },
        child: const Icon(Icons.upload, color: AppColors.electricTeal),
      ),
      body: documentsAsync.when(
        loading: () => const DocumentsShimmer(), // ← shimmer loader
        error: (e, _) => Center(child: Text(e.toString())),
        data: (response) {
          final docs = response.documents;
          final missingDocs = response.missingDocuments;
          final requiredDocs = response.requiredDocuments;

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(driverDocumentControllerProvider.notifier)
                  .loadDocuments();
            },
            child: ListView(
              children: [
                /// 🔴 Missing Documents Banner
                missingDocumentsBanner(
                  missingDocs: missingDocs,
                  requiredDocs: requiredDocs,
                ),
                const SizedBox(height: 10),

                if (docs.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "No Documents Uploaded",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                /// Uploaded Documents
                ...docs.map(
                  (doc) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: DocumentCard(
                      doc: doc,
                      onDelete: () async {
                        await ref
                            .read(driverDocumentRepoProvider)
                            .deleteDocument(doc.id);
                        ref
                            .read(driverDocumentControllerProvider.notifier)
                            .loadDocuments();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer Loader for Documents Screen
class DocumentsShimmer extends StatelessWidget {
  const DocumentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 16),

          // Missing Documents Banner
          Container(
            width: double.infinity,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 16),

          // Document Cards placeholders (5 sample items)
          ...List.generate(7, (index) {
            return Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

/// Missing Documents Banner (same as your original)
Widget missingDocumentsBanner({
  required List<String> missingDocs,
  required Map<String, dynamic> requiredDocs,
}) {
  if (missingDocs.isEmpty) return const SizedBox();

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE082),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              "Missing Required Documents",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "The following required documents are missing:",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...missingDocs.map((docType) {
          final label = requiredDocs[docType] ?? docType;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Text("• "),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}
