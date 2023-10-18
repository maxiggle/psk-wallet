import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



///
class PasskeysProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  Future<void> setString() async {
    final SharedPreferences preferences = await _pref;
    preferences.setString('authData', 'passkeys');
  }

  Future<void> getString() async {
    final SharedPreferences preferences = await _pref;
    preferences.getString('authData');
    notifyListeners();
  }
}
