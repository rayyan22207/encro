// ignore_for_file: unnecessary_null_comparison

import 'package:encro/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? authToken;

  // Step 1: Login method
  Future<void> login(String email, String password) async {
    authToken = await loginAPI(email, password);
    notifyListeners(); // Notify listeners that the state has changed
  }

  // Step 2: Signup method
  Future<void> signup(String email, String password, String username,
      String firstName, String lastName) async {
    authToken = await signupAPI(email, password, username, firstName, lastName);
    notifyListeners(); // Notify listeners that the state has changed
  }

  // Step 3: Logout method
  Future<void> logout() async {
    authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    notifyListeners(); // Notify listeners that the state has changed
  }

  // Step 4: Store Auth Token method
  Future<void> storeAuthToken(String token) async {
    authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Step 5: Load Auth Token method
  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
  }
}

// Step 6: Login API method
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

// Step 7: Signup API method
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
