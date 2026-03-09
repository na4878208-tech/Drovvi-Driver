
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';
import '../../../constants/validation_regx.dart';
import '../../../export.dart';
import 'login_controller.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showEye = false;
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_passwordListener);
    emailController.addListener(_checkFormFilled);
    passwordController.addListener(_checkFormFilled);
  }

  void _passwordListener() {
    setState(() => _showEye = passwordController.text.isNotEmpty);
  }

  void _checkFormFilled() {
    final isFilled =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    final isValid =
        AppValidators.email(emailController.text) == null &&
        AppValidators.password(passwordController.text) == null;
    setState(() => _isFormFilled = isFilled && isValid);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final Color inactiveColor = AppColors.mediumGray;

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "DROVVI",
                  style: TextStyle(
                    color: AppColors.electricTeal,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                gapH32,
                CustomAnimatedTextField(
                  controller: emailController,
                  focusNode: emailFocus,
                  labelText: "Email ID",
                  hintText: "Email ID",
                  prefixIcon: Icons.email_outlined,
                  iconColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.mediumGray,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email, // 🔥 VALIDATION APPLIED
                ),
                gapH12,
                // ---------------- PASSWORD FIELD ----------------
                CustomAnimatedTextField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  labelText: "Password",
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline,
                  iconColor: AppColors.electricTeal,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.mediumGray,
                  obscureText: _obscurePassword,
                  validator: AppValidators.password, // 🔥 VALIDATION APPLIED
                  suffixIcon: _showEye
                      ? IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )
                      : null,
                ),

                gapH24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push("/forget-password");
                      },
                      child: CustomText(
                        txt: "Forget Password",
                        color: AppColors.electricTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                gapH32,
                CustomButton(
                  isChecked: _isFormFilled,
                  text: state is AsyncLoading ? "Signing In..." : "Sign In",
                  backgroundColor: _isFormFilled
                      ? AppColors.electricTeal
                      : inactiveColor,
                  borderColor: AppColors.electricTeal,
                  textColor: AppColors.lightGrayBackground,
                  onPressed: _isFormFilled
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(loginControllerProvider.notifier)
                                .login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );

                            final loginState = ref.read(
                              loginControllerProvider,
                            );
                            if (loginState is AsyncData &&
                                loginState.value != null) {
                              context.go("/home"); // Navigate to home
                            } else if (loginState is AsyncError) {

                              AppSnackBar.showError(context, "Invalid email or password");
                            }
                          }
                        }
                      : null,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
