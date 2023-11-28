// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:variance_dart/variance.dart';

part 'passkey_account.g.dart';

@HiveType(typeId: 0)
class PasskeyAccount extends HiveObject {
  @HiveField(0)
  PassKeyPair? passkey;

  @HiveField(1)
  String? initCode;

  @HiveField(2)
  String? address;
}

class AltPasskeyAccount {
  final PassKeyPair? passkey;
  final String? initCode;
  final String? address;

  AltPasskeyAccount({
    this.passkey,
    this.initCode,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'passkey': passkey?.toMap(),
      'initCode': initCode,
      'address': address,
    };
  }

  factory AltPasskeyAccount.fromMap(Map<String, dynamic> map) {
    return AltPasskeyAccount(
      passkey: map['passkey'] != null
          ? PassKeyPair.fromMap(map['passkey'] as Map<String, dynamic>)
          : null,
      initCode: map['initCode'] != null ? map['initCode'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AltPasskeyAccount.fromJson(String source) =>
      AltPasskeyAccount.fromMap(json.decode(source) as Map<String, dynamic>);
}
