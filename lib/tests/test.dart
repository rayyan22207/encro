import 'dart:async';
import 'dart:convert';
import 'package:encro/models/Accouts_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:encro/authentication/api_auth.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CustomUser>> futureUserList;

  @override
  void initState() {
    super.initState();
    futureUserList = fetchCustomUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<CustomUser>>(
            future: futureUserList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].email),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot);
                }
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Future<List<CustomUser>> fetchCustomUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    final response = await http.get(
        Uri.parse('http://192.168.18.4:8000/api/auth/users/'),
        headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> dataList = jsonDecode(response.body);
      List<CustomUser> userList = [];
      for (var data in dataList) {
        userList.add(CustomUser.fromJson(data as Map<String, dynamic>));
      }
      return userList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album list');
    }
  }
}
