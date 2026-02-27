import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/validation_regx.dart';
import '../../../export.dart';
import 'Registration_flow/dropdown.dart';

class SetUpProfile extends ConsumerStatefulWidget {
  const SetUpProfile({super.key});

  @override
  ConsumerState<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends ConsumerState<SetUpProfile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final TextEditingController prdpNumberController = TextEditingController();
  final TextEditingController prdpExpiryController = TextEditingController();

  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController licenseExpiryController = TextEditingController();

  final TextEditingController dobController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyPhoneController =
      TextEditingController();

  //FocusNodes
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode mobileFocus = FocusNode();

  final FocusNode prdpNumberFocus = FocusNode();
  final FocusNode prdpExpiryFocus = FocusNode();

  final FocusNode licenseNumberFocus = FocusNode();
  final FocusNode licenseExpiryFocus = FocusNode();

  final FocusNode dobFocus = FocusNode();
  final FocusNode emergencyNameFocus = FocusNode();
  final FocusNode emergencyPhoneFocus = FocusNode();

  XFile? profileImage;
  final ImagePicker _picker = ImagePicker();

  bool isButtonEnabled = false;

  final List<String> licenseCategories = [
    "Code B - Light Vehicle (≤3,500kg)",
    "Code EB - Light + Trailer",
    "Code C1 - Heavy (3.5–16 tons)",
    "Code C - Heavy (>16 tons)",
    "Code EC1 - C1 + Trailer",
    "Code EC - C + Articulated",
  ];

  @override
  void initState() {
    super.initState();

    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    mobileController.addListener(_validateForm);

    prdpNumberController.addListener(_validateForm);
    prdpExpiryController.addListener(_validateForm);

    licenseNumberController.addListener(_validateForm);
    licenseExpiryController.addListener(_validateForm);

    dobController.addListener(_validateForm);
    emergencyNameController.addListener(_validateForm);
    emergencyPhoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();

    prdpNumberController.dispose();
    prdpExpiryController.dispose();

    licenseNumberController.dispose();
    licenseExpiryController.dispose();

    dobController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();

    firstNameFocus.dispose();
    lastNameFocus.dispose();
    mobileFocus.dispose();

    prdpNumberFocus.dispose();
    prdpExpiryFocus.dispose();

    licenseNumberFocus.dispose();
    licenseExpiryFocus.dispose();

    dobFocus.dispose();
    emergencyNameFocus.dispose();
    emergencyPhoneFocus.dispose();

    super.dispose();
  }

