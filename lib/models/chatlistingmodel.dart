class Chat_listing {
  final String id;
  final List<Participant>? participants;
  final List<Message>? messages;

  Chat_listing({
    required this.id,
    this.participants,
    this.messages,
  });

  factory Chat_listing.fromJson(Map<String, dynamic> json) {
    var participantsList = json['participants'] as List?;
    var messagesList = json['messages'] as List?;

    List<Participant>? participants;
    List<Message>? messages;

    if (participantsList != null) {
      participants =
          participantsList.map((i) => Participant.fromJson(i)).toList();
    }

    if (messagesList != null) {
      messages = messagesList.map((i) => Message.fromJson(i)).toList();
    }

    return Chat_listing(
      id: json['id'],
      participants: participants,
      messages: messages,
    );
  }
}

class Participant {
  final int id;
  final String email;
  final String username;
  final Profile? profile;

  Participant({
    required this.id,
    required this.email,
    required this.username,
    this.profile,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}

class Profile {
  final int id;
  final User user;
  final String profilePic;
  final String bio;
  final String? name;
  final String hobbies;
  final List<int> friends;
  final List<int> restrictedFriends;
  final List<int> blockedFriends;
  final List<int> usedToBeFriends;

  Profile({
    required this.id,
    required this.user,
    required this.profilePic,
    required this.bio,
    this.name,
    required this.hobbies,
    required this.friends,
    required this.restrictedFriends,
    required this.blockedFriends,
    required this.usedToBeFriends,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      user: User.fromJson(json['user']),
      profilePic: json['profile_pic'],
      bio: json['bio'] ?? "", // Default value for bio if it's null
      name: json['Name'],
      hobbies: json['Hobbies'],
      friends: List<int>.from(json['Friends'] ?? []),
      restrictedFriends: List<int>.from(json['Restriced_Friends'] ?? []),
      blockedFriends: List<int>.from(json['Blocked_Friends'] ?? []),
      usedToBeFriends: List<int>.from(json['Used_to_be_Friends'] ?? []),
    );
  }
}

class User {
  final int id;
  final String email;
  final String username;

  User({
    required this.id,
    required this.email,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
    );
  }
}

class Message {
  final Sender sender;
  final DateTime timestamp;
  final String content;

  Message({
    required this.sender,
    required this.timestamp,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: Sender.fromJson(json['sender']),
      timestamp: DateTime.parse(json['timestamp']),
      content: json['content'],
    );
  }
}

class Sender {
  final int id;
  final String email;
  final String username;
  final Profile? profile;

  Sender({
    required this.id,
    required this.email,
    required this.username,
    this.profile,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}
