import 'package:pkswallet/app/screens/transaction.dart';
import 'package:pkswallet/const.dart';

final List<TransactionData> transactionData = [
  TransactionData(
      transactionTime: DateTime.now(),
      amount: '\$21,553',
      coinImage: 'assets/images/ethereum.svg',
      ensName: 'Dave',
      type: TransactionType.send,
      status: TransactionStatus.pending),
];
