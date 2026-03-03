import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../export.dart';
export '../../../common_widgets/cuntom_textfield.dart';
export '../../../common_widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController carnumberController = TextEditingController();
  final TextEditingController LicenseController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final FocusNode carnumberFocus = FocusNode();
  final FocusNode LicenseFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  bool isChecked = false;
  XFile? profileImage;

  final ImagePicker _picker = ImagePicker();

  void checkFields() {
    setState(() {
      isChecked =
          carnumberController.text.isNotEmpty &&
          LicenseController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty;
    });
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carnumberController.addListener(checkFields);
    LicenseController.addListener(checkFields);
    emailController.addListener(checkFields);
    phoneController.addListener(checkFields);
  }

  @override
  void dispose() {
    carnumberController.dispose();
    LicenseController.dispose();
    emailController.dispose();
    phoneController.dispose();
    carnumberFocus.dispose();
    LicenseFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () {
            context.go("/profile");
          },
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Profile Picture Section
            GestureDetector(
              onTap: pickProfileImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Circle (border + image)
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricTeal,
                        width: 2.5,
                      ),
                      color: profileImage == null
                          ? AppColors.electricTeal.withOpacity(0.4)
                          : Colors.transparent,
                      image: profileImage != null
                          ? DecorationImage(
                              image: FileImage(File(profileImage!.path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 0,
                            color: AppColors.electricTeal,
                          )
                        : null,
                  ),

                  //  Blue overlay icon (only visible when no image is selected)
                  if (profileImage == null)
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.electricTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outlined,
                        color: AppColors.pureWhite,
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Profile Picture",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 20),

            //  email Number
            CustomAnimatedTextField(
              controller: phoneController,
              focusNode: phoneFocus,
              labelText: "Phone Number",
              hintText: "Phone Number",
              prefixIcon: Icons.phone_outlined,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            CustomAnimatedTextField(
              controller: emailController,
              focusNode: emailFocus,
              labelText: "Email Address",
              hintText: "Email Address",
              prefixIcon: Icons.phone_outlined,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 10),

            //  Car Number
            CustomAnimatedTextField(
              controller: carnumberController,
              focusNode: carnumberFocus,
              labelText: "Car Number",
              hintText: "Car Number",
              prefixIcon: Icons.person_outline,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
            ),
            const SizedBox(height: 10),

            // License
            CustomAnimatedTextField(
              controller: LicenseController,
              focusNode: LicenseFocus,
              labelText: "License",
              hintText: "License",
              prefixIcon: Icons.person_outline,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
            ),

            const SizedBox(height: 30),

            //  Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                isChecked: isChecked,
                text: "Updated",
                backgroundColor: AppColors.electricTeal,
                borderColor: AppColors.electricTeal,
                textColor: AppColors.lightGrayBackground,
                onPressed: () {
                  if (isChecked) {
                    context.go("/profile");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
