class User {
  int id;
  UserProfile profile;
  String password;
  String lastLogin;
  bool isSuperuser;
  String email;
  String username;
  String firstName;
  String lastName;
  bool isActive;
  bool isStaff;
  String dateJoined;
  List<int> groups;
  List<dynamic> userPermissions;

  User({
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
    required this.groups,
    required this.userPermissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      password: json['password'] as String,
      lastLogin: json['last_login'] as String,
      isSuperuser: json['is_superuser'] as bool,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isActive: json['is_active'] as bool,
      isStaff: json['is_staff'] as bool,
      dateJoined: json['date_joined'] as String,
      groups: (json['groups'] as List).map((e) => e as int).toList(),
      userPermissions: json['user_permissions'] as List<dynamic>,
    );
  }
}

class UserProfile {
  int id;
  User user;
  String profilePic;
  String bio;
  dynamic name; // Adjust the type based on your needs
  String hobbies;
  List<int> friends;
  List<int> restrictedFriends;
  List<int> blockedFriends;
  List<int> usedToBeFriends;

  UserProfile({
    required this.id,
    required this.user,
    required this.profilePic,
    required this.bio,
    required this.name,
    required this.hobbies,
    required this.friends,
    required this.restrictedFriends,
    required this.blockedFriends,
    required this.usedToBeFriends,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      profilePic: json['profile_pic'] as String,
      bio: json['bio'] as String,
      name: json['Name'],
      hobbies: json['Hobbies'] as String,
      friends: (json['Friends'] as List).map((e) => e as int).toList(),
      restrictedFriends:
          (json['Restriced_Friends'] as List).map((e) => e as int).toList(),
      blockedFriends:
          (json['Blocked_Friends'] as List).map((e) => e as int).toList(),
      usedToBeFriends:
          (json['Used_to_be_Friends'] as List).map((e) => e as int).toList(),
    );
  }
}
