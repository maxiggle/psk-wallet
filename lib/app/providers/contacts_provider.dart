import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:variancewallet/app/providers/wallet_provider.dart';
import 'package:web3dart/web3dart.dart';

class ContactsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late WalletProvider _walletProvider;

  ContactsProvider() {
    _walletProvider = WalletProvider();
  }

  Future<void> sendNativeTokenToContact(
      EthereumAddress recipient, EtherAmount amount) async {
    final userOps = await _walletProvider.wallet.send(recipient, amount);
  }

  Future<void> getSaltFromContacts(String userContact) async {
    final userOps = await _walletProvider.getSaltFromPhoneNumber(userContact);
  }
}
