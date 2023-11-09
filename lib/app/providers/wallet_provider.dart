import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  late PassKey _passKey;
  late Wallet _wallet;

  PassKey get passKey => _passKey;
  Wallet get wallet => _wallet;

  WalletProvider() {
    _passKey = PassKey("webauthn.io", "webauthn", "https://webauthn.io");
    _wallet = Wallet(
        chain: chain.validate(), signer: SignerType.passkey, passkey: _passKey);
  }
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final IChain chain = IChain(
      chainId: 1337,
      explorer: "http//localhost:8545",
      entrypoint: w3d.EthereumAddress.fromHex(
          "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
      accountFactory: w3d.EthereumAddress.fromHex(
          '0x690832791538Ff4DD15407817B0DAc54456631bc'))
    ..bundlerUrl = "https://dae2-105-112-114-171.ngrok-free.app/rpc"
    ..rpcUrl = "https://52c3-105-112-114-171.ngrok-free.app";

  Future register(String name, String number,
      {bool? requiresUserVerification}) async {
    final pair =
        await _passKey.register(name, requiresUserVerification ?? false);

    final salt = getSaltFromPhoneNumber(number);

    log("pkp:${pair.toJson()}");
    try {
      final addr = await _wallet.getPassKeyAccountAddress(
          pair.credentialHexBytes, pair.publicKey[0], pair.publicKey[1], salt);

      log("addr: $addr");
      await _wallet.createPasskeyAccount(
          pair.credentialHexBytes, pair.publicKey[0], pair.publicKey[1], salt);

      log("last one");
    } catch (e) {
      log("something happened: $e");
    }
  }

  Future<void> setString(String key, String passKeyPair) async {
    final SharedPreferences preferences = await _pref;
    preferences.setString(key, passKeyPair);
  }

  Future<void> getString(String key) async {
    final SharedPreferences preferences = await _pref;
    String? passKeyPairString = preferences.getString(key);
    // log("passKeyPairString:$passKeyPairString");
    if (passKeyPairString != null) {}
    notifyListeners();
  }

  Uint256 getSaltFromPhoneNumber(String number) {
    final salt = sha256Hash(Uint8List.fromList(utf8.encode(number))).toString();
    return Uint256.fromHex(salt);
  }

  Future<w3d.EtherAmount> getWalletBalance(w3d.EthereumAddress address) async {
    return wallet.module<Contract>('contract').getBalance(address);
  }
}
