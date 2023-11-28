import 'package:hive/hive.dart';
import 'package:variancewallet/app/gen/passkey_account.dart';

class HiveService {
  static const String boxName = 'altPasskeyBox';

  static Future<void> saveAltPasskeyAccount(AltPasskeyAccount account) async {
    final box = await Hive.openBox<dynamic>(boxName);

    // Convert the AltPasskeyAccount to a Map<String, dynamic>
    final accountMap = account.toMap();

    // Save the Map to the Hive box
    await box.put('userKey', accountMap);

    // Close the Hive box when done
    await box.close();
  }

  static Future<AltPasskeyAccount?> getAltPasskeyAccount() async {
    final box = await Hive.openBox<dynamic>(boxName);

    // Retrieve the Map from the Hive box
    final dynamic accountMap = box.get('userKey');

    // Close the Hive box when done
    await box.close();

    // Convert the Map back to AltPasskeyAccount
    // if (accountMap != null) {
    //   return AltPasskeyAccount.fromMap(accountMap.cast<String, dynamic>());
    // }
    if (accountMap is Map<String, dynamic>) {
      return AltPasskeyAccount.fromMap(accountMap);
    }

    return null;
  }
}
