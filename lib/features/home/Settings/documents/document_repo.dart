import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../constants/local_storage.dart';
import 'document details/document_details_model.dart';
import 'document_modal.dart';

class DriverDocumentRepository {
  final String baseUrl = "https://drovvi.com/api/v1/driver/documents";

  /// ---------------- GET DOCUMENTS ----------------
  Future<DriverDocumentsResponse> getDocuments() async {
    try {
      final token = await LocalStorage.getToken();

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📡 GET DOCUMENTS API");
      print("URL: $baseUrl");
      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DriverDocumentsResponse.fromJson(data);
      } else {
        throw Exception("Failed to fetch documents");
      }
    } catch (e) {
      print("❌ GET DOCUMENTS ERROR: $e");
      rethrow;
    }
  }

  /// ---------------- GET DOCUMENT TYPES ----------------
  Future<Map<String, dynamic>> getDocumentTypes() async {
    try {
      final token = await LocalStorage.getToken();

      final response = await http.get(
        Uri.parse("$baseUrl/types"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📡 GET DOCUMENT TYPES API");
      print("URL: $baseUrl/types");
      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch document types");
      }
    } catch (e) {
      print("❌ GET DOCUMENT TYPES ERROR: $e");
      rethrow;
    }
  }

  /// ---------------- UPLOAD DOCUMENT ----------------
  Future<Map<String, dynamic>> uploadDocument({
    required String type,
    required String number,
    required String issueDate,
    required String expiryDate,
    required File file,
  }) async {
    try {
      final token = await LocalStorage.getToken();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(baseUrl),
      );

      request.headers["Authorization"] = "Bearer $token";

      request.fields["document_type"] = type;
      request.fields["document_number"] = number;
      request.fields["issue_date"] = issueDate;
      request.fields["expiry_date"] = expiryDate;

      request.files.add(
        await http.MultipartFile.fromPath(
          "document_file",
          file.path,
        ),
      );

      print("📡 UPLOAD DOCUMENT API");
      print("Type: $type");
      print("Number: $number");
      print("Issue Date: $issueDate");
      print("Expiry Date: $expiryDate");
      print("File Path: ${file.path}");

      final response = await request.send();

      final respStr = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Response: $respStr");

      return jsonDecode(respStr);
    } catch (e) {
      print("❌ UPLOAD DOCUMENT ERROR: $e");
      rethrow;
    }
  }

  /// ---------------- GET DOCUMENT DETAIL ----------------
Future<DriverDocumentDetailModel> getDocumentDetail(int id) async {
  try {
    final token = await LocalStorage.getToken();

    final url = "$baseUrl/$id";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("📡 GET DOCUMENT DETAIL API");
    print("URL: $url");
    print("Status Code: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return DriverDocumentDetailModel.fromJson(data["data"] ?? {});
    } else {
      throw Exception("Failed to fetch document detail");
    }
  } catch (e) {
    print("❌ GET DOCUMENT DETAIL ERROR: $e");
    rethrow;
  }
}

  /// ---------------- UPDATE DOCUMENT ----------------
  Future<Map<String, dynamic>> updateDocument({
    required int id,
    required String type,
    required String number,
    required String issueDate,
    required String expiryDate,
    File? file,
  }) async {
    try {
      final token = await LocalStorage.getToken();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/$id"),
      );

      request.headers["Authorization"] = "Bearer $token";

      request.fields["document_type"] = type;
      request.fields["document_number"] = number;
      request.fields["issue_date"] = issueDate;
      request.fields["expiry_date"] = expiryDate;

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "document_file",
            file.path,
          ),
        );
      }

      print("📡 UPDATE DOCUMENT API");
      print("Document ID: $id");
      print("Type: $type");
      print("Number: $number");

      final response = await request.send();

      final respStr = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Response: $respStr");

      return jsonDecode(respStr);
    } catch (e) {
      print("❌ UPDATE DOCUMENT ERROR: $e");
      rethrow;
    }
  }

  /// ---------------- DELETE DOCUMENT ----------------
  Future<Map<String, dynamic>> deleteDocument(int id) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("📡 DELETE DOCUMENT API");
      print("Document ID: $id");
      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      return jsonDecode(response.body);
    } catch (e) {
      print("❌ DELETE DOCUMENT ERROR: $e");
      rethrow;
    }
  }
}