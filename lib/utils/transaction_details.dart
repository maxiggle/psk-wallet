import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:variancewallet/app/screens/transaction.dart';
import 'package:variancewallet/app/theme/colors.dart';
import 'package:variancewallet/const.dart';

class TransactionDetails extends StatefulWidget {
  final List<TransactionData>? transactionData;
  const TransactionDetails({Key? key, required this.transactionData})
      : super(key: key);

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

  List<TransactionData> getFilteredTransactions(
      TransactionType? transactionType) {
    return widget.transactionData!
        .where((transaction) =>
            transactionType == null || transaction.type == transactionType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              const Transactions()
            ],
          ),
        ),
      ),
    );
  }
}
