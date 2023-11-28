

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as w3d;

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late WalletProvider _walletProvider;
  late ChainBaseApi _baseApi;

  DioClient dioClient = DioClient(
      baseOptions: BaseOptions(
          headers: {"x-api-key": "2YMXnP6WH5f8ziqRQhtfZPXK1kU"},
          contentType: "application/json",
          baseUrl: "https://api.chainbase.online/v1"));

  HomeProvider() {
    _walletProvider = WalletProvider();
    _baseApi =
        ChainBaseApi(restClient: dioClient, chain: _walletProvider.chainBase);
  }

  bool _isLoading = true;

  List<TokenTransfer> _transferData = List.unmodifiable([]);
  List<Token> _tokenBalances = List.unmodifiable([]);
  TokenMetadata? _tokenMetaData;

  //getters
  List<TokenTransfer> get tokenTransfer => _transferData;
  List<Token> get tokenBalance => _tokenBalances;
  w3d.EthereumAddress get address => _testAddress;
  TokenMetadata? get metaData => _tokenMetaData;
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

    try {
      final transferResponse = await _baseApi
          .getTokenTransfersForAddress(usableAddress, pageSize: 1);
      _transferData = transferResponse.data!;

      final tokenBalanceResponse =
          await _baseApi.getTokenBalancesForAddress(usableAddress);
      final contrAdd = _transferData.map((e) => e.contractAddress).toList();
      await Future.delayed(const Duration(seconds: 3));
      final metaData = await _baseApi
          .getTokenMetadata(EthereumAddress.fromHex(contrAdd.first));
      _tokenBalances = tokenBalanceResponse.data!;
      _tokenMetaData = metaData.data;
    } catch (e) {
      if (e is DioException) {
        print('Error message: ${e.message}');
        print('Error data: ${e.response?.data}');
      }
    }

    _updateIsLoading(false);

    notifyListeners();
  }

  Future<w3d.EthereumAddress> getPasskeyAccountAddress(
      PassKeyPair pkp, Uint256 salt) async {
    return _walletProvider.wallet.getSimplePassKeyAccountAddress(pkp, salt);
  }

}
