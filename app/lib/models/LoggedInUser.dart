class UserData {
  final String userId;
  final String name;
  final String profilePictureUrl;

  UserData({
    required this.userId,
    required this.name,
    required this.profilePictureUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      profilePictureUrl: json['profile_picture_url'] ?? '',
    );
  }
}
