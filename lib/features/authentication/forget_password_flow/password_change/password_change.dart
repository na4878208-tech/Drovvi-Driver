import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/bottom_show.dart';
import '../../../../constants/validation_regx.dart';
import '../../../../export.dart';
import 'password_change_controller.dart';
import 'password_change_modal.dart';

class ResetPasswordChangeScreen extends StatefulWidget {
  final String email;
  final String resetToken;

  const ResetPasswordChangeScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordChangeScreen> createState() =>
      _ResetPasswordChangeScreenState();
}

class _ResetPasswordChangeScreenState extends State<ResetPasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confrompasswordFocus.dispose();
    super.dispose();
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🔙 Back
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: AppColors.electricTeal,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomText(
                  txt: "DROVVI",
                  color: AppColors.electricTeal,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 40),
                CustomText(
                  txt: "Reset Password",
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

                // ---------------- SUBMIT BUTTON ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(resetPasswordControllerProvider);

                      ref.listen<AsyncValue<ResetPasswordModel?>>(
                        resetPasswordControllerProvider,
                        (_, state) {
                          state.when(
                            data: (data) {
                              if (data != null && data.success) {
                                if (!mounted) return;

                                AppSnackBar.showSuccess(context, data.message);
                                context.go('/login');
                              }
                            },
                            loading: () {},
                            error: (e, st) {
                              AppSnackBar.showError(context, e.toString());
                            },
                          );
                        },
                      );

                      return CustomButton(
                        isChecked: _isFormValid,
                        text: state is AsyncLoading
                            ? "Resetting..."
                            : "Reset Password",
                        backgroundColor: _isFormValid
                            ? AppColors.electricTeal
                            : inactiveColor,
                        borderColor: AppColors.electricTeal,
                        textColor: AppColors.lightGrayBackground,
                        onPressed: _isFormValid
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(
                                        resetPasswordControllerProvider
                                            .notifier,
                                      )
                                      .resetPassword(
                                        resetToken:
                                            widget.resetToken, // ✅ FIXED
                                        password: newPasswordController.text
                                            .trim(),
                                        passwordConfirmation:
                                            confirmPasswordController.text
                                                .trim(),
                                      );
                                }
                              }
                            : null,
                      );
                    },
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
