import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/bottom_show.dart';
import '../../../../constants/validation_regx.dart';
import '../../../../export.dart';
import 'otp_forget_controller.dart';
import 'otp_forget_modal.dart';

class OtpForgetScreen extends ConsumerStatefulWidget {
  final String email;
  final int otp;

  const OtpForgetScreen({super.key, required this.email, required this.otp});

  @override
  ConsumerState<OtpForgetScreen> createState() => _OtpForgetScreenState();
}

class _OtpForgetScreenState extends ConsumerState<OtpForgetScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _seconds = 59;
  Timer? _timer;
  bool _isOtpFilled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    otpController.addListener(_validateOtp);
  }

  void startTimer() {
    _timer?.cancel();

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
      _isOtpFilled = error == null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpVerifyState = ref.watch(otpVerifyControllerProvider);
    final isLoading = otpVerifyState.isLoading;

    ref.listen<AsyncValue<VerifyOtpModel?>>(otpVerifyControllerProvider, (
      _,
      state,
    ) {
      state.when(
        data: (data) {
          if (data != null && data.success) {
            AppSnackBar.showSuccess(context, data.message);

            context.push(
              "/change-password",
              extra: {
                "email": data.data?.email,
                "resetToken": data.data?.resetToken,
              },
            );
          }
        },
        loading: () {},
        error: (e, st) {
          AppSnackBar.showError(context, e.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
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

                          const SizedBox(height: 30),

                          CustomText(
                            txt: "Forget Verification Code",
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
                                txt: widget.email,
                                color: AppColors.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(width: 6),
                              const Icon(
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

                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            autoDismissKeyboard: true,
                            validator: (value) => AppValidators.otp(value),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 50,
                              fieldWidth: 45,
                              inactiveColor: AppColors.electricTeal.withOpacity(
                                0.3,
                              ),
                              selectedColor: AppColors.electricTeal,
                              activeColor: AppColors.electricTeal,
                              borderWidth: 1.5,
                              activeFillColor: AppColors.pureWhite,
                              inactiveFillColor: AppColors.pureWhite,
                              selectedFillColor: AppColors.pureWhite,
                            ),
                            animationDuration: const Duration(
                              milliseconds: 200,
                            ),
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
                              text: isLoading ? "Submitting..." : "Submit",
                              backgroundColor: _isOtpFilled
                                  ? AppColors.electricTeal
                                  : AppColors.mediumGray,
                              borderColor: AppColors.electricTeal,
                              textColor: AppColors.pureWhite,
                              onPressed: (_isOtpFilled && !isLoading)
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        await ref
                                            .read(
                                              otpVerifyControllerProvider
                                                  .notifier,
                                            )
                                            .verifyOtp(
                                              widget.email,
                                              otpController.text.trim(),
                                            );
                                      }
                                    }
                                  : null,
                            ),
                          ),

                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: _seconds == 0
                                ? () async {
                                    final result = await ref
                                        .read(
                                          otpVerifyControllerProvider.notifier,
                                        )
                                        .resendOtp(widget.email);

                                    if (result != null) {
                                      AppSnackBar.showSuccess(
                                        context,
                                        result.message,
                                      );

                                      setState(() {
                                        _seconds = 59;
                                      });

                                      startTimer();
                                    }
                                  }
                                : null,
                            child: CustomText(
                              txt: _seconds > 0
                                  ? "Resend - 00:${_seconds.toString().padLeft(2, '0')}"
                                  : "Resend Code",
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
