
class User {
  final String id;
  final String studentId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dob;
  final String gender;
  final String faculty;
  final String guardianContact;
  final String address;
  final String password;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.faculty,
    required this.guardianContact,
    required this.address,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      studentId: json['studentId'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      dob: json['dob'],
      gender: json['gender'],
      faculty: json['faculty'],
      guardianContact: json['guardianContact'],
      address: json['address'],
      password: json['password'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'dob': dob,
    'gender': gender,
    'faculty': faculty,
    'guardianContact': guardianContact,
    'address': address,
    'password': password,
    'role': role,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'User{id: $id, studentId: $studentId, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, dob: $dob, gender: $gender, faculty: $faculty, guardianContact: $guardianContact, address: $address, password: $password, role: $role, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
