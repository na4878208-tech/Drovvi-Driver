// MODEL
class DriverDocumentModel {
  final int id;
  final String documentType;
  final String documentTypeDisplay;
  final String documentNumber;
  final String documentUrl;
  final String status;
  final String? issueDate;
  final String? expiryDate;
  final bool isExpired;
  final bool isExpiringSoon;

  DriverDocumentModel({
    required this.id,
    required this.documentType,
    required this.documentTypeDisplay,
    required this.documentNumber,
    required this.documentUrl,
    required this.status,
    this.issueDate,
    this.expiryDate,
    required this.isExpired,
    required this.isExpiringSoon,
  });

  factory DriverDocumentModel.fromJson(Map<String, dynamic> json) {
    return DriverDocumentModel(
      id: json['id'] ?? 0,
      documentType: json['document_type']?.toString() ?? "",
      documentTypeDisplay: json['document_type_display']?.toString() ??
          json['document_type']?.toString() ??
          "",
      documentNumber: json['document_number']?.toString() ?? "",
      documentUrl: json['document_url']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      issueDate: json['issue_date']?.toString(),
      expiryDate: json['expiry_date']?.toString(),
      isExpired: json['is_expired'] ?? false,
      isExpiringSoon: json['is_expiring_soon'] ?? false,
    );
  }
}

// RESPONSE
class DriverDocumentsResponse {
  final List<DriverDocumentModel> documents;
  final Map<String, String> requiredDocuments;
  final List<String> missingDocuments;

  DriverDocumentsResponse({
    required this.documents,
    required this.requiredDocuments,
    required this.missingDocuments,
  });

  factory DriverDocumentsResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    List docs = data["documents"] ?? [];

    // Convert missing_documents safely
    List<String> missingList = [];
    final missingDocs = data["missing_documents"];
    if (missingDocs != null) {
      if (missingDocs is List) {
        missingList = missingDocs.map((e) => e?.toString() ?? "").toList();
      } else if (missingDocs is Map) {
        missingList =
            missingDocs.values.map((e) => e?.toString() ?? "").toList();
      }
    }

    // required_documents map safely
    final requiredDocs = data["required_documents"];
    Map<String, String> requiredMap = {};
    if (requiredDocs != null && requiredDocs is List) {
      // Some APIs return a list
      for (var key in requiredDocs) {
        requiredMap[key?.toString() ?? ""] = key?.toString() ?? "";
      }
    } else if (requiredDocs != null && requiredDocs is Map) {
      requiredDocs.forEach((key, value) {
        requiredMap[key?.toString() ?? ""] = value?.toString() ?? key?.toString() ?? "";
      });
    }

    return DriverDocumentsResponse(
      documents: docs.map((e) {
        if (e != null && e is Map<String, dynamic>) {
          return DriverDocumentModel.fromJson(e);
        }
        // fallback empty document
        return DriverDocumentModel(
          id: 0,
          documentType: "",
          documentTypeDisplay: "",
          documentNumber: "",
          documentUrl: "",
          status: "",
          isExpired: false,
          isExpiringSoon: false,
        );
      }).toList(),
      requiredDocuments: requiredMap,
      missingDocuments: missingList,
    );
  }
}

