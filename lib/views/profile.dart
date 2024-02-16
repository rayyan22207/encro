//import 'package:encro/models/OwnUserModel.dart';
import 'package:encro/views/request.dart';
import 'package:encro/views/search.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:convert';
import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:encro/authentication/api_auth.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const ProfilePage({
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var currentUser;
  var currentUserEmail;
  var currentUserID;
  var user;
  var currentUserPfp;

  @override
  void initState() {
    super.initState();
    fechRequestUserPfp();
    //fechUserProfile();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage('$baseUrl$currentUserPfp'),
              radius: 30,
            ),
            Text(currentUser),
            Text(currentUserEmail)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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

  Future<String> fechRequestUserPfp() async {
    final url = '$baseUrl/api/request-user';
    final uri = Uri.parse(url);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    http.Response response = await http.get(uri, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      setState(() {
        currentUser = data['user'];
        currentUserPfp = data['user_pfp'];
        currentUserID = data['user_id'];
        currentUserEmail = data['user_email'];
      });
      return data['user_pfp'];
    } else {
      print('Request failed with status: ${response.statusCode}');
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png';
    }
  }

  // Future<void> fechUserProfile() async {
  //   final url = '$baseUrl/api/auth/users/$currentUserID/';
  //   final uri = Uri.parse(url);
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final authToken = authProvider.authToken;
  //   final headers = {
  //     'Authorization': 'Token $authToken',
  //   };
  //   http.Response response = await http.get(uri, headers: headers);
  //   var data = json.decode(response.body);
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       user = User.fromJson(data as Map<String, dynamic>);
  //     });
  //   }
  // }
}
