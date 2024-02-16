import 'package:encro/models/searchaccountmodel.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class SeatchScreen extends StatefulWidget {
  @override
  _SeatchScreenState createState() => _SeatchScreenState();
}

class _SeatchScreenState extends State<SeatchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<UserProfile> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchUsers();
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results'),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        UserProfile userProfile = _searchResults[index];
        return ListTile(
          title: Text(userProfile.username),
          subtitle: Text(userProfile.email),
          // Add more fields as needed
        );
      },
    );
  }

  Future<void> _searchUsers() async {
    String query = _searchController.text;
    try {
      List<UserProfile> results = await searchUsers(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  Future<List<UserProfile>> searchUsers(String query) async {
    final url = 'http://192.168.18.4:8000/api/auth/users/search?query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserProfile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
