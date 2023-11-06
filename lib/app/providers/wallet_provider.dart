import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final IChain chain = Chains.getChain(Chain.localhost)
    ..bundlerUrl = "https://81bf-105-112-229-26.ngrok-free.app"
    ..rpcUrl = " https://99c1-105-112-229-26.ngrok-free.app/rpc";

  late PassKey _passKey;
  late Wallet _wallet;
  late AlchemyTokenApi _tokenApi;

  PassKey get passKey => _passKey;
  Wallet get wallet => _wallet;
  String get _cKey => dotenv.get('CKEY', fallback: '');

  WalletProvider() {
    _passKey = PassKey("webauthn.io", "webauthn", "https://webauthn.io");
    _wallet =
        Wallet(chain: chain, signer: SignerType.passkey, passkey: _passKey);

    _tokenApi = AlchemyTokenApi(wallet.rpcProvider);
  }

  Future<void> register(String name, String number,
      {bool? requiresUserVerification}) async {
    final pkp =
        await _passKey.register(name, requiresUserVerification ?? false);
    await _wallet.createPasskeyAccount(pkp.credentialHexBytes, pkp.publicKey[0],
        pkp.publicKey[0], getSaltFromPhoneNumber(number));
  }

  Future<void> setString(String key, String passKeyPair) async {
    final SharedPreferences preferences = await _pref;
    preferences.setString(key, passKeyPair);
  }

  Future<void> getString(String key) async {
    final SharedPreferences preferences = await _pref;
    String? passKeyPairString = preferences.getString(key);
    log("passKeyPairString:$passKeyPairString");
    if (passKeyPairString != null) {}
    notifyListeners();
  }

  Uint256 getSaltFromPhoneNumber(String number) {
    final salt = sha256Hash(Uint8List.fromList(utf8.encode(number))).toString();
    return Uint256.fromHex(salt);
  }

  // Future<List<w3d.Transaction>> getTransactionsForAddress(
  //      w3d.EthereumAddress address, String chain) async {
  //   return await _tokenApi
  // }

  Future<List<Token>> getTokensForAddress(
      String cKey, w3d.EthereumAddress address, String chain) async {
    return await _tokenApi.getBalances(address);
  }

  Future<w3d.EtherAmount> getWalletBalance(w3d.EthereumAddress address) async {
    return wallet.module<Contract>('contract').getBalance(address);
  }
}