  void _validateForm() {
    final isValid =
        AppValidators.name(firstNameController.text, fieldName: "First Name") ==
            null &&
        AppValidators.name(lastNameController.text, fieldName: "Last Name") ==
            null &&
        AppValidators.phone(mobileController.text) == null &&
        AppValidators.prdpNumber(prdpNumberController.text) == null &&
        AppValidators.dob(prdpExpiryController.text) == null &&
        AppValidators.licenseNumber(licenseNumberController.text) == null &&
        AppValidators.expiryDate(
              licenseExpiryController.text,
              field: "License Expiry",
            ) ==
            null &&
        AppValidators.dob(dobController.text) == null &&
        AppValidators.name(
              emergencyNameController.text,
              fieldName: "Emergency Contact Name",
            ) ==
            null &&
        AppValidators.phone(emergencyPhoneController.text) == null;

    if (isValid != isButtonEnabled) {
      setState(() => isButtonEnabled = isValid);
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> selectDateFor(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      controller.text =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 35,
        title: const Text(
          "Set Up Profile",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        foregroundColor: AppColors.pureWhite,
        backgroundColor: AppColors.electricTeal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: pickProfileImage,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: AppColors.electricTeal.withOpacity(0.4),
                  backgroundImage: profileImage != null
                      ? FileImage(File(profileImage!.path))
                      : null,
                  child: profileImage == null
                      ? const Icon(
                          Icons.person_outline,
                          size: 50,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Profile Picture",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // First Name
              CustomAnimatedTextField(
                controller: firstNameController,
                focusNode: firstNameFocus,
                labelText: "First Name",
                hintText: "First Name",
                prefixIcon: Icons.person_outline,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                validator: (v) =>
                    AppValidators.name(v, fieldName: "First Name"),
              ),
              const SizedBox(height: 10),

              // Last Name
              CustomAnimatedTextField(
                controller: lastNameController,
                focusNode: lastNameFocus,
                labelText: "Last Name",
                hintText: "Last Name",
                prefixIcon: Icons.person_outline,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                validator: (v) => AppValidators.name(v, fieldName: "Last Name"),
              ),
              const SizedBox(height: 10),

              // Mobile
              CustomAnimatedTextField(
                controller: mobileController,
                focusNode: mobileFocus,
                labelText: "Mobile Number",
                hintText: "Mobile Number",
                prefixIcon: Icons.phone_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.phone,
                validator: AppValidators.phone,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(Icons.credit_card_sharp),
                  SizedBox(width: 10),
                  const Text(
                    "SA Compliance (PrDP)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // PrDP Number
              CustomAnimatedTextField(
                controller: prdpNumberController,
                focusNode: prdpNumberFocus,
                labelText: "PrDP Number",
                hintText: "PrDP Number",
                prefixIcon: Icons.phone_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.phone,
                validator: AppValidators.prdpNumber,
              ),
              const SizedBox(height: 10),

              // PrDP Expiry Date
              CustomAnimatedTextField(
                controller: prdpExpiryController,
                focusNode: prdpExpiryFocus,
                labelText: "PrDP Expiry Date",
                hintText: "yyyy-mm-dd",
                prefixIcon: Icons.calendar_today_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: Colors.black87,
                keyboardType: TextInputType.datetime,
                validator: AppValidators.dob,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  color: AppColors.electricTeal,
                  onPressed: () => selectDateFor(prdpExpiryController),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(Icons.co_present_rounded),
                  SizedBox(width: 10),
                  const Text(
                    "License Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // License Number
              CustomAnimatedTextField(
                controller: licenseNumberController,
                focusNode: licenseNumberFocus,
                labelText: "License Number",
                hintText: "License Number",
                prefixIcon: Icons.phone_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.phone,
                validator: AppValidators.licenseNumber,
              ),
              const SizedBox(height: 10),

              // Modal popup style dropdown
              DropDownContainer(
                fw: FontWeight.normal,
                text: "License Category",
                dialogueScreen: MaterialConditionPopupLeftIcon(
                  title: "Select License Category",
                  conditions: licenseCategories,
                  initialSelectedIndex: 0,
                  onSelect: (index, value) {
                    print("Selected: $value");
                  },
                ),
              ),

              const SizedBox(height: 30),

              //License Expiry
              CustomAnimatedTextField(
                controller: licenseExpiryController,
                focusNode: licenseExpiryFocus,
                labelText: "License Expiry",
                hintText: "yyyy-mm-dd",
                prefixIcon: Icons.calendar_today_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: Colors.black87,
                keyboardType: TextInputType.datetime,
                validator: (v) =>
                    AppValidators.expiryDate(v, field: "License Expiry"),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  color: AppColors.electricTeal,
                  onPressed: () => selectDateFor(licenseExpiryController),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(Icons.call),
                  SizedBox(width: 10),
                  const Text(
                    "Emergency Contact",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // DOB
              CustomAnimatedTextField(
                controller: dobController,
                focusNode: dobFocus,
                labelText: "Date of Birth",
                hintText: "mm/dd/yyyy",
                prefixIcon: Icons.calendar_today_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: Colors.black87,
                keyboardType: TextInputType.datetime,
                validator: AppValidators.dob,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  color: AppColors.electricTeal,
                  onPressed: selectDate,
                ),
              ),
              const SizedBox(height: 10),

              // Emergency Contact Name
              CustomAnimatedTextField(
                controller: emergencyNameController,
                focusNode: emergencyNameFocus,
                labelText: "Emergency Contact Name",
                hintText: "Emergency Contact Name",
                prefixIcon: Icons.phone_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    AppValidators.name(v, fieldName: "Emergency Contact Name"),
              ),
              const SizedBox(height: 10),

              // Emergency Contact Phone
              CustomAnimatedTextField(
                controller: emergencyPhoneController,
                focusNode: emergencyPhoneFocus,
                labelText: "Emergency Contact Phone",
                hintText: "Emergency Contact Phone",
                prefixIcon: Icons.phone_outlined,
                iconColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.mediumGray,
                keyboardType: TextInputType.phone,
                validator: AppValidators.phone,
              ),

              const SizedBox(height: 30),

              // Next Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "Submit",
                  backgroundColor: isButtonEnabled
                      ? AppColors.electricTeal
                      : AppColors.lightGrayBackground,
                  borderColor: isButtonEnabled
                      ? AppColors.lightGrayBackground
                      : AppColors.electricTeal,
                  textColor: isButtonEnabled
                      ? AppColors.lightGrayBackground
                      : AppColors.electricTeal,
                  onPressed: isButtonEnabled
                      ? () => context.go("/register-success")
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
