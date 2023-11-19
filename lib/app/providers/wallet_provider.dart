import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  late PassKeySigner _passKey;
  late SmartWallet _wallet;
  late PassKeyPair _keyPair;
  late RPCProvider _provider;
  late BundlerProvider _bundler;
  late Uint256 _salt;

  PassKeySigner get passKey => _passKey;
  SmartWallet get wallet => _wallet;
  PassKeyPair get keyPair => _keyPair;
  Uint256 get salt => _salt;

  WalletProvider() {
    _passKey = PassKeySigner("webauthn.io", "webauthn", "https://webauthn.io");
    _provider = RPCProvider(chain.bundlerUrl!);
    _bundler = BundlerProvider(chain, _provider);
    _wallet = SmartWallet(bundler: _bundler, chain: chain, signer: _passKey);
  }
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final Chain chain = Chain(
      chainId: 1337,
      explorer: "http//localhost:8545",
      entrypoint: w3d.EthereumAddress.fromHex(
          "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
      accountFactory: w3d.EthereumAddress.fromHex(
          '0x690832791538Ff4DD15407817B0DAc54456631bc'))
    ..bundlerUrl = "https://8bac-41-190-2-196.ngrok-free.app/rpc"
    ..ethRpcUrl = "https://d248-41-190-2-196.ngrok-free.app";

  Future register(String name, String number,
      {bool? requiresUserVerification}) async {
    _keyPair = await _passKey.register(name, requiresUserVerification!);
    _salt = getSaltFromPhoneNumber(number);

    try {
      await _wallet.getSimplePassKeyAccountAddress(_keyPair, _salt);

      await _wallet.createSimplePasskeyAccount(_keyPair, _salt);

      await saveToFireStore(_keyPair.toJson(), _salt.toHex(), number);
      await saveKeyPairToDevice('pkp', _keyPair.toJson());
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

  Future<void> saveKeyPairToDevice(String key, String passKeyPair) async {
    final SharedPreferences preferences = await _pref;
    preferences.setString(key, passKeyPair);
  }

  Future saveToFireStore(String pkp, salt, phoneNumber) async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    String token = await fcm.getToken() ?? '';
    await FirebaseFirestore.instance.collection("Profiles").add(
        {"pkp": pkp, "salt": salt, "number": phoneNumber, "fcm_token": token});
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
    return _wallet.plugin<Contract>('Contract').getBalance(address);
  }
}
