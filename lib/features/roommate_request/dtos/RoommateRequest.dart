class RoommateRequest {
  final String id;
  final String requesterId;
  final String roomId;
  final String preferences;
  final bool open;
  final List<String> joinedStudentIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoommateRequest({
    required this.id,
    required this.requesterId,
    required this.roomId,
    required this.preferences,
    required this.open,
    required this.joinedStudentIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoommateRequest.fromJson(Map<String, dynamic> json) {
    return RoommateRequest(
      id: json['id'] ?? '',
      requesterId: json['requesterId'] ?? '',
      roomId: json['roomId'] ?? '',
      preferences: json['preferences'] ?? '',
      open: json['open'] ?? false,
      joinedStudentIds: List<String>.from(json['joinedStudentIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
