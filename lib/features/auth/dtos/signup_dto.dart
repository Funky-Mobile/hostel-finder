/// This class represents the data required for a student to sign up.
class SignUpDto {
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

  /// This method creates a [SignUpDto] with all required fields.
  SignUpDto({
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
  });

  /// This method converts a JSON map into a [SignUpDto] object.
  factory SignUpDto.fromJson(Map<String, dynamic> json) {
    return SignUpDto(
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
    );
  }

  /// This method converts a [SignUpDto] object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId.trim(),
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phoneNumber': phoneNumber.startsWith('+')
          ? phoneNumber.trim()
          : '+233${phoneNumber.trim().replaceFirst(RegExp(r'^0'), '')}',
      'dob': dob.contains('/')
          ? dob.replaceAll('/', '-') // convert 2000/06/28 -> 2000-06-28
          : dob,
      'gender': gender.isNotEmpty
          ? '${gender[0].toUpperCase()}${gender.substring(1).toLowerCase()}'
          : gender,
      'faculty': faculty.trim(),
      'guardianContact': guardianContact.trim(),
      'address': address.trim(),
      'password': password,
    };
  }


  @override
  String toString() {
    return 'SignUpDto{studentId: $studentId, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, dob: $dob, gender: $gender, faculty: $faculty, guardianContact: $guardianContact, address: $address, password: $password}';
  }
}
