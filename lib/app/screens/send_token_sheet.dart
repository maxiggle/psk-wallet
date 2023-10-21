import 'dart:developer';

import 'package:easy_container/easy_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

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
  String hintText = "0x0000000000000000000000000000000000000000";

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
  Widget build(BuildContext context) {
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
                fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
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
                  Row(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      Text('To',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: font19,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  AddressBar(
                      textEditingController: _contactController,
                      hintText: hintText),
                  SizedBox(
                    height: 50.h,
                  ),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 25),
                  //   child: TextFormField(
                  //     controller: _amountController,
                  //     keyboardType:
                  //         const TextInputType.numberWithOptions(decimal: true),
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.allow(
                  //           RegExp(r'^\.?\d*(?<!\.)\.?\d*'))
                  //     ],
                  //     style: const TextStyle(fontFamily: 'Inter', fontSize: 25),
                  //     textAlign: TextAlign.center,
                  //     decoration: const InputDecoration(),
                  //     onChanged: (val) {},
                  //   ),
                  // ),
                  EasyContainer(
                    height: 85.h,
                    elevation: 0,
                    customMargin: const EdgeInsets.only(left: 100, right: 100),
                    child: TextFormField(
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
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Value should be less than or equal to 100',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            );
                          }
                        },
                        textAlign: TextAlign.center,
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          focusColor: black,
                          hintText: '0.0',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        cursorColor: black,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\.?\d*(?<!\.)\.?\d*'))
                        ]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      elevation: 0,
                      backgroundColor: lightGreen,
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: black,
                          fontFamily: 'Inter',
                          fontSize: font19,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
