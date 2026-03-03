import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/constants/colors.dart';

import '../../../export.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentpasswordFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confrompasswordFocus = FocusNode();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureNewPass = true;
  bool _obscureConPass = true;

  bool _showNewPassEye = false;
  bool _showConPassEye = false;

  @override
  void initState() {
    super.initState();
    currentPasswordController.addListener(_currentPasswordListener);
    newPasswordController.addListener(_newPasswordListener);
    confirmPasswordController.addListener(_confirmPasswordListener);
  }

  void _currentPasswordListener() {
    final shouldShow = currentPasswordController.text.isNotEmpty;
    if (shouldShow != _showNewPassEye) {
      setState(() => _showNewPassEye = shouldShow);
    }
  }

  void _newPasswordListener() {
    final shouldShow = newPasswordController.text.isNotEmpty;
    if (shouldShow != _showNewPassEye) {
      setState(() => _showNewPassEye = shouldShow);
    }
  }

  void _confirmPasswordListener() {
    final shouldShow = confirmPasswordController.text.isNotEmpty;
    if (shouldShow != _showConPassEye) {
      setState(() => _showConPassEye = shouldShow);
    }
  }

  @override
  void dispose() {
    currentPasswordController.removeListener(_currentPasswordListener);
    newPasswordController.removeListener(_newPasswordListener);
    confirmPasswordController.removeListener(_confirmPasswordListener);
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    currentpasswordFocus.dispose();
    passwordFocus.dispose();
    confrompasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              /// Subtitle
              CustomText(
                txt: "Change your password so you can secure\nYour Account",
                align: TextAlign.center,
                color: AppColors.mediumGray,
                fontSize: 14,
                height: 1.5,
              ),

              const SizedBox(height: 35),

              /// Current Password Field
              CustomAnimatedTextField(
                controller: currentPasswordController,
                focusNode: currentpasswordFocus,
                labelText: "Current Password",
                hintText: "Current Password",
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
              ),

              const SizedBox(height: 20),

              /// New Password Field
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
              ),

              const SizedBox(height: 20),

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
              ),

              gapH64,

              /// Sign Up Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: "Change Password",
                  backgroundColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.pureWhite,
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: 35),

              /// Password Policy
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Password Policy:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.darkText,
                      ),
                    ),
                    SizedBox(height: 10),
                    _PolicyItem(text: "Length must between 8 to 20 character"),
                    _PolicyItem(
                      text: "A combination of upper and lower case letters.",
                    ),
                    _PolicyItem(text: "Contain letters and numbers"),
                    _PolicyItem(
                      text: "A special character such as @, #, !, * and \$",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable Policy Item Widget
class _PolicyItem extends StatelessWidget {
  final String text;
  const _PolicyItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.electricTeal,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
              txt: text,
              color: AppColors.mediumGray,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
