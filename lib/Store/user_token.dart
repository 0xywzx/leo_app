import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserToken {
  static String prefsKeySession = "session";

  getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session') ?? '';
  }

  setUserToken(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(UserToken.prefsKeySession, json['token']);
  }
}