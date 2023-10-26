import 'package:flutter/foundation.dart';
import 'package:pks_4337_sdk/src/modules/covalent_api/covalent_api.dart';
import 'package:web3dart/web3dart.dart' as w3d;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<Token> _token = List.unmodifiable([]);
  List<Transaction> _transactionData = List.unmodifiable([]);
  bool _isLoading = true;

  List<Token> get token => _token;
  List<Transaction> get transactionData => _transactionData;
  bool get isLoading => _isLoading;

  String get _cKey => dotenv.get('CKEY', fallback: '');
  final _testAddress = w3d.EthereumAddress.fromHex(
    "0x104EDD9708fFeeCd0b6bAaA37387E155Bce7d060",
  );
  final _testChain = "eth-mainnet";

  void _updateIsLoading(bool value) {
    _isLoading = value;
  }

  Future<void> getData({
    w3d.EthereumAddress? address,
    String? chain,
  }) async {
    final usableAddress = address ?? _testAddress;
    final usableChain = chain ?? _testChain;

    final txApi = CovalentTransactionsApi(_cKey, usableChain);
    final transactions = await txApi.getTransactionsForAddress(usableAddress);

    final tokenApi = CovalentTokenApi(_cKey, usableChain);
    final token = await tokenApi.getBalances(usableAddress);

    _transactionData = transactions;
    _token = token;
    _updateIsLoading(false);

    notifyListeners();
  }
}
