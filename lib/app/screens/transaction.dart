import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:variance_dart/variance.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';

class Transactions extends StatefulWidget {
  const Transactions(
      {super.key,
      this.refreshIndicatorKey,
      this.scaffoldKey,
      this.transactionType,
      this.includeModal,
      this.transferData});

  final TransactionType? transactionType;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final GlobalKey<LiquidPullToRefreshState>? refreshIndicatorKey;
  final Function(int index)? includeModal;
  final List<Transfer>? transferData;

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  static int? refreshNum = 10;
  final counterStream =
      Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum!);

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    setState(() {
      refreshNum = Random().nextInt(100);
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(widget.scaffoldKey!.currentState!.context)
          .showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            onPressed: () {
              widget.refreshIndicatorKey!.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20).r,
      itemBuilder: (context, index) {
        var transfers = widget.transferData?[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 9.74).r,
          child: TextButton(
            style: TextButton.styleFrom(
              elevation: 0,
              backgroundColor: ash,
              padding: const EdgeInsets.fromLTRB(23.31, 24.34, 13.51, 24.34).r,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius).r),
            ),
            onPressed: () => widget.includeModal?.call(index),
            child: Row(
              children: [
                SvgPicture.asset("assets/images/ethereum.svg"),
                SizedBox(width: 9.74.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${transfers?.erc1155Metadata?.tokenId}",
                      style: TextStyle(
                          fontSize: font14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: black),
                    ),
                    Row(
                      children: [
                        Text(
                          '${transfers?.asset}',
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
                          '${transfers?.blockTimestamp?.day}',
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
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${transfers?.to}',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: font14,
                            fontWeight: FontWeight.w600,
                            color: black),
                      ),
                      Text(
                        '',
                        style: TextStyle(color: blue2),
                      ),
                    ],
                  ),
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
      itemCount: widget.transferData?.length,
    );
  }
}

