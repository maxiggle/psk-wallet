import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pks_4337_sdk/pks_4337_sdk.dart';
import 'package:pks_4337_sdk/src/modules/covalent_api/covalent_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final IChain chain = Chains.getChain(Chain.localhost)
    ..bundlerUrl = "https://e089-41-190-30-46.ngrok-free.app/rpc"
    ..rpcUrl = "https://c4a4-41-190-30-46.ngrok-free.app";

  late PassKey _passKey;
  late Wallet _wallet;
  PassKeyPair? passKeyPair;

  PassKey get passKey => _passKey;
  Wallet get wallet => _wallet;

  WalletProvider() {
    _passKey = PassKey("webauthn.io", "webauthn", "https://webauthn.io");
    _wallet =
        Wallet(chain: chain, signer: SignerType.passkey, passkey: _passKey);
  }

  Future<void> register(String name, String number,
      {bool? requiresUserVerification}) async {
    final pkp =
        await _passKey.register(name, requiresUserVerification ?? false);
    await _wallet.createPasskeyAccount(pkp.credentialHexBytes, pkp.publicKey[0],
        pkp.publicKey[0], getSaltFromPhoneNumber(number));
    passKeyPair = pkp;
  }

  Future<void> setString(String name, String data) async {
    final SharedPreferences preferences = await _pref;
    preferences.setString(name, data);
  }

  Future<void> getString(String name) async {
    final SharedPreferences preferences = await _pref;
    preferences.getString('authData');
    notifyListeners();
  }

  Future<List<dynamic>> getBlockchainDataForAddress(
      w3d.EthereumAddress address, String cKey) async {
    const chainName = "eth-mainnet";

    if (address == Chains.zeroAddress) {
      return Future.value([]);
    }

    final responses = await Future.wait([
      getWalletBalance(address),
      getTokensForAddress(cKey, address, chainName),
      getTransactionsForAddress(cKey, address, chainName)
    ]);

    print(responses[0]);

    return responses;
  }

  Uint256 getSaltFromPhoneNumber(String number) {
    final salt = sha256Hash(Uint8List.fromList(utf8.encode(number))).toString();
    return Uint256.fromHex(salt);
  }

  Future<List<Transaction>> getTransactionsForAddress(
      String cKey, w3d.EthereumAddress address, String chain) async {
    final txApi = CovalentTransactionsApi(cKey, chain);
    return await txApi.getTransactionsForAddress(address);
  }

  Future<List<Token>> getTokensForAddress(
      String cKey, w3d.EthereumAddress address, String chain) async {
    final tokenApi = CovalentTokenApi(cKey, chain);
    return await tokenApi.getBalances(address);
  }

  Future<w3d.EtherAmount> getWalletBalance(w3d.EthereumAddress address) async {
    return wallet.module<Contract>('contract').getBalance(address);
  }
}
