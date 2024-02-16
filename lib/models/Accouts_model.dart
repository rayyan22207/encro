class CustomUser {
  final int id;
  final CustomUserProfile? profile;
  final String password;
  final DateTime? lastLogin;
  final bool isSuperuser;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;
  final DateTime dateJoined;
  final List<dynamic> groups;
  final List<dynamic> userPermissions;

  CustomUser({
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

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      id: json['id'] as int,
      profile: json['profile'] != null
          ? CustomUserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      password: json['password'] as String,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      isSuperuser: json['is_superuser'] as bool,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      isActive: json['is_active'] as bool,
      isStaff: json['is_staff'] as bool,
      dateJoined: DateTime.parse(json['date_joined'] as String),
      groups: json['groups'] as List<dynamic>,
      userPermissions: json['user_permissions'] as List<dynamic>,
    );
  }
}

class CustomUserProfile {
  final int id;
  final String profilePic;
  final String? bio;
  final String? name;
  final String? hobbies;
  final int user;
  final List<dynamic> friends;
  final List<dynamic> restrictedFriends;
  final List<dynamic> blockedFriends;
  final List<dynamic> usedToBeFriends;

  CustomUserProfile({
    required this.id,
    required this.profilePic,
    this.bio,
    this.name,
    this.hobbies,
    required this.user,
    required this.friends,
    required this.restrictedFriends,
    required this.blockedFriends,
    required this.usedToBeFriends,
  });

  factory CustomUserProfile.fromJson(Map<String, dynamic> json) {
    return CustomUserProfile(
      id: json['id'] as int,
      profilePic: json['profile_pic'] as String,
      bio: json['bio'] as String?,
      name: json['Name'] as String?,
      hobbies: json['Hobbies'] as String?,
      user: json['user'] as int,
      friends: json['Friends'] as List<dynamic>,
      restrictedFriends: json['Restriced_Friends'] as List<dynamic>,
      blockedFriends: json['Blocked_Friends'] as List<dynamic>,
      usedToBeFriends: json['Used_to_be_Friends'] as List<dynamic>,
    );
  }
}
