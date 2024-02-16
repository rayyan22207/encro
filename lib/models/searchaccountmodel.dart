class UserProfile {
  final int id;
  final Profile profile;
  final String password;
  final String lastLogin;
  final bool isSuperuser;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;
  final String dateJoined;
  final List<dynamic>? groups;
  final List<dynamic>? userPermissions;

  UserProfile({
    required this.id,
    required this.profile,
    required this.password,
    required this.lastLogin,
    required this.isSuperuser,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isStaff,
    required this.dateJoined,
    this.groups,
    this.userPermissions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      profile: Profile.fromJson(json['profile']),
      password: json['password'] ?? "",
      lastLogin: json['last_login'] ?? "",
      isSuperuser: json['is_superuser'] ?? false,
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      isActive: json['is_active'] ?? false,
      isStaff: json['is_staff'] ?? false,
      dateJoined: json['date_joined'] ?? "",
      groups: json['groups'],
      userPermissions: json['user_permissions'],
    );
  }
}

class Profile {
  final int id;
  final User user;
  final String profilePic;
  final String bio;
  final String? name;
  final String? hobbies;
  final List<int>? friends;
  final List<int>? restricedFriends;
  final List<int>? blockedFriends;
  final List<int>? usedToBeFriends;

  Profile({
    required this.id,
    required this.user,
    required this.profilePic,
    required this.bio,
    this.name,
    this.hobbies,
    this.friends,
    this.restricedFriends,
    this.blockedFriends,
    this.usedToBeFriends,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      user: User.fromJson(json['user']),
      profilePic: json['profile_pic'] ?? "",
      bio: json['bio'] ?? "",
      name: json['Name'],
      hobbies: json['Hobbies'],
      friends: List<int>.from(json['Friends'] ?? []),
      restricedFriends: List<int>.from(json['Restriced_Friends'] ?? []),
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
      email: json['email'] ?? "",
      username: json['username'] ?? "",
    );
  }
}
