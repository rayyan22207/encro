import 'dart:convert';
import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:encro/authentication/api_auth.dart';
import 'package:encro/models/Accouts_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart'; // Import Flutter material

Future<List<dynamic>?> fechChatList(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final authToken = authProvider.authToken;

  final url = 'http://192.168.18.4:8000/api/onetoonechats/';
  final uri = Uri.parse(url);

  final headers = {
    'Authorization': 'Token $authToken',
  };
  final response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList;
  } else {
    // Handle errors, e.g., by returning null
    print('Request failed with status: ${response.statusCode}');
    return null;
  }
}

Future<List<dynamic>?> fechRequestUser(BuildContext context) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final authToken = authProvider.authToken;

  final url = '$baseUrl/api/auth/users/';
  final uri = Uri.parse(url);

  final headers = {
    'Authorization': 'Token $authToken',
  };
  final response = await http.get(uri, headers: headers);

  List<dynamic> dataList = jsonDecode(response.body);
  List<CustomUser> jsonList = [];
  if (response.statusCode == 200) {
    for (var data in dataList) {
      jsonList.add(CustomUser.fromJson(data as Map<String, dynamic>));
    }
    return jsonList;
  }
  return null;
}
