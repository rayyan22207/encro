import 'dart:convert';
import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:encro/authentication/api_auth.dart';
import 'package:encro/models/chatlistingmodel.dart';
import 'package:encro/tests/test3.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatPage extends StatefulWidget {
  final List<Participant> participants;
  final List<Message>? messages;
  final String chat_id;

  const ChatPage(
      {required this.participants,
      required this.messages,
      required this.chat_id});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Chat_listing> chatList = [];
  var currentUser;
  var currentUserEmail;
  var currentUserID;
  var otherUser;
  var otherUserId;
  var otherUserpfp;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  late IOWebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    fechRequestUserPfp();
    fechChatList();
    print(widget.chat_id);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.authToken;
    _channel = IOWebSocketChannel.connect(
      'ws://8619-2400-adc1-4ac-f800-711a-a79c-8bfd-e489.ngrok-free.app/ws/direct/${widget.chat_id}/?token=$token',
    );

    // Listen for WebSocket messages
    _channel.stream.listen((message) {
      var data = json.decode(message);
      var receivedMessage = data['message'];
      var senderID = data['senderID'];

      // Directly add the received message to the UI
      _addMessageToUI(receivedMessage, senderID);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
            title: const Text('Their Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(
                    participants: widget.participants,
                  ),
                ),
              );
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: const Text('Search'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text(
              'More on the way...',
              style: TextStyle(
                color: Color.fromARGB(255, 56, 56, 56),
              ),
            ),
            onTap: () {},
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  participants: widget.participants,
                ),
              ),
            );
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var participant in widget.participants)
                  if (participant.username != currentUser)
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(participant.profile!.profilePic),
                        ),
                        SizedBox(width: 5),
                        Text(participant.profile?.name ?? participant.username),
                      ],
                    ),
              ],
            ),
          ),
        ),
        actions: [
          Icon(Icons.video_call),
          SizedBox(width: 16),
          Icon(Icons.call),
          SizedBox(width: 8),
          IconButton(
            onPressed: () {
              _showPopupMenu(context);
            },
            icon: const Icon(Icons.menu),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: fechChatList,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.messages?.length ?? 0,
                itemBuilder: (context, index) {
                  final message = widget.messages![index];
                  final isCurrentUser = currentUserID == message.sender.id;

                  return Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? Color.fromARGB(217, 19, 19, 19)
                            : const Color.fromARGB(255, 166, 166, 166),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {
                    // Implement action when three dots icon is pressed
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement action when send button is pressed
                    String message = _textEditingController.text;
                    print(message);
                    // Handle sending the message
                    _sendMessage(message);
                    // You may want to clear the text field after sending
                    _textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        currentUserID = data['user_id'];
        currentUserEmail = data['user_email'];
      });
      return data['user_pfp'];
    } else {
      print('Request failed with status: ${response.statusCode}');
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png';
    }
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      var data = {'message': message};

      _channel.sink.add(json.encode(data));
    }
  }

  void _addMessageToUI(String message, int senderID) {
    // Create a Message object with the current user as the sender
    Message newMessage = Message(
      content: message,
      timestamp: DateTime.now(),
      sender: Sender(
          id: senderID,
          username: currentUser,
          email:
              currentUser), // You may need to adjust this based on your model
    );

    // Update the UI with the new message
    setState(() {
      widget.messages?.add(newMessage);
    });

    // Scroll to the bottom to show the latest message
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _channel.sink.close(status.normalClosure);
    super.dispose();
  }
}
