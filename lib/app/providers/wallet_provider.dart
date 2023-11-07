import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variance_dart/variance.dart';
import 'package:variance_dart/variance.dart' as wt;
import 'package:web3dart/web3dart.dart' as w3d;
import 'package:web3dart/web3dart.dart';

///
class WalletProvider extends ChangeNotifier {
  late IChain iChain;
  late PassKey _passKey;
  late wt.Wallet _wallet;
  late AlchemyTokenApi _tokenApi;

  PassKey get passKey => _passKey;
  wt.Wallet get wallet => _wallet;

  String get _cKey => dotenv.get('CKEY', fallback: '');
  // EthereumAddress _acctAddress = EthereumAddress.fromHex('');
  // EthereumAddress get acctAddress => _acctAddress;

  WalletProvider() {
    _passKey = PassKey("webauthn.io", "webauthn", "https://webauthn.io");
    _wallet =
        wt.Wallet(chain: chain, signer: SignerType.passkey, passkey: _passKey);
    _tokenApi = AlchemyTokenApi(wallet.rpcProvider);
    iChain = IChain(
        chainId: 1337,
        explorer: "http//localhost:8545",
        entrypoint: EthereumAddress.fromHex(
            "0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789"),
        accountFactory: EthereumAddress.fromHex(
            '0x690832791538Ff4DD15407817B0DAc54456631bc'));
  }
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final IChain chain = Chains.getChain(Chain.localhost)
    ..bundlerUrl = "https://f882-197-210-227-52.ngrok-free.app/rpc"
    ..rpcUrl =
        "https://eth-mainnet.g.alchemy.com/v2/cLTpHWqs6iaOgFrnuxMVl9Z1Ung00otf";

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

  // Future<void> getAccountAddress(EthereumAddress owner, BigInt salt) async {
  //   _acctAddress = await _wallet.getAccountAddress(owner, salt);
  //   notifyListeners();
  // }

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

  Future<List<Token>> getTokensForAddress(
      String cKey, w3d.EthereumAddress address, String chain) async {
    return await _tokenApi.getBalances(address);
  }

  Future<w3d.EtherAmount> getWalletBalance(w3d.EthereumAddress address) async {
    return wallet.module<Contract>('contract').getBalance(address);
  }
}
