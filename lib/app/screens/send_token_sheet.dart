import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:variancewallet/app/screens/address_bar.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';
import 'package:variancewallet/utils/tokenData.dart';

class SendTokenSheet extends StatefulWidget {
  final String? contactName;
  const SendTokenSheet({
    this.contactName,
    super.key,
  });

  @override
  State<SendTokenSheet> createState() => _SendTokenSheetState();
}

class _SendTokenSheetState extends State<SendTokenSheet> {
  String? selectedValue;
  // String hintText = "0x0000000000000000000000000000000000000000";

  late TextEditingController _contactController;
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _contactController =
        TextEditingController(text: widget.contactName ?? 'No user selected');
    _contactController.addListener(() {
      setState(() {});
      _amountController.value = TextEditingValue(
        selection: TextSelection.fromPosition(const TextPosition(offset: 30)),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _contactController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Send Token',
            style: TextStyle(
              color: black,
              fontFamily: 'Inter',
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(_).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0).r,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.89.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  AddressBar(
                    textEditingController: _contactController,
                    hintText: 'Enter Address',
                    hintTextStyle:
                        TextStyle(fontFamily: 'Inter', fontSize: font19),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  SendTokenButton(
                    buttonText: selectedValue ?? 'Select Token',
                    color: ash,
                    buttonTextStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: font19,
                        color: Colors.grey.shade600),
                    onPressed: () {
                      TokenModal(_);
                    },
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  TextFormField(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 51.sp,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                      key: _formKey,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        } else if (int.parse(value) > 100) {
                          return 'Value should be less than or equal to 100';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (int.parse(value) > 100) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                'Value should be less than or equal to 100',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                      },
                      textAlign: TextAlign.center,
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusColor: white,
                        hintText: '0.0',
                        hintStyle:
                            const TextStyle(fontFamily: 'Inter', fontSize: 51),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      cursorColor: black,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\.?\d*(?<!\.)\.?\d*'),
                        )
                      ]),
                  Expanded(child: Container()),
                  SendTokenButton(
                    buttonText: 'Send',
                    color: lightGreen,
                    buttonTextStyle: TextStyle(
                        color: black, fontFamily: 'Inter', fontSize: font19.sp),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> TokenModal(BuildContext _) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: _,
        builder: (context) {
          return Wrap(children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(23.31, 24.34, 13.51, 24.34).r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius / 2),
                  topRight: Radius.circular(radius / 2),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9.74).r,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ash,
                            padding: const EdgeInsets.fromLTRB(
                                    23.31, 24.34, 13.51, 24.34)
                                .r,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radius).r),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedValue = token[index].contractName;
                            });
                            context.pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 9.4.w),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  '${token[index].logoUrl}',
                                ),
                                SizedBox(
                                  width: 13.51.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${token[index].contractName}",
                                      style: TextStyle(
                                          fontSize: font14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          color: black),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      "${token[index].tokenBalanceInUSD}",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: font14,
                                          fontWeight: FontWeight.w600,
                                          color: black),
                                    ),
                                    SizedBox(height: 3.91.h),
                                    Text(
                                      "${token[index].balance}",
                                      style: TextStyle(
                                        color: black.withOpacity(0.30),
                                        fontFamily: 'Inter',
                                        fontSize: font14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: token.length,
              ),
            ),
          ]);
        });
  }
}

class SendTokenButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;
  final Color? color;
  final TextStyle? buttonTextStyle;
  const SendTokenButton(
      {super.key,
      required this.buttonText,
      this.onPressed,
      this.color,
      this.buttonTextStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(23.31, 24.34, 13.51, 24.34).r,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
        backgroundColor: color,
      ),
      child: Text(buttonText, style: buttonTextStyle),
    );
  }
}
