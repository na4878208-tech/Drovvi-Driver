import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/validation_regx.dart';
import '../../../../export.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>(); // 🔥 ADD THIS

  final passwordFocus = FocusNode();
  final confrompasswordFocus = FocusNode();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureNewPass = true;
  bool _obscureConPass = true;

  bool _showNewPassEye = false;
  bool _showConPassEye = false;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    newPasswordController.addListener(() {
      _validateForm();
      // Show eye icon only if text is not empty
      setState(() {
        _showNewPassEye = newPasswordController.text.isNotEmpty;
      });
    });

    confirmPasswordController.addListener(() {
      _validateForm();
      setState(() {
        _showConPassEye = confirmPasswordController.text.isNotEmpty;
      });
    });
  }

  void _validateForm() {
    final newPassError = AppValidators.newPassword(newPasswordController.text);
    final confirmPassError = AppValidators.confirmPassword(
      confirmPasswordController.text,
      newPasswordController.text,
    );

    final isValid = newPassError == null && confirmPassError == null;

    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = AppColors.mediumGray;
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey, // 🔥 IMPORTANT
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                CustomText(
                  txt: "DROVVI",
                  color: AppColors.electricTeal,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 40),

                CustomText(
                  txt: "Password Change",
                  color: AppColors.electricTeal,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 10),

                CustomText(
                  txt:
                      "Set your password so you can Log In\nand access Resolve",
                  align: TextAlign.center,
                  color: AppColors.mediumGray,
                  fontSize: 14,
                  height: 1.5,
                ),

                const SizedBox(height: 35),

                // ---------------- NEW PASSWORD ----------------
                CustomAnimatedTextField(
                  controller: newPasswordController,
                  focusNode: passwordFocus,
                  labelText: "New Password",
                  hintText: "New Password",
                  prefixIcon: Icons.lock_outline,
                  iconColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.darkText,
                  obscureText: _obscureNewPass,
                  suffixIcon: _showNewPassEye
                      ? IconButton(
                          icon: Icon(
                            _obscureNewPass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.darkText,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPass = !_obscureNewPass;
                            });
                          },
                        )
                      : null,

                  /// 🔥 VALIDATOR APPLY
                  validator: (value) => AppValidators.newPassword(value),
                ),

                const SizedBox(height: 20),

                // ---------------- CONFIRM PASSWORD ----------------
                CustomAnimatedTextField(
                  controller: confirmPasswordController,
                  focusNode: confrompasswordFocus,
                  labelText: "Confirm Password",
                  hintText: "Confirm Password",
                  prefixIcon: Icons.lock_outline,
                  iconColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.darkText,
                  obscureText: _obscureConPass,
                  suffixIcon: _showConPassEye
                      ? IconButton(
                          icon: Icon(
                            _obscureConPass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.darkText,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConPass = !_obscureConPass;
                            });
                          },
                        )
                      : null,

                  validator: (value) => AppValidators.confirmPassword(
                    value,
                    newPasswordController.text,
                  ),
                ),

                const SizedBox(height: 64),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    isChecked:
                        _isFormValid, // ✅ use validation instead of just filled
                    text: "Change Password",
                    backgroundColor: _isFormValid
                        ? AppColors.electricTeal
                        : inactiveColor,
                        borderColor: AppColors.electricTeal,
                    textColor: AppColors.lightGrayBackground,
                    onPressed: _isFormValid
                        ? () {
                            context.go('/login'); // ✅ Only when form valid
                          }
                        : null,
                  ),
                  
                ),

                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
