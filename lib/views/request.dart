import 'dart:convert';
import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:encro/authentication/api_auth.dart';
import 'package:encro/models/friendrequestaccoutns.dart';
import 'package:encro/views/profile.dart';
import 'package:encro/views/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';

class RequestingPage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const RequestingPage({
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<RequestingPage> createState() => _RequestingPageState();
}

class _RequestingPageState extends State<RequestingPage> {
  List<Request> receivedRequests = [];
  List<Request> sentRequests = [];

  @override
  void initState() {
    super.initState();
    frequests();
  }

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Page'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 16.0),
            child: Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      const Tab(
                        text: 'Received Requests',
                      ),
                      const Tab(
                        text: 'Sent Requests',
                      ),
                    ],
                    indicator: BoxDecoration(
                      color: const Color.fromARGB(255, 251, 252, 252),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    labelColor: const Color.fromARGB(255, 5, 5, 5),
                    unselectedLabelColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: frequests,
              child: ListView.builder(
                itemCount: receivedRequests.length,
                itemBuilder: (context, index) {
                  final request = receivedRequests[index];
                  return ListTile(
                    title: Text(request.fromUser),
                    subtitle: Text(request.status),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            _respondToFriendRequest(request.id, 'accept');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _respondToFriendRequest(request.id, 'decline');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: frequests,
              child: ListView.builder(
                itemCount: sentRequests.length,
                itemBuilder: (context, index) {
                  final request = sentRequests[index];
                  return ListTile(
                    title: Text(request.toUser),
                    subtitle: Text(request.status),
                  );
                },
              ),
            ),
          ],
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

  Future<void> _respondToFriendRequest(int requestId, String action) async {
    final url = '$baseUrl/api/respond_to_friend_request/$requestId/$action/';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    final response = await http.put(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // Request successful, you can handle the response accordingly
      // For example, show a snackbar or update the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Friend request $action.'),
        ),
      );
      // Refresh the list of requests after responding
      frequests();
    } else {
      // Handle the error case
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to respond to friend request.'),
        ),
      );
    }
  }
}
