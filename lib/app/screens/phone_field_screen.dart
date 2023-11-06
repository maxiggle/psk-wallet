import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/utils/firebase_helpers.dart';


class PhoneFieldScreen extends StatefulWidget {
  static const id = 'AuthenticationScreen';

  const PhoneFieldScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhoneFieldScreenState createState() => _PhoneFieldScreenState();
}

class _PhoneFieldScreenState extends State<PhoneFieldScreen> {
  String? phoneNumber;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12.h),
                Text(
                  "Phone Verification",
                  style: TextStyle(
                    fontSize: 43.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2.h),
                EasyContainer(
                  elevation: 0,
                  showBorder: true,
                  borderStyle: BorderStyle.solid,
                  borderColor: black,
                  height: 100.h,
                  borderRadius: 25,
                  color: Colors.transparent,
                  customPadding: EdgeInsets.all(10.r),
                  child: Form(
                    key: _formKey,
                    child: IntlPhoneField(
                      cursorColor: black,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '000-000-0000',
                        hintMaxLines: 1,
                        counter: Offstage(),
                      ),
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400),
                      onChanged: (phone) {
                        setState(() {
                          phoneNumber = phone.completeNumber;
                        });
                      },
                      initialCountryCode: 'NG',
                      flagsButtonPadding: const EdgeInsets.only(right: 10),
                      showDropdownIcon: false,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
                EasyContainer(
                  color: lightGreen,
                  borderRadius: 25,
                  customPadding: EdgeInsets.only(
                      left: 12.r, right: 12.r, top: 17.r, bottom: 17.r),
                  onTap: () async {
                    log(phoneNumber.toString());
                    if (isNullOrBlank(phoneNumber) ||
                        !_formKey.currentState!.validate()) {
                      showSnackBar('Please enter a valid phone number!');
                    } else {
                      context.push(
                        '/phone-otp',
                        extra: phoneNumber,
                      );
                    }
                  },
                  child: Text(
                    'Verify',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600),
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
