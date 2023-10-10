import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({
    super.key,
    required this.transactionData,
  });

  final List<TransactionData> transactionData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20).r,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 9.74).r,
          child: Container(
            padding: const EdgeInsets.fromLTRB(23.31, 24.34, 13.51, 24.34).r,
            decoration: BoxDecoration(
              color: ash,
              borderRadius: BorderRadius.circular(radius).w,
            ),
            child: Row(
              children: [
                SvgPicture.asset(transactionData[index].coinImage),
                SizedBox(
                  width: 9.74.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionData[index].ensName,
                      style: TextStyle(
                          fontSize: font14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Text(
                          'Send',
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
                          DateFormat('yyyy-MM-dd')
                              .format(transactionData[index].transactionTime),
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
                      transactionData[index].amount,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: font14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      transactionData[index].status == TransactionStatus.pending
                          ? 'In-transit'
                          : 'Success',
                      style: TextStyle(
                          color: transactionData[index].status ==
                                  TransactionStatus.pending
                              ? blue2
                              : darkGreen),
                    ),
                  ],
                ),
                Container(
                    height: 36.512,
                    width: 36.512,
                    decoration: BoxDecoration(
                        color: ash, borderRadius: BorderRadius.circular(100).w),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20.sp,
                    )),
              ],
            ),
          ),
        );
      },
      itemCount: transactionData.length,
    );
  }
}
