import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const TokenBalance({super.key});

  @override
  State<TokenBalance> createState() => _TokenBalanceState();
}

class _TokenBalanceState extends State<TokenBalance> {
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
      tokenBalance: '0.0005BTC',
      tokenBalanceInUSD: 'US\$21,553',
      tokenName: "Bitcoin",
      tokenSymbol: "BTC",
      tokenPrice: "\$1600",
      tokenImage: 'assets/images/bitcoin.svg',
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
    return LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        child: StreamBuilder<int>(
            stream: counterStream,
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 20).r,
                itemBuilder: (context, index) {
                  return Padding(
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
                      onPressed: () {},
                      child: Row(
                        children: [
                          // SvgPicture.asset(''),
                          SizedBox(
                            width: 9.74.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                               "ensname",
                                style: TextStyle(
                                    fontSize: font14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Date",
                                    style: TextStyle(
                                        fontSize: font14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.30)),
                                  ),
                                  SizedBox(
                                    width: 5.w,
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
                                    width: 5.w,
                                  ),
                                  Text(
                                   "Status",
                                    style: TextStyle(
                                        fontSize: font14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.30)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                            "Status",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: font14,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              ),
                              Text(
                               "Status",
                                style: TextStyle(
                                    color:
                                        black.withOpacity(0.30),),
                              ),
                            ],
                          ),
                          Container(
                              height: 36.512,
                              width: 36.512,
                              decoration: BoxDecoration(
                                  // color: black,
                                  borderRadius: BorderRadius.circular(100).w),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20.sp,
                                color: black,
                              )),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: token.length,
              );
            }));
  }
}
