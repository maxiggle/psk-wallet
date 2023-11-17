import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  late PassKey _passKey;
  late Wallet _wallet;
  late PassKeyPair _keyPair;
  late Uint256 _salt;

  PassKey get passKey => _passKey;
  Wallet get wallet => _wallet;
  PassKeyPair get keyPair => _keyPair;
  Uint256 get salt => _salt;

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
    ..bundlerUrl = "https://8bac-41-190-2-196.ngrok-free.app/rpc"
    ..rpcUrl = "https://d248-41-190-2-196.ngrok-free.app";

  Future register(String name, String number,
      {bool? requiresUserVerification}) async {
    _keyPair = await _passKey.register(name, requiresUserVerification ?? false);
    _salt = getSaltFromPhoneNumber(number);
    try {
      final addr = await _wallet.getPassKeyAccountAddress(
          _keyPair.credentialHexBytes,
          _keyPair.publicKey[0],
          _keyPair.publicKey[1],
          salt);

      log("${_keyPair.toJson()}");
      await _wallet.createPasskeyAccount(_keyPair.credentialHexBytes,
          _keyPair.publicKey[0], _keyPair.publicKey[1], salt);

      log("last one");
    } catch (e) {
      log("something happened: $e");
    }

    try {
      await saveToFireStore(_keyPair.toJson(), _salt, number);
      log(_salt.toString());
    } catch (e) {
      log("Error saving to Firestore: $e");
    }
  }

  Future<void> setString(String key, String passKeyPair) async {
    final SharedPreferences preferences = await _pref;
    preferences.setString(key, passKeyPair);
  }

  Future saveToFireStore(String pkp, salt, phoneNumber) async {
    await FirebaseFirestore.instance
        .collection("rofiles")
        .add({"pkp": pkp, "salt": salt, "number": phoneNumber});
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
