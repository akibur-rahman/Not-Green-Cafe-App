class UserRegistration {
  final String user_id;
  final String name;
  final String email;
  final String password;
  final String sex;
  final String address;
  final DateTime birthdate;
  final String userPhoto; // Assuming userPhoto is the profile picture URL

  UserRegistration({
    required this.user_id,
    required this.name,
    required this.email,
    required this.password,
    required this.sex,
    required this.address,
    required this.birthdate,
    required this.userPhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'name': name,
      'email': email,
      'password': password,
      'sex': sex,
      'address': address,
      'birthdate': birthdate.toIso8601String(),
      'profile_picture_url': userPhoto, // Updated line
    };
  }
}
