import 'dart:convert';
import 'package:encro/api_http_request/api_endpoints.dart';
import 'package:encro/authentication/api_auth.dart';
import 'package:encro/models/chatlistingmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final List<Participant> participants;

  const UserProfile({
    required this.participants,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var currentUser;
  var currentUserEmail;
  var currentUserID;

  @override
  void initState() {
    super.initState();
    fechRequestUserPfp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Row(children: [
                for (var participant in widget.participants)
                  if (participant.username != currentUser)
                    Row(
                      children: [
                        Text(participant.email),
                      ],
                    )
              ]),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          for (var participant in widget.participants)
            if (participant.username != currentUser)
              Column(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(participant.profile!.profilePic),
                      ),
                    ],
                  ),
                  Text('${participant.profile?.bio}'),
                  SizedBox(width: 5),
                  Text('''
${participant.email}
${participant.username}
${participant.profile?.profilePic}

${participant.profile?.hobbies}
${participant.profile?.name}

'''),
                ],
              )
        ],
      ),
    );
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
}
