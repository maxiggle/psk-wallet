import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pkswallet/app/screens/home_page.dart';
import 'package:pkswallet/app/screens/transaction.dart';
import 'package:pkswallet/app/theme/colors.dart';
import 'package:pkswallet/const.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({Key? key}) : super(key: key);

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails>
    with SingleTickerProviderStateMixin {
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

  List<TransactionData> getFilteredTransactions(
      TransactionType? transactionType) {
    return transactionData
        .where((transaction) =>
            transactionType == null || transaction.type == transactionType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ash,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: ash,
              leading: BackButton(
                color: black,
                onPressed: () => GoRouter.of(context).pop('/home'),
              )),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25.w,
                ),
                Text(
                  'Transactions',
                  style: TextStyle(
                      fontSize: font19,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter'),
                ),
                SizedBox(height: 50.h),
                TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: const Color(0xff9DB200)),
                    color: lightGreen,
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Sent',
                    ),
                    Tab(
                      text: 'Received',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // first tab bar view widget
                      TransactionHistory(
                        transactionData:
                            getFilteredTransactions(TransactionType.send),
                      ),

                      // second tab bar view widget
                      TransactionHistory(
                          transactionData:
                              getFilteredTransactions(TransactionType.receive))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const CustomAppBar({
    super.key,
    required this.child,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ash,
            blurRadius: 0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      height: preferredSize.height,
      alignment: Alignment.center,
      child: child,
    );
  }
}
