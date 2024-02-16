// ignore_for_file: unnecessary_null_comparison

import 'package:encro/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? authToken;

  Future<void> login(String email, String password) async {
    authToken = await loginAPI(email, password);
    notifyListeners();
  }

  Future<void> signup(String email, String password, String username,
      String firstName, String lastName) async {
    authToken = await signupAPI(email, password, username, firstName, lastName);
    notifyListeners();
  }

  Future<void> logout() async {
    authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    notifyListeners();
  }

  Future<void> storeAuthToken(String token) async {
    authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
  }
}

Future<String> loginAPI(String email, String password) async {
  final response = await login(email, password);

  if (response != null) {
    final String token = response;

    // Store the token locally using shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);

    return token;
  } else {
    throw Exception('Failed to login');
  }
}

Future<String> signupAPI(String email, String password, String username,
    String firstName, String lastName) async {
  final response = await signup(email, password, username, firstName, lastName);

  if (response != null) {
    final String token = response;

    // Store the token locally using shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);

    return token;
  } else {
    throw Exception('Failed to signup');
  }
}
