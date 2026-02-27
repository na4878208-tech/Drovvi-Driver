// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:logisticdriverapp/constants/colors.dart';

// import '../../../constants/validation_regx.dart';
// import '../../../export.dart';

// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});

//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   final emailFocus = FocusNode();
//   final TextEditingController emailController = TextEditingController();

//   /// ---- FORM KEY ----
//   final _formKey = GlobalKey<FormState>();

//   bool _isFormFilled = false;

//   @override
//   void initState() {
//     super.initState();
//     emailController.addListener(_checkFormFilled);
//   }

//   void _checkFormFilled() {
//     final isFilled = emailController.text.isNotEmpty;

//     final isValid = AppValidators.email(emailController.text) == null;

//     final enableButton = isFilled && isValid;

//     if (enableButton != _isFormFilled) {
//       setState(() => _isFormFilled = enableButton);
//     }
//   }

//   @override
//   void dispose() {
//     emailFocus.dispose();
//     emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Color inactiveColor = AppColors.mediumGray;

//     return Scaffold(
//       backgroundColor: AppColors.lightGrayBackground,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),

//           /// ---- FORM WRAPPER ----
//           child: Form(
//             key: _formKey,

//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Drovvi",
//                   style: TextStyle(
//                     color: AppColors.electricTeal,
//                     fontSize: 50,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 gapH32,
//                 Text(
//                   "Forgot Password",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.electricTeal,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Please enter your Register email\naddress to reset your password",
//                   style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//                 gapH20,

//                 /// ---------- EMAIL FIELD ----------
//                 CustomAnimatedTextField(
//                   controller: emailController,
//                   focusNode: emailFocus,
//                   labelText: "Email ID",
//                   hintText: "Email ID",
//                   prefixIcon: Icons.email_outlined,
//                   iconColor: AppColors.electricTeal,
//                   borderColor: AppColors.electricTeal,
//                   textColor: AppColors.mediumGray,
//                   keyboardType: TextInputType.emailAddress,

//                   /// ---- Validator from AppValidators ----
//                   validator: AppValidators.email,
//                 ),

//                 const SizedBox(height: 300),

//                 /// ---------- SUBMIT BUTTON ----------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: CustomButton(
//                     isChecked: _isFormFilled,
//                     text: "Submit",
//                     backgroundColor: _isFormFilled
//                         ? AppColors.electricTeal
//                         : inactiveColor,
//                     borderColor: AppColors.electricTeal,
//                     textColor: AppColors.lightGrayBackground,
//                     onPressed: _isFormFilled
//                         ? () {
//                             if (_formKey.currentState!.validate()) {
//                               context.go(
//                                 '/create-password',
//                               ); // ✅ Only when valid
//                             }
//                           }
//                         : null,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(data.message)));
              context.go('/otp-forget'); // Navigate on success
            }
          },
          loading: () {},
          error: (e, st) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          },
        );
      },
    );

    return Scaffold(
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
