class frndUserProfile {
  final User requestingUser;
  final List<Request> receivedRequests;
  final List<Request> sentRequests;

  frndUserProfile({
    required this.requestingUser,
    required this.receivedRequests,
    required this.sentRequests,
  });

  factory frndUserProfile.fromJson(Map<String, dynamic> json) {
    return frndUserProfile(
      requestingUser: User.fromJson(json['requesting_user']),
      receivedRequests: (json['received_requests'] as List)
          .map((item) => Request.fromJson(item))
          .toList(),
      sentRequests: (json['sent_requests'] as List)
          .map((item) => Request.fromJson(item))
          .toList(),
    );
  }
}

class User {
  final String user;
  final String userPfp;
  final int userId;
  final String userEmail;

  User({
    required this.user,
    required this.userPfp,
    required this.userId,
    required this.userEmail,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: json['user'],
      userPfp: json['user_pfp'],
      userId: json['user_id'],
      userEmail: json['user_email'],
    );
  }
}

class Request {
  final int id;
  final String fromUser;
  final String toUser;
  final String status;

  Request({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.status,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      fromUser: json['from_user'],
      toUser: json['to_user'],
      status: json['status'],
    );
  }

  get username => null;
}
