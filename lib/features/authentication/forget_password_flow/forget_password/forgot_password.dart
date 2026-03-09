import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/common_widgets/custom_text.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';
import 'package:logisticdriverapp/export.dart';

import '../../../../common_widgets/cuntom_textfield.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/gap.dart';
import '../../../../constants/validation_regx.dart';
import 'forget_password_controller.dart';
import 'forget_password_modal.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final emailFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkFormFilled);
  }

  _checkFormFilled() {
    final isFilled = emailController.text.isNotEmpty;
    final isValid = AppValidators.email(emailController.text) == null;
    final enableButton = isFilled && isValid;
    if (enableButton != _isFormFilled) {
      setState(() => _isFormFilled = enableButton);
    }
  }

  @override
  void dispose() {
    emailFocus.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final Color inactiveColor = AppColors.mediumGray;

    ref.listen<AsyncValue<ForgotPasswordModel?>>(
      forgotPasswordControllerProvider,
      (_, state) {
        state.when(
          data: (data) {
            if (data != null && data.success) {

              AppSnackBar.showSuccess(context, data.message);
              context.push(
                '/otp-forget',
                extra: {"email": data.data?.email, "otp": data.data?.demoOtp},
              );
            }
          },
          loading: () {},
          error: (e, st) {

            AppSnackBar.showError(context, e.toString());
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Login()),
          ),
          child: CustomText(
            txt: "Back",
            color: AppColors.electricTeal,
            fontSize: 14,
          ),
        ),
      ),
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Drovvi",
                  style: TextStyle(
                    color: AppColors.electricTeal,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                gapH32,
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electricTeal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please enter your registered email\naddress to reset your password",
                  style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                gapH20,
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
                  validator: AppValidators.email,
                ),
                const SizedBox(height: 300),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    isChecked: _isFormFilled,
                    text: state is AsyncLoading ? "Sending OTP..." : "Submit",
                    backgroundColor: _isFormFilled
                        ? AppColors.electricTeal
                        : inactiveColor,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.lightGrayBackground,
                    onPressed: _isFormFilled
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              await ref
                                  .read(
                                    forgotPasswordControllerProvider.notifier,
                                  )
                                  .sendOtp(emailController.text.trim());
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
