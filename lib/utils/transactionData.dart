

import 'package:variancewallet/const.dart';

final List<TransactionData> transactionData = [
  TransactionData(
      transactionTime: DateTime.now(),
      amount: '\$21,553',
      coinImage: 'assets/images/ethereum.svg',
      ensName: 'Dave',
      type: TransactionType.send,
      status: TransactionStatus.pending),
];
class TransactionData {
  final String? txHash;
  final String? coinImage;
  final String? ensName;
  final TransactionType? type;
  final TransactionStatus? status;
  final DateTime? transactionTime;
  final String? amount;

  TransactionData(
      {this.txHash,
      required this.coinImage,
      required this.ensName,
      required this.type,
      required this.status,
      required this.transactionTime,
      required this.amount});
}
