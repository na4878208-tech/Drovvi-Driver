class DriverDocumentDetailModel {
  final int id;
  final String documentType;
  final String documentTypeDisplay;
  final String documentNumber;
  final String documentUrl;
  final String status;

  final String issueDate;
  final String expiryDate;

  final bool isExpired;
  final bool isExpiringSoon;

  final String fileSizeHuman;
  final String fileMimeType;

  final bool isImage;
  final bool isPdf;

  final String createdAt;

  DriverDocumentDetailModel({
    required this.id,
    required this.documentType,
    required this.documentTypeDisplay,
    required this.documentNumber,
    required this.documentUrl,
    required this.status,
    required this.issueDate,
    required this.expiryDate,
    required this.isExpired,
    required this.isExpiringSoon,
    required this.fileSizeHuman,
    required this.fileMimeType,
    required this.isImage,
    required this.isPdf,
    required this.createdAt,
  });

  factory DriverDocumentDetailModel.fromJson(Map<String, dynamic> json) {
    return DriverDocumentDetailModel(
      id: json["id"] ?? 0,
      documentType: json["document_type"]?.toString() ?? "",
      documentTypeDisplay:
          json["document_type_display"]?.toString() ??
          json["document_type"]?.toString() ??
          "",
      documentNumber: json["document_number"]?.toString() ?? "",
      documentUrl: json["document_url"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",

      issueDate: json["issue_date"]?.toString() ?? "",
      expiryDate: json["expiry_date"]?.toString() ?? "",

      isExpired: json["is_expired"] ?? false,
      isExpiringSoon: json["is_expiring_soon"] ?? false,

      fileSizeHuman: json["file_size_human"]?.toString() ?? "",
      fileMimeType: json["file_mime_type"]?.toString() ?? "",

      isImage: json["is_image"] ?? false,
      isPdf: json["is_pdf"] ?? false,

      createdAt: json["created_at"]?.toString() ?? "",
    );
  }
}