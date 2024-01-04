class UserRegistration {
  final String user_id;
  final String name;
  final String email;
  final String password;
  final String sex;
  final String address;
  final DateTime birthdate;
  final String userPhoto;

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

  // Convert the UserRegistration object to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'name': name,
      'email': email,
      'password': password,
      'sex': sex,
      'address': address,
      'birthdate':
          birthdate.toIso8601String(), // Convert DateTime to ISO 8601 string
      'userPhoto': userPhoto,
    };
  }

  // Factory constructor to create a UserRegistration object from a map
  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
      user_id: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      sex: json['sex'],
      address: json['address'],
      birthdate: DateTime.parse(json['birthdate']),
      userPhoto: json['userPhoto'],
    );
  }
}
