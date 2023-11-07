import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';
import 'package:variancewallet/utils/firebase_helpers.dart';


class PinCodeVerificationScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';
  final String? phoneNumber;

  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;
  FocusNode pinPutFocusNode = FocusNode();

  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;

  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    scrollController = ScrollController();
    errorController = StreamController<ErrorAnimationType>();
    pinPutFocusNode.addListener(() {
      if (pinPutFocusNode.hasFocus) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    errorController?.close();
    pinPutFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // snackBar Widget
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FirebasePhoneAuthHandler(
      phoneNumber: widget.phoneNumber ?? "+2348144734001",
      signOutOnSuccessfulVerification: false,
      sendOtpOnInitialize: true,
      linkWithExistingUser: false,
      autoRetrievalTimeOutDuration: const Duration(seconds: 60),
      otpExpirationDuration: const Duration(seconds: 60),
      onCodeSent: () {
        log(PinCodeVerificationScreen.id, msg: 'OTP sent!');
      },
      onLoginSuccess: (userCredential, autoVerified) async {
        log(
          PinCodeVerificationScreen.id,
          msg: autoVerified
              ? 'OTP was fetched automatically!'
              : 'OTP was verified manually!',
        );

        showSnackBar('Phone number verified successfully!');

        log(
          PinCodeVerificationScreen.id,
          msg: 'Login Success UID: ${userCredential.user?.uid}',
        );

        context.pushNamed(
          '/home',
        );
      },
      onLoginFailed: (authException, stackTrace) {
        log(
          PinCodeVerificationScreen.id,
          msg: authException.message,
          error: authException,
          stackTrace: stackTrace,
        );

        switch (authException.code) {
          case 'invalid-phone-number':
            // invalid phone number
            showSnackBar('Invalid phone number!');
            break; // Add a break statement here to prevent falling through to the default case.
          case 'invalid-verification-code':
            // invalid otp entered
            showSnackBar('The entered OTP is invalid!');
            break; // Add a break statement here to prevent falling through to the default case.
          default:
            showSnackBar('Something went wrong!');
        }
      },
      onError: (error, stackTrace) {
        log(
          PinCodeVerificationScreen.id,
          error: error,
          stackTrace: stackTrace,
        );

        showSnackBar('An error occurred!');
      },
      builder: (context, controller) {
        final timeLeft = controller.otpExpirationTimeLeft;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: ListView(controller: scrollController, children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0).r,
                  child: Text(
                    'Phone Number Verification',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: font51.sp,
                        fontFamily: 'Inter',
                        color: black),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30).r,
                  child: RichText(
                    selectionColor: Colors.black,
                    text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                          text: widget.phoneNumber,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 100.h),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 15,
                    ).r,
                    child: PinCodeTextField(
                      focusNode: pinPutFocusNode,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8).w,
                        fieldHeight: 75.h,
                        fieldWidth: 60.w,
                        activeFillColor: lightGreen,
                        inactiveFillColor: Colors.transparent,
                        activeColor: Colors.black,
                        inactiveColor: Colors.black.withOpacity(0.3),
                        selectedColor: Colors.black.withOpacity(0.3),
                        selectedFillColor: white,
                      ),
                      cursorColor: lightGreen,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    ),
                  ),
                ),
                // 67

                SizedBox(
                  height: MediaQuery.of(context).size.height / 100.h,
                ),
                Text(
                  "RESEND it in ${timeLeft.inMinutes} min",
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: 14.sp,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10.h,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30)
                          .r,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(100).w,
                  ),
                  child: ButtonTheme(
                    // height: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100).w),
                    child: TextButton(
                      onPressed: () async {
                        formKey.currentState?.validate();
                        final validOtp =
                            await controller.verifyOtp(currentText);
                        // conditions for validating
                        if (currentText.length != 6 || !validOtp) {
                          errorController?.add(ErrorAnimationType.shake);
                          setState(() => hasError = true);
                        } else {
                          setState(
                            () {
                              hasError = false;
                              showSnackBar("OTP Verified!!");
                              context.go('/CreateAccountScreen',
                                  extra: widget.phoneNumber);
                            },
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          "VERIFY".toUpperCase(),
                          style: TextStyle(
                            color: black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
              ],
            ),
          ]),
        );
      },
    ));
  }
}
