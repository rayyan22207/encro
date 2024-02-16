import 'dart:core';

import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/user_login/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final String token = data['token'];

    // Store the token locally using shared_preferences
    // Example:
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('authToken', token);

    return token;
  } else {
    throw Exception('Failed to login');
  }
}

Future<String> signup(String email, String password, String username,
    String firstName, String lastName) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/auth/register/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'username': username, // Add username
      'password': password,
      'first_name': firstName, // Add first_name
      'last_name': lastName, // Add last_name
    }),
  );

  if (response.statusCode == 201) {
    final Map<String, dynamic> data = json.decode(response.body);
    final String token = data['token'];

    // Store the token locally using shared_preferences
    // Example:
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('authToken', token);

    return token;
  } else {
    throw Exception('Failed to signup');
  }
}
