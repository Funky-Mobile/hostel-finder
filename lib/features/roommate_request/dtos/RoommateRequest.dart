class RoommateRequest {
  final String id;
  final String studentId;
  final String roomId;
  final String preferences;
  final String status;
  final String? partnerStudentId;
  final String studentName;
  final String roomNumber;

  RoommateRequest({
    required this.id,
    required this.studentId,
    required this.roomId,
    required this.preferences,
    required this.status,
    this.partnerStudentId,
    required this.studentName,
    required this.roomNumber,
  });

  factory RoommateRequest.fromJson(Map<String, dynamic> json) {
    return RoommateRequest(
      id: json['id'],
      studentId: json['studentId'],
      roomId: json['roomId'],
      preferences: json['preferences'],
      status: json['status'],
      partnerStudentId: json['partnerStudentId'],
      studentName: json['studentName'] ?? 'Unknown',
      roomNumber: json['roomNumber'] ?? 'Unknown',
    );
  }
}