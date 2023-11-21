import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:variance_dart/utils.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';

class TokenBalance extends StatefulWidget {
  final List<Token>? tokenBalance;
  const TokenBalance({
    super.key,
    required this.tokenBalance,
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
      // refreshNum = Random().nextInt(100);
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
                  padding: const EdgeInsets.only(
                          left: 23, right: 21.91, top: 9.91, bottom: 9.74)
                      .r,
                  child: Row(
                    children: [
                      Text(
                        'Crypto',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: font19,
                            fontWeight: FontWeight.w600),
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
                              context.push('/crypto_details',
                                  extra: widget.tokenBalance);
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20.sp,
                            ),
                          )),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 20).r,
                  itemBuilder: (context, index) {
                    if (widget.tokenBalance != null &&
                        index < widget.tokenBalance!.length) {
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
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(radius),
                                    child: Image.network(
                                      widget.tokenBalance![index].logos![index]
                                          .uri,
                                      height: 32,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13.51.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.tokenBalance![index].name,
                                        style: TextStyle(
                                            fontSize: font14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            color: black),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\$"
                                          "${widget.tokenBalance![index].currentUsdPrice}",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: font14,
                                              fontWeight: FontWeight.w600,
                                              color: black),
                                        ),
                                        SizedBox(height: 3.91.h),
                                        Text(
                                          '${widget.tokenBalance![index].balance.toEther().toString()} ${widget.tokenBalance![index].symbol}',
                                          style: TextStyle(
                                            color: black.withOpacity(0.30),
                                            fontFamily: 'Inter',
                                            fontSize: font14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                  itemCount: min(widget.tokenBalance?.length ?? 0, 5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
