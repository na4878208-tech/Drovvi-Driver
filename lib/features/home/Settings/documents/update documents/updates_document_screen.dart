import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common_widgets/cuntom_textfield.dart';
import '../../../../../common_widgets/custom_button.dart';
import '../../../../../constants/bottom_show.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/validation_regx.dart';

import '../document_controller.dart';
import '../upload document/upload_document_type.dart';
import '../document_modal.dart';

class UpdateDocumentScreen extends ConsumerStatefulWidget {
  final DriverDocumentModel document; // Document to update

  const UpdateDocumentScreen({super.key, required this.document});

  @override
  ConsumerState<UpdateDocumentScreen> createState() =>
      _UpdateDocumentScreenState();
}

class _UpdateDocumentScreenState extends ConsumerState<UpdateDocumentScreen> {
  final formKey = GlobalKey<FormState>();

  String? typeError;
  String? fileError;
  File? file;

  String? selectedType;

  bool _isSubmitting = false;
  bool isLoadingTypes = true;

  late TextEditingController numberController;
  late TextEditingController issueDateController;
  late TextEditingController expiryDateController;

  final numberFocus = FocusNode();
  final issueFocus = FocusNode();
  final expiryFocus = FocusNode();

  Map<String, dynamic> documentTypes = {};
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers safely
    numberController = TextEditingController(
      text: widget.document.documentNumber,
    );
    issueDateController = TextEditingController(
      text: widget.document.issueDate ?? "",
    );
    expiryDateController = TextEditingController(
      text: widget.document.expiryDate ?? "",
    );

    selectedType = widget.document.documentType;

    numberController.addListener(checkButton);
    issueDateController.addListener(checkButton);
    expiryDateController.addListener(checkButton);

    loadTypes();
    checkButton();
  }

  void checkButton() {
    setState(() {
      isButtonEnabled =
          numberController.text.isNotEmpty &&
          issueDateController.text.isNotEmpty &&
          expiryDateController.text.isNotEmpty &&
          selectedType != null &&
          selectedType!.isNotEmpty;
      // file is optional in update
    });
  }

  Future<void> pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      checkButton();
    }
  }

  Future loadTypes() async {
    try {
      final repo = ref.read(driverDocumentRepoProvider);
      final data = await repo.getDocumentTypes();

      final rawTypes = data["data"]?["document_types"] ?? {};

      final types = <String, String>{};

      if (rawTypes is Map) {
        rawTypes.forEach((key, value) {
          types[key.toString()] = value?.toString() ?? key.toString();
        });
      }

      if (!mounted) return;

      setState(() {
        documentTypes = types;

        if (types.containsKey(widget.document.documentType)) {
          selectedType = widget.document.documentType;
        } else if (types.isNotEmpty) {
          selectedType = types.keys.first;
        } else {
          selectedType = "";
        }

        isLoadingTypes = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingTypes = false;
        });
        AppSnackBar.showError(context, "Failed to load document types");
      }
    }
  }

  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      checkButton();
    }
  }

  Future updateDocument() async {
    setState(() {
      typeError = AppValidators.selection(selectedType, field: "Document Type");
      fileError = null; // optional
    });

    if (!formKey.currentState!.validate() || typeError != null) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(driverDocumentRepoProvider);

      final response = await repo.updateDocument(
        id: widget.document.id,
        type: selectedType ?? "",
        number: numberController.text,
        issueDate: issueDateController.text,
        expiryDate: expiryDateController.text,
        file: file,
      );

      if (!mounted) return;

      final currentContext = context; // ✅ Store context safely

      if (response["success"] == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Safe to use context here
          AppSnackBar.showSuccess(
            currentContext,
            "Document updated successfully",
          );
          Navigator.of(currentContext).pop(); // Navigate back safely
          ref.read(driverDocumentControllerProvider.notifier).loadDocuments();
        });
      } else {
        final message = response["message"] ?? "Update failed";
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
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Update Documents",
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
            /// DOCUMENT TYPE
            isLoadingTypes
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      DocumentTypeField(
                        label: "Select Document Type",
                        items: documentTypes,
                        selectedValue: selectedType ?? "", // always a string
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
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
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

            /// FILE BUTTON (optional)
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
            if (file != null)
              Center(
                child: Text(
                  file!.path.split("/").last,
                  style: const TextStyle(fontSize: 12),
                ),
              ),

            const SizedBox(height: 40),

            /// UPDATE BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                text: _isSubmitting ? "Submitting..." : "Update",
                backgroundColor: isButtonEnabled
                    ? AppColors.electricTeal
                    : AppColors.lightGrayBackground,
                borderColor: isButtonEnabled
                    ? AppColors.lightGrayBackground
                    : AppColors.electricTeal,
                textColor: isButtonEnabled
                    ? Colors.white
                    : AppColors.electricTeal,
                onPressed: (isButtonEnabled && !_isSubmitting)
                    ? updateDocument
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
