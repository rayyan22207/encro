import 'dart:convert';
import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:encro/authentication/api_auth.dart';
import 'package:encro/models/chatlistingmodel.dart';
import 'package:encro/views/chat.dart';
import 'package:encro/views/profile.dart';
import 'package:encro/views/request.dart';
import 'package:encro/views/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Chat_listing> chatList = [];
  var currentUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fechChatList();
    fechRequestUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _getPage(index),
      ),
    );
  }

  void _showImageCard(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final pfp = await fechRequestUserPfp();
    print(pfp);
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1, 0, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            title: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('$baseUrl$pfp'),
                ),
                Text(currentUser),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('New group'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Encro'),
          actions: const [
            // CircleAvatar(
            //   radius: 25,
            //   backgroundImage: NetworkImage('$baseUrl$pfp'),
            // ),
            // InkWell(
            //   onTap: () {
            //     _showPopupMenu(context);
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.all(16.0),
            //     child: Icon(Icons.menu),
            //   ),
            // ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(kToolbarHeight + 16.0),
          //   child: Container(
          //     padding: const EdgeInsets.only(bottom: 16.0),
          //     child: Column(
          //       children: [
          //         TabBar(
          //           tabs: const [
          //             Tab(
          //               text: 'Chats',
          //             ),
          //             Tab(
          //               text: 'Archived',
          //             ),
          //             Tab(
          //               text: 'Restriced',
          //             ),
          //           ],
          //           indicator: BoxDecoration(
          //             color: const Color.fromARGB(255, 251, 252, 252),
          //             borderRadius: BorderRadius.circular(30),
          //           ),
          //           labelColor: const Color.fromARGB(255, 5, 5, 5),
          //           unselectedLabelColor: Colors.grey,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        body: TabBarView(
          children: [
            // Chats Tab
            RefreshIndicator(
              onRefresh: callsoffunc,
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final participants = chatList[index].participants;
                  final chat_id = chatList[index].id;
                  final messages = chatList[index].messages;
                  return Column(children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              participants: participants,
                              messages: messages,
                              chat_id: chat_id,
                            ),
                          ),
                        );
                      },
                      leading: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var participant in participants!)
                            if (participant.username != currentUser)
                              InkWell(
                                onTap: () {
                                  _showImageCard(
                                      context, participant.profile!.profilePic);
                                },
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(
                                      participant.profile!.profilePic),
                                ),
                              ),
                        ],
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var participant in participants)
                            if (participant.username != currentUser)
                              if (participant.profile?.name != null)
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          participants: participants,
                                          messages: messages,
                                          chat_id: chat_id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('${participant.profile?.name} '),
                                )
                              else
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          participants: participants,
                                          messages: messages,
                                          chat_id: chat_id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('${participant.username} '),
                                ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (messages != null && messages.isNotEmpty)
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      participants: participants,
                                      messages: messages,
                                      chat_id: chat_id,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text('${messages.last.content}'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]);
                },
              ),
            ),
            // Archived Tab
            const Center(
              child: Text('Archived Screen'),
            ),

            // Restricted Tab
            const Center(
              child: Text('Restricted Screen'),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _BottomNav,
          currentIndex: _selectedIndex,
          unselectedItemColor: const Color.fromARGB(255, 77, 77, 77),
          selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> get _BottomNav {
    return const [
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.bell_solid),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return SearchPage(
          selectedIndex: index,
          onIndexChanged: (p0) {},
        );
      case 2:
        return RequestingPage(
          selectedIndex: index,
          onIndexChanged: (p0) {},
        );
      case 3:
        return ProfilePage(
          selectedIndex: index,
          onIndexChanged: (p0) {},
        );
      default:
        return const HomePage(); // Handle the case of an unknown index
    }
  }

  Future<void> callsoffunc() async {
    fechChatList();
    fechRequestUser();
    fechRequestUserPfp();
  }

  Future<void> fechChatList() async {
    final url = '$baseUrl/api/onetoonechats/';
    final uri = Uri.parse(url);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authToken = authProvider.authToken;
    final headers = {
      'Authorization': 'Token $authToken',
    };
    http.Response response = await http.get(uri, headers: headers);
    var data = json.decode(response.body);
    print(data.runtimeType);
    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);
      chatList.clear();
      for (var data in dataList) {
        chatList.add(Chat_listing.fromJson(data as Map<String, dynamic>));
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<String?> fechRequestUser() async {
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
      setState(() {
        currentUser = data['user'];
      });
      return data['user'];
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
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
      setState(() {
        currentUser = data['user'];
      });
      return data['user_pfp'];
    } else {
      print('Request failed with status: ${response.statusCode}');
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png';
    }
  }
}
