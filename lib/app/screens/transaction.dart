import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';
import 'package:web3dart/web3dart.dart' as w3d;

class Transactions extends StatefulWidget {
  const Transactions(
      {super.key,
      this.refreshIndicatorKey,
      this.scaffoldKey,
      this.transactionType,
      this.includeModal,
      this.transferData,
      this.metaData});

  final TransactionType? transactionType;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final GlobalKey<LiquidPullToRefreshState>? refreshIndicatorKey;
  final Function(int index)? includeModal;
  final List<TokenTransfer>? transferData;
  final TokenMetadata? metaData;

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
                ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Image.network(
                      widget.metaData?.logos?.first.uri ?? '',
                      height: 32,
                    )),
                SizedBox(width: 9.74.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AddressFormatter.fromEthAddress(
                              w3d.EthereumAddress.fromHex(
                                  widget.transferData![index].fromAddress))
                          .formattedAddress(length: 4),
                      style: TextStyle(
                          fontSize: font14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: black),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.transferData?[index].direction.name
                                  .toLowerCase() ??
                              "CALL",
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
                          DateFormat('MMM d y').format(
                              widget.transferData![index].blockTimestamp),
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
                        '\$${(widget.transferData![index].value.toUnit(widget.metaData!.decimals as int) * widget.metaData!.currentUsdPrice!).toStringAsFixed(3)}',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: font14,
                            fontWeight: FontWeight.w600,
                            color: black),
                      ),
                      const Text(
                        'Success',
                        style: TextStyle(color: darkGreen),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: min(widget.transferData?.length ?? 0, 5),
    );
  }
}
