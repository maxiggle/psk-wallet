import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'dart:async';

import 'package:pkswallet/app/theme/colors.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  final String? phoneNumber;

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;

  late final ScrollController scrollController;

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

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    errorController!.close();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    isKeyboardVisible = keyboardHeight > 0;
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 6.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0).r,
              child: Text(
                'Phone Number Verification',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    fontFamily: 'Inter',
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 8).r,
              child: RichText(
                selectionColor: Colors.white,
                text: TextSpan(
                  text: "Enter the code sent to ",
                  children: [
                    TextSpan(
                      text: "XXX XXXX XXXX",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                  style: TextStyle(
                    color: Colors.white,
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
                    borderRadius: BorderRadius.circular(12).w,
                    fieldHeight: 70.h,
                    fieldWidth: 60.w,
                    activeFillColor: lightGreen,
                    inactiveFillColor: ash.withOpacity(0.3),
                    activeColor: Colors.black,
                    inactiveColor: Colors.black,
                    selectedColor: black,
                    selectedFillColor: ash.withOpacity(0.3),
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
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
            ),
            // 67
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Inter'),
                ),
                TextButton(
                  onPressed: () => snackBar("OTP resend!!"),
                  child: Text(
                    "RESEND",
                    style: TextStyle(
                      color: lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 14.sp,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 6.h,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30).r,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(100).w,
              ),
              child: ButtonTheme(
                // height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100).w),
                child: TextButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                    // conditions for validating
                    if (currentText.length != 6 || currentText != "123456") {
                      errorController!.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() => hasError = true);
                    } else {
                      setState(
                        () {
                          hasError = false;
                          snackBar("OTP Verified!!");
                          context.go('/home');
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
      ),
    );
  }
}
