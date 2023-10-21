import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

class TokenData {
  final String? tokenPrice;
  final String? tokenBalance;
  final String? tokenBalanceInUSD;
  final String? tokenName;
  final String? tokenSymbol;
  final String? tokenImage;

  TokenData(
      {this.tokenPrice,
      this.tokenBalance,
      this.tokenBalanceInUSD,
      this.tokenName,
      this.tokenSymbol,
      this.tokenImage});
}

class TokenBalance extends StatefulWidget {
  const TokenBalance({
    super.key,
  });

  @override
  State<TokenBalance> createState() => _TokenBalanceState();
}

class _TokenBalanceState extends State<TokenBalance>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState>? refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  static int? refreshNum = 10;
  final counterStream =
      Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum!);

  List<TokenData> token = [
    TokenData(
      tokenBalance: '0.0005ETH',
      tokenBalanceInUSD: 'US\$21,553',
      tokenName: "Ethereum",
      tokenSymbol: "ETH",
      tokenPrice: "\$1600",
      tokenImage: 'assets/images/ethereum.svg',
    ),
    TokenData(
      tokenBalance: '0.0005LTC',
      tokenBalanceInUSD: 'US\$21,553',
      tokenName: "Litecoin",
      tokenSymbol: "LTC",
      tokenPrice: "\$1600",
      tokenImage: 'assets/images/litecoin.svg',
    ),
    TokenData(
      tokenBalance: '0.0005LTC',
      tokenBalanceInUSD: 'US\$21,553',
      tokenName: "Litecoin",
      tokenSymbol: "LTC",
      tokenPrice: "\$1600",
      tokenImage: 'assets/images/litecoin.svg',
    )
  ];

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(scaffoldKey!.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              refreshIndicatorKey!.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(48).r),
          shadowColor: Colors.red,
          elevation: 0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 9.74, vertical: 26).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60).r,
                  child: Text(
                    'Crypto',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: font19,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20).r,
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
                                  borderRadius:
                                      BorderRadius.circular(radius).r),
                            ),
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 9.4.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    '${token[index].tokenImage}',
                                  ),
                                  SizedBox(
                                    width: 13.51.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${token[index].tokenName}",
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
                                        "${token[index].tokenBalance}",
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
