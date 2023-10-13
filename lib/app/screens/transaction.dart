import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory(
      {super.key,
      required this.transactionData,
      this.transactionType = TransactionType.receive});

  final List<TransactionData> transactionData;
  final TransactionType transactionType;

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
            onPressed: () {
              Scaffold.of(context).showBottomSheet((context) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25.h,
                          ),
                          SvgPicture.asset(
                            transactionData[index].coinImage,
                            height:
                                MediaQuery.of(context).size.height * 0.2555.h,
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Column(
                            children: [
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: font14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                transactionData[index].ensName,
                                style: TextStyle(
                                  fontSize: font14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  color: black,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
            },
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
                          fontWeight: FontWeight.w600,
                          color: black),
                    ),
                    Row(
                      children: [
                        Text(
                          transactionData[index].type == transactionType
                              ? 'Receive'
                              : 'Send',
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
                          color: black),
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
      itemCount: transactionData.length,
    );
  }
}
