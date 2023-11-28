import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variance_dart/interfaces.dart';
import 'package:variance_dart/utils.dart';
import 'package:variance_dart/variance.dart';
import 'package:variancewallet/app/gen/passkey_account.dart';
import 'package:variancewallet/app/providers/hive_service.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as w3d;

///
class WalletProvider extends ChangeNotifier {
  PassKeySigner? _passKey;
  late SmartWallet _wallet;
  PassKeyPair? _keyPair;
  late RPCProvider _provider;
  late BundlerProvider _bundler;
  late Uint256 _salt;
  final Chain _chain = Chain(
      chainId: 1337,
      explorer: "http//localhost:8545",
      entrypoint: w3d.EthereumAddress.fromHex(
          "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
      accountFactory: w3d.EthereumAddress.fromHex(
          '0x690832791538Ff4DD15407817B0DAc54456631bc'))
    ..bundlerUrl = "https://3a0a-45-14-71-20.ngrok-free.app/rpc"
    ..ethRpcUrl = "https://6def-45-14-71-20.ngrok-free.app";

  PassKeySigner? get passKey => _passKey;
  Chain get chain => _chain;
  SmartWallet get wallet => _wallet;
  PassKeyPair? get keyPair => _keyPair;
  Uint256 get salt => _salt;
  RPCProvider get rpcProvider => _provider;

  WalletProvider() {
    _passKey = PassKeySigner("webauthn.io", "webauthn", "https://webauthn.io");
    _provider = RPCProvider(chain.bundlerUrl!);
    _bundler = BundlerProvider(chain, _provider);
    _wallet = SmartWallet.init(
        chain: chain,
        signer: _passKey!,
        bundler: BundlerProvider(chain, RPCProvider(chain.bundlerUrl!)));
  }
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final Chain chainBase = Chain(
      chainId: 1,
      explorer: "https://etherscan.io/",
      entrypoint: Constants.entrypoint,
      ethRpcUrl: "https://rpc.ankr.com/eth",
      accountFactory: Constants.accountFactory);

  Future register(String name, String number,
      {bool? requiresUserVerification}) async {
    _keyPair = await _passKey!.register(name, requiresUserVerification!);
    _salt = getSaltFromPhoneNumber(number);

    try {
      final address =
          await _wallet.getSimplePassKeyAccountAddress(_keyPair!, _salt);
      log(address.hex);

      await _wallet.createSimplePasskeyAccount(_keyPair!, _salt);

      await saveToFireStore(_keyPair!.toJson(), _salt.toHex(), number);
      await saveToDB(_keyPair!, _wallet.initCode ?? '', address);
    } catch (e) {
      log("something happened: $e");
    }

    try {
      await saveToFireStore(_keyPair!.toJson(), _salt, number);
      log(_salt.toString());
    } catch (e) {
      log("Error saving to Firestore: $e");
    }
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

  Future<void> saveToDB(
    PassKeyPair passKeyPair,
    String initCode,
    EthereumAddress address,
  ) async {
    // var box = await Hive.openBox('accounts');
    // var account = PasskeyAccount()
    //   ..passkey = passKeyPair
    // ..address = address.hex
    //   ..initCode = _wallet.initCode;
    // await box.put('account', account);
    // await box.close();
    final account = AltPasskeyAccount(
      passkey: passKeyPair,
      address: address.hex,
      initCode: _wallet.initCode,
    );
    HiveService.saveAltPasskeyAccount(account);
  }

  Uint256 getSaltFromPhoneNumber(String number) {
    final salt = sha256Hash(Uint8List.fromList(utf8.encode(number))).toString();
    return Uint256.fromHex(salt);
  }

  Future<w3d.EtherAmount> getWalletBalance(w3d.EthereumAddress address) async {
    return _wallet.plugin<Contract>('Contract').getBalance(address);
  }

  Future<void> sendNativeToken(EthereumAddress recipient, String amount) async {
    // Convert w3d.EtherAmount to the EtherAmount type expected by the send function
    w3d.EtherAmount sendAmount =
        w3d.EtherAmount.fromBase10String(w3d.EtherUnit.wei, amount);

    await _wallet.send(recipient, sendAmount);
  }
}
