import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pks_4337_sdk/pks_4337_sdk.dart';
import 'package:pks_4337_sdk/src/modules/covalent_api/covalent_api.dart';
import 'package:pkswallet/app/providers/persist_auth_data.dart';
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
  PersistAuthData? passKeyPair;

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
    passKeyPair = pkp as PersistAuthData;
    setString('passKey', json.encode(passKeyPair?.toJson()));
  }

  Future<void> setString(String key, String passKeyPair) async {
    final SharedPreferences preferences = await _pref;
    preferences.setString(key, passKeyPair);
  }

  Future<void> getString(String key) async {
    final SharedPreferences preferences = await _pref;
    String? passKeyPairString = preferences.getString(key);
    log("passKeyPairString:$passKeyPairString");
    if (passKeyPairString != null) {
      passKeyPair = json.decode(passKeyPairString);
    }
    notifyListeners();
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
