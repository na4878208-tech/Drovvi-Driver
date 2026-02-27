import 'package:flutter/material.dart';
import 'package:logisticdriverapp/features/authentication/Registration_flow/create_password.dart';
import '../../../../constants/validation_regx.dart';
import '../../../../export.dart';

class OtpRegistrationScreen extends StatefulWidget {
  const OtpRegistrationScreen({super.key});

  @override
  State<OtpRegistrationScreen> createState() => _OtpRegistrationScreenState();
}

class _OtpRegistrationScreenState extends State<OtpRegistrationScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  int _seconds = 59;
  late Timer _timer;
  bool _isOtpFilled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    otpController.addListener(_validateOtp);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _validateOtp() {
    final error = AppValidators.otp(otpController.text);
    setState(() {
      _isOtpFilled = error == null; // Only true if OTP is valid
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = AppColors.mediumGray;

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey, // Wrap OTP field in form
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
                const SizedBox(height: 30),
                CustomText(
                  txt: "Registration Verification Code",
                  color: AppColors.electricTeal,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 10),
                CustomText(
                  txt:
                      "Please enter the 6-digit code we sent\nto your registered email address.",
                  align: TextAlign.center,
                  color: AppColors.mediumGray,
                  fontSize: 14,
                  height: 1.5,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      txt: "john@example.com",
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.electricTeal,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    txt: "Verification code",
                    color: AppColors.electricTeal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                // ---------------- OTP FIELD ----------------
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  autoDismissKeyboard: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    inactiveColor: AppColors.electricTeal.withOpacity(0.3),
                    selectedColor: AppColors.electricTeal,
                    activeColor: AppColors.electricTeal,
                    activeFillColor: AppColors.pureWhite,
                    inactiveFillColor: AppColors.pureWhite,
                    selectedFillColor: AppColors.pureWhite,
                    borderWidth: 1.5,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                  enableActiveFill: true,
                  onChanged: (value) {
                    setState(() {
                      _isOtpFilled = AppValidators.otp(value) == null;
                    });
                  },
                ),

                const SizedBox(height: 64),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    isChecked: _isOtpFilled,
                    text: "Submit",
                    backgroundColor:
                        _isOtpFilled ? AppColors.electricTeal : inactiveColor,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.pureWhite,
                    onPressed: _isOtpFilled
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreatePasswordScreen()),
                              );
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                CustomText(
                  txt: _seconds > 0
                      ? "Resend - 00:${_seconds.toString().padLeft(2, '0')}"
                      : "Resend Code",
                  color: AppColors.mediumGray,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
