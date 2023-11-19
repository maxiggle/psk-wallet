import 'package:flutter/foundation.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:web3dart/web3dart.dart' as w3d;

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late WalletProvider _walletProvider;
  late ChainBaseApi _baseApi;
  DioClient dioClient = DioClient(
      baseOptions: BaseOptions(
          headers: {'x-api-key': "2XGB8lcFSea5vlmFijhRe1KAyUY"},
          contentType: 'application/json',
          baseUrl: "https://api.chainbase.online/v1"));

  HomeProvider() {
    _walletProvider = WalletProvider();
    _baseApi =
        ChainBaseApi(restClient: dioClient, chain: _walletProvider.chain);
  }

  bool _isLoading = true;

  List<TokenTransfer> _transferData = List.unmodifiable([]);
  List<Token> _tokenBalances = List.unmodifiable([]);

  //getters
  List<TokenTransfer> get tokenTransfer => _transferData;
  List<Token> get tokenBalance => _tokenBalances;
  w3d.EthereumAddress get address => _testAddress;
  bool get isLoading => _isLoading;

  final _testAddress = w3d.EthereumAddress.fromHex(
    "0x104EDD9708fFeeCd0b6bAaA37387E155Bce7d060",
  );

  void _updateIsLoading(bool value) {
    _isLoading = value;
  }

  Future<void> getData({
    w3d.EthereumAddress? address,
    String? chain,
  }) async {
    final usableAddress = address ?? _testAddress;

    final transferRespnse =
        await _baseApi.getTokenTransfersForAddress(usableAddress);
    final tokenBalanceResponse =
        await _baseApi.getTokenBalancesForAddress(usableAddress);

    _transferData = transferRespnse.data!;
    _tokenBalances = tokenBalanceResponse.data!;

    _updateIsLoading(false);

    notifyListeners();
  }

  Future<w3d.EthereumAddress> getPasskeyAccountAddress(
      PassKeyPair pkp, Uint256 salt) async {
    return _walletProvider.wallet.getSimplePassKeyAccountAddress(pkp, salt);
  }
}
