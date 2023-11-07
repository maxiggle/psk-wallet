import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';
import 'package:variancewallet/utils/tokenData.dart';


class CryptoDetails extends StatefulWidget {
  final List<TokenData>? tokenData;
  const CryptoDetails({super.key, required this.tokenData});

  @override
  State<CryptoDetails> createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails>
    with SingleTickerProviderStateMixin {
  // final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<LiquidPullToRefreshState>? refreshIndicatorKey =
  //     GlobalKey<LiquidPullToRefreshState>();
  // static int? refreshNum = 10;
  // final counterStream =
  //     Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum!);

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

  // Future<void> _handleRefresh() {
  //   final Completer<void> completer = Completer<void>();
  //   Timer(const Duration(seconds: 3), () {
  //     completer.complete();
  //   });
  //   setState(() {
  //     refreshNum = Random().nextInt(100);
  //   });
  //   return completer.future.then<void>((_) {
  //     ScaffoldMessenger.of(scaffoldKey!.currentState!.context).showSnackBar(
  //       SnackBar(
  //         content: const Text('Refresh complete'),
  //         action: SnackBarAction(
  //           label: 'RETRY',
  //           onPressed: () {
  //             refreshIndicatorKey!.currentState!.show();
  //           },
  //         ),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ash,
        appBar: AppBar(
          backgroundColor: ash,
          elevation: 0,
          leading: BackButton(
            color: black,
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            Padding(
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
                      ],
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: 9.4.w),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      '${widget.tokenData?[index].logoUrl}',
                                    ),
                                    SizedBox(
                                      width: 13.51.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.tokenData?[index].contractName}",
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
                                          "${widget.tokenData?[index].tokenBalanceInUSD}",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: font14,
                                              fontWeight: FontWeight.w600,
                                              color: black),
                                        ),
                                        SizedBox(height: 3.91.h),
                                        Text(
                                          "${widget.tokenData?[index].balance}",
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
                    itemCount: widget.tokenData?.length,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
