import 'dart:typed_data';

import 'package:pks_4337_sdk/pks_4337_sdk.dart';

class PersistAuthData extends PassKeyPair {
  PersistAuthData(
    Uint8List credentialHexBytes,
    String credentialId,
    List<Uint256> publicKey,
    String name,
    String aaGUID,
    DateTime registrationTime,
  ) : super(
          credentialHexBytes,
          credentialId,
          publicKey,
          name,
          aaGUID,
          registrationTime,
        );

  // Serialize the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'credentialHexBytes': credentialHexBytes,
      'credentialId': credentialId,
      'publicKey': publicKey.map((pubKey) => pubKey.toHex()).toList(),
      'name': name,
      'aaGUID': aaGUID,
      'registrationTime': registrationTime.toIso8601String(),
    };
  }

  // Deserialize from JSON
  factory PersistAuthData.fromJson(Map<String, dynamic> json) {
    return PersistAuthData(
      Uint8List.fromList(json['credentialHexBytes']),
      json['credentialId'],
      (json['publicKey'] as List)
          .map((pubKey) => Uint256.fromHex(pubKey))
          .toList(),
      json['name'],
      json['aaGUID'],
      DateTime.parse(json['registrationTime']),
    );
  }
}
