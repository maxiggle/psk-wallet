import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:variancewallet/app/providers/home_provider.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:variancewallet/app/screens/token_balance.dart';
import 'package:variancewallet/app/screens/transaction.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';
import 'package:variancewallet/utils/globals.dart';
import 'package:variancewallet/utils/quick_send.dart';
import 'package:web3dart/web3dart.dart';

bool isNotOpen = false;

final List<String> items = [
  'Item1',
  'Item2',
  'Item3',
  'Item4',
];

class HomePage extends StatefulWidget {
  final EtherAmount? balance;

  const HomePage({
    super.key,
    required this.balance,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedValue = items.first;

  late final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (HomeProvider provider) => provider.isLoading,
    );
    final token = context.select(
      (HomeProvider provider) => provider.token,
    );
    final wallet = context.select(
      (WalletProvider provider) => provider.wallet,
    );
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                          horizontal: symmetricPadding,
                          vertical: symmetricPadding)
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
                                        borderRadius:
                                            BorderRadius.circular(70.591),
                                      ),
                                      child: SvgPicture.network(context
                                          .read<WalletProvider>()
                                          .wallet
                                          .address
                                          .diceAvatar())),
                                  const SizedBox(
                                    width: 14.6,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 25.56.h / 2),
                                      Text(
                                        wallet.address
                                            .formattedAddress(length: 4),
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
                                    'ETH ${widget.balance?.getInEther}',
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
                                      '+\$0',
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
                      TokenBalance(tokenData: token),
                      SizedBox(
                        height: 24.h,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius).r),
                        elevation: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(
                                  23.13, 21.91, 21.91, 9.74)
                              .r,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 37.73,
                                    height: 37.73,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(radius),
                                        color: ash),
                                    padding: const EdgeInsets.fromLTRB(
                                            12.7, 13.39, 12.7, 13.39)
                                        .r,
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/transx.png'),
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
                                          borderRadius:
                                              BorderRadius.circular(100).w),
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
                              const Transactions(),
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

    final homeProvider = context.read<HomeProvider>();
    homeProvider.getData();

    final saved = context.read<WalletProvider>();
    saved.getString('passKey');
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) {
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
                onPressed: () async {
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
      },
    );
  }
}
