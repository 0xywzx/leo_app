import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserToken {
  // シングルトン？
  static UserToken _store = UserToken._internal();
  factory UserToken() => _store;
  UserToken._internal();

  static String prefsKeySession = "session";
  SharedPreferences prefs;

  get session => prefs.getString(UserToken.prefsKeySession);

  setUserToken(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(UserToken.prefsKeySession, json['token']);
  }
}