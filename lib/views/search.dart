import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:encro/authentication/api_auth.dart';
import 'package:encro/models/friendrequestaccoutns.dart';
import 'package:encro/models/searchaccountmodel.dart';
import 'package:encro/views/home.dart';
import 'package:encro/views/otheruserprofile.dart';
import 'package:flutter/material.dart';
import 'package:encro/views/profile.dart';
import 'package:encro/views/request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const SearchPage({
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<UserProfile> _searchResults = [];
  List<Request> receivedRequests = [];
  List<Request> sentRequests = [];

  void _onItemTapped(int index) {
    // Notify the parent widget about the change
    widget.onIndexChanged(index);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _getPage(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Friend Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: widget.selectedIndex,
        unselectedItemColor: Color.fromARGB(255, 77, 77, 77),
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage(
          selectedIndex: index,
          onIndexChanged: widget.onIndexChanged,
        );
      case 2:
        return RequestingPage(
          selectedIndex: index,
          onIndexChanged: widget.onIndexChanged,
        );
      case 3:
        return ProfilePage(
          selectedIndex: index,
          onIndexChanged: widget.onIndexChanged,
        );

      default:
        return HomePage(); // Handle the case of an unknown index
    }
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No results'),
      );
    }

    List sentUsernames =
        sentRequests.map((request) => request.username).toList();

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        UserProfile userProfile = _searchResults[index];

        // Check if userProfile.username exists in sentUsernames
        bool isFriendRequestSent = sentUsernames.contains(userProfile.username);

        return GestureDetector(
          onTap: () {
            // Handle the item click, for example,
          },
          child: ListTile(
            title: Text(userProfile.username),
            subtitle: Text(userProfile.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isFriendRequestSent) // Display the button if no friend request has been sent
                  ElevatedButton(
                    onPressed: () {
                      _sendFriendRequest(userProfile.username);
                    },
                    child: Text('Send'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToUserProfile(int id) {
    //Navigate to the user profile page or any other destination
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfile(id: id),
      ),
    );

    print(id);
  }

  void _sendFriendRequest(String username) {
    // Perform the logic to send a friend request
    // For example, you can print the user's username
    sendfrndRequest(username);
    print('Sending friend request to user with ID: $username');
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

  Future<void> sendfrndRequest(String username) async {
    final url = '$baseUrl/api/send_friend_request/$username/';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    final response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 201) {
      // Request successful, you can handle the response accordingly
      // For example, show a snackbar or update the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Friend request sent.'),
        ),
      );
      // Refresh the list of requests after responding
      frequests();
    } else {
      // Handle the error case
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send to friend request.'),
        ),
      );
    }
  }

  Future<List<UserProfile>> searchUsers(String query) async {
    final url = '$baseUrl/api/auth/users/search?query=$query';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserProfile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<void> frequests() async {
    final url = '$baseUrl/api/friend_requests';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        receivedRequests = (data['received_requests'] as List)
            .map((item) => Request.fromJson(item))
            .toList();
        sentRequests = (data['sent_requests'] as List)
            .map((item) => Request.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to get the requests');
    }
  }
}
