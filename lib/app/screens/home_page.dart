import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pkswallet/const.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String dropdownValue = 'USDC';
final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
];
String? selectedValue;
bool isNotOpen = false; 


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    log(isNotOpen.toString());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
                  horizontal: symmetricPadding, vertical: symmetricPadding)
              .r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: appBarItemsH.h * 1.18,
                    width: appBarItemsW.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70.591),
                    ),
                    child: const Image(
                        image: AssetImage('assets/images/profile.jpg')),
                  ),
                  const SizedBox(
                    width: 14.6,
                  ),
                  Column(
                    children: [
                      SizedBox(height: 25.56.h / 2),
                      Text(
                        'Hey, Jazie',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: font19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Welcome back',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: font12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffB2B2B2)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(20.69).r,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(style: BorderStyle.solid)),
                    child: SvgPicture.asset(
                      'assets/images/settings.svg',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 38.95.h),
              Row(
                children: [
                  SizedBox(
                    width: 17.04.w,
                  ),
                  const Text('All Account'),
                  SizedBox(
                    width: 4.w,
                  ),
                  Container(
                    height: 5.h,
                    width: 5.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10).r,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  const Text('Total balance'),
                  const Spacer(),
                  Container(
                    // color: Colors.red,
                    height: 18.h,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        onMenuStateChange: (isOpen) {
                          if (isOpen == true) {
                            setState(() {
                              isNotOpen = true;
                            });
                          } else {
                            setState(() {
                              isOpen == false;
                            });
                          }
                        },
                        iconStyleData: IconStyleData(
                          icon: isNotOpen
                              ? Icon(Icons.access_alarm)
                              : Icon(Icons.abc_rounded),
                          // openMenuIcon:,
                        ),
                        hint: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 140,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
