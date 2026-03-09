import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../common_widgets/cuntom_textfield.dart';
import '../../../../../common_widgets/custom_button.dart';
import '../../../../../constants/bottom_show.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/validation_regx.dart';

import '../document_controller.dart';
import 'upload_document_type.dart';

class UploadDocumentScreen extends ConsumerStatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  ConsumerState<UploadDocumentScreen> createState() =>
      _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends ConsumerState<UploadDocumentScreen> {
  final formKey = GlobalKey<FormState>();

  String? typeError;
  String? fileError;
  File? file;

  bool _isUploading = false;

  String? selectedType;

  final numberController = TextEditingController();
  final issueDateController = TextEditingController();
  final expiryDateController = TextEditingController();

  final numberFocus = FocusNode();
  final issueFocus = FocusNode();
  final expiryFocus = FocusNode();

  Map<String, dynamic> documentTypes = {};

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    loadTypes();

    numberController.addListener(checkButton);
    issueDateController.addListener(checkButton);
    expiryDateController.addListener(checkButton);
  }

  void checkButton() {
    setState(() {
      isButtonEnabled =
          numberController.text.isNotEmpty &&
          issueDateController.text.isNotEmpty &&
          expiryDateController.text.isNotEmpty &&
          selectedType != null &&
          file != null;
    });
  }

  Future<void> pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = DateFormat('MM-dd-yyyy').format(picked);

      checkButton();
    }
  }

  Future loadTypes() async {
    final repo = ref.read(driverDocumentRepoProvider);

    final data = await repo.getDocumentTypes();

    setState(() {
      documentTypes = data["data"]["document_types"];
    });
  }

  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);

      checkButton();
    }
  }

  Future upload() async {
    setState(() {
      typeError = AppValidators.selection(selectedType, field: "Document Type");
      fileError = file == null ? "Document file is required" : null;
    });

    if (!formKey.currentState!.validate() ||
        typeError != null ||
        fileError != null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final repo = ref.read(driverDocumentRepoProvider);

      final response = await repo.uploadDocument(
        type: selectedType!,
        number: numberController.text,
        issueDate: issueDateController.text,
        expiryDate: expiryDateController.text,
        file: file!,
      );

      if (!mounted) return; // ✅ safeguard

      final currentContext = context; // Store context safely

      if (response["success"] == true) {
        // Use post-frame callback to safely show SnackBar and navigate
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppSnackBar.showSuccess(
            currentContext,
            "Document uploaded successfully",
          );
          Navigator.of(currentContext).pop();
          ref.read(driverDocumentControllerProvider.notifier).loadDocuments();
        });
      } else {
        final message = response["message"] ?? "Upload failed";
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppSnackBar.showError(currentContext, message);
        });
      }
    } catch (e) {
      if (!mounted) return;
      final currentContext = context;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppSnackBar.showError(currentContext, "Something went wrong");
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Upload Documents",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        centerTitle: true,
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
      ),

      body: Form(
        key: formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [
            /// DOCUMENT TYPE FIELD
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                DocumentTypeField(
                  label: "Select Document Type",
                  items: documentTypes,
                  selectedValue: selectedType,
                  onSelected: (value) {
                    setState(() {
                      selectedType = value;
                      typeError = null;
                    });

                    checkButton();
                  },
                ),

                if (typeError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 6),
                    child: Text(
                      typeError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 22),

            /// DOCUMENT NUMBER
            CustomAnimatedTextField(
              controller: numberController,
              focusNode: numberFocus,
              labelText: "Document Number",
              hintText: "Enter Document Number",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.credit_card,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
              validator: (v) =>
                  AppValidators.numeric(v, field: "Document Number"),
            ),

            const SizedBox(height: 10),

            /// ISSUE DATE
            CustomAnimatedTextField(
              controller: issueDateController,
              focusNode: issueFocus,
              labelText: "Issue Date",
              hintText: "Issue Date",
              prefixIcon: Icons.date_range,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,

              keyboardType: TextInputType.datetime,

              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => pickDate(issueDateController),
              ),

              validator: (v) => AppValidators.dob(v),
            ),

            const SizedBox(height: 10),

            /// EXPIRY DATE
            CustomAnimatedTextField(
              controller: expiryDateController,
              focusNode: expiryFocus,
              labelText: "Expiry Date",
              hintText: "Expiry Date",
              prefixIcon: Icons.event_available,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,

              keyboardType: TextInputType.datetime,

              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => pickDate(expiryDateController),
              ),

              validator: (v) => AppValidators.expiryDate(v),
            ),

            const SizedBox(height: 30),

            /// FILE BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                text: file == null ? "Select Document File" : "File Selected",
                backgroundColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: Colors.white,
                onPressed: pickFile,
              ),
            ),
            if (fileError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    fileError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (file != null)
              Center(
                child: Text(
                  file!.path.split("/").last,
                  style: const TextStyle(fontSize: 12),
                ),
              ),

            const SizedBox(height: 40),

            /// SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                text: _isUploading ? "Submitting..." : "Submit",
                backgroundColor: isButtonEnabled
                    ? AppColors.electricTeal
                    : AppColors.lightGrayBackground,
                borderColor: isButtonEnabled
                    ? AppColors.lightGrayBackground
                    : AppColors.electricTeal,
                textColor: isButtonEnabled
                    ? Colors.white
                    : AppColors.electricTeal,
                onPressed: (isButtonEnabled && !_isUploading) ? upload : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
