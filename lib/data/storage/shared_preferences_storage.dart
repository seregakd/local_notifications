import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesStorage {
  SharedPreferences? _preferences;

  Future<SharedPreferences> _init() async {
    if (_preferences != null) {
      return _preferences!;
    }
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  @protected
  Future<SharedPreferences> get preferences => _init();
}
