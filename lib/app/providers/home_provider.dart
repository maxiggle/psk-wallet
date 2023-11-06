import 'package:flutter/foundation.dart';
import 'package:variance_dart/variance.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as w3d;

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late WalletProvider _walletProvider;
  late AlchemyTokenApi _tokenApi;
  late AlchemyTransferApi _transferApi;

  HomeProvider() {
    _walletProvider = WalletProvider();
    _tokenApi = AlchemyTokenApi(_walletProvider.wallet.rpcProvider);
    _transferApi = AlchemyTransferApi(_walletProvider.wallet.rpcProvider);
  }
  List<Token> _token = List.unmodifiable([]);
  List<Transfer> _transferData = List.unmodifiable([]);
  bool _isLoading = true;

  //getters
  List<Token> get token => _token;
  List<Transfer> get transferData => _transferData;
  EthereumAddress get address => _testAddress;
  bool get isLoading => _isLoading;

  final _testAddress = w3d.EthereumAddress.fromHex(
    "0x104EDD9708fFeeCd0b6bAaA37387E155Bce7d060",
  );
  // final _testChain = "eth-mainnet";

  void _updateIsLoading(bool value) {
    _isLoading = value;
  }

  Future<void> getData({
    w3d.EthereumAddress? address,
    String? chain,
  }) async {
    final usableAddress = address ?? _testAddress;
    final transfers = await _transferApi.getAssetTransfers(usableAddress);
    final token = await _tokenApi.getBalances(usableAddress);

    _transferData = transfers;
    _token = token;
    _updateIsLoading(false);

    notifyListeners();
  }
}
