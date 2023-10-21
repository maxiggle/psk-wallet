import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:pkswallet/app/screens/token_balance.dart';
import 'package:pkswallet/app/screens/transaction.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';
import 'package:pkswallet/utils/globals.dart';
import 'package:pkswallet/utils/quick_send.dart';

bool isNotOpen = false;

final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
];

class AddressBar extends StatefulWidget {
  final String hintText;
  final TextEditingController? textEditingController;

  // Add an optional parameter for the initial value
  final String initialValue;

  const AddressBar({
    required this.hintText,
    this.textEditingController,
    this.initialValue = "0.0", // Provide a default initial value
    Key? key,
  }) : super(key: key);

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 87.63.h,
          width: 150.714.w,
          child: TextButton(
            onPressed: () {
              context.push('/send_token', extra: '');
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius / 2),
              ),
              backgroundColor: lightGreen,
            ),
            child: Text(
              'Send',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: font19.sp,
                  color: black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(
          width: 8.52,
        ),
        SizedBox(
          height: 87.63.h,
          width: 150.714.w,
          child: TextButton(
            onPressed: () {
              context.push('/receive_token');
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              backgroundColor: ash,
            ),
            child: Text(
              'Receive',
              style: TextStyle(
                  fontFamily: 'Inter', fontSize: font19.sp, color: black),
            ),
          ),
        ),
        const SizedBox(
          width: 8.52,
        ),
        SizedBox(
          height: 87.63.h,
          width: 150.714.w,
          child: TextButton(
            onPressed: () {
              Globals.auth.signOut();
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              backgroundColor: ash,
            ),
            child: SvgPicture.asset('assets/images/add.svg'),
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class TransactionData {
  final String coinImage;
  final String ensName;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime transactionTime;
  final String amount;

  TransactionData(
      {required this.coinImage,
      required this.ensName,
      required this.type,
      required this.status,
      required this.transactionTime,
      required this.amount});
}

class _AddressBarState extends State<AddressBar> {
  bool pwdVisibility = false;
  final formKey = GlobalKey<FormState>();
  late final TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the initial value
    textEditingController = widget.textEditingController ??
        TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        fillColor: ash,
        filled: true,
        hintText: widget.hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15.0)),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }
}

class _HomePageState extends State<HomePage> {
  String? selectedValue = items.first;

  late final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final List<TransactionData> transactionData = [
      TransactionData(
          transactionTime: DateTime.now(),
          amount: '\$21,553',
          coinImage: 'assets/images/ethereum.svg',
          ensName: 'Dave',
          type: TransactionType.send,
          status: TransactionStatus.pending),
      TransactionData(
          transactionTime: DateTime.now(),
          amount: '\$3',
          coinImage: 'assets/images/bitcoin.svg',
          ensName: 'Steven',
          type: TransactionType.send,
          status: TransactionStatus.success),
      TransactionData(
          transactionTime: DateTime.now(),
          amount: '\$21,553',
          coinImage: 'assets/images/ethereum.svg',
          ensName: 'Dave',
          type: TransactionType.receive,
          status: TransactionStatus.pending),
    ];
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                    horizontal: symmetricPadding, vertical: symmetricPadding)
                .r,
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48).r),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 12.74, vertical: 9.4)
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
                                  image:
                                      AssetImage('assets/images/profile.jpg')),
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
                            Expanded(
                              child: SizedBox(
                                height: 18.h,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    onMenuStateChange: (isOpen) {
                                      setState(() {
                                        isNotOpen = !isOpen;
                                      });
                                    },
                                    iconStyleData: IconStyleData(
                                        icon: isNotOpen
                                            ? SvgPicture.asset(
                                                'assets/images/inactive-dropdown.svg',
                                              )
                                            : SvgPicture.asset(
                                                'assets/images/dropdown.svg')),
                                    items: items
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      height: 40.h,
                                      width: 140.w,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: 40.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 17.04,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              '\$17,200',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: font51,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 8.4.w,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 45.3).r,
                              child: Text(
                                '+\$233',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000)
                                        .withOpacity(0.30)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 29.28.h),
                        const SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ButtonRow()),
                        SizedBox(height: 9.74.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                const QuickSend(),
                const SizedBox(
                  height: 24,
                ),
                TokenBalance(),
                SizedBox(
                  height: 24.h,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius).r),
                  elevation: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(23.13, 21.91, 21.91, 9.74).r,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 37.73,
                              height: 37.73,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(radius),
                                  color: ash),
                              padding: const EdgeInsets.fromLTRB(
                                      12.7, 13.39, 12.7, 13.39)
                                  .r,
                              child: const Image(
                                image: AssetImage('assets/images/transx.png'),
                                height: 12,
                                width: 12,
                              ),
                            ),
                            const SizedBox(
                              width: 9.74,
                            ),
                            Text(
                              'Transactions',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: font19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                                height: 36.512,
                                width: 36.512,
                                decoration: BoxDecoration(
                                    color: ash,
                                    borderRadius: BorderRadius.circular(100).w),
                                child: IconButton(
                                  onPressed: () {
                                    context.push('/transaction_details');
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20.sp,
                                  ),
                                )),
                            const SizedBox(height: 21.03),
                          ],
                        ),
                        Transactions(
                          transactionData: transactionData,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }
}
