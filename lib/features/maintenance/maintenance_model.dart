class MaintenanceModel {
  final String id;
  final String studentId;
  final String roomId;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceModel({
    required this.id,
    required this.studentId,
    required this.roomId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a MaintenanceModel object from JSON
  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    try {
      final model = MaintenanceModel(
        id: json['id']?.toString() ?? '',
        studentId: json['studentId']?.toString() ?? json['student_id']?.toString() ?? '',
        roomId: json['roomId']?.toString() ?? json['room_id']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'].toString())
            : (json['created_at'] != null
            ? DateTime.parse(json['created_at'].toString())
            : DateTime.now()),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'].toString())
            : (json['updated_at'] != null
            ? DateTime.parse(json['updated_at'].toString())
            : DateTime.now()),
      );

      return model;

    } catch (e) {
      rethrow;
    }


}

  @override
  String toString() {
    return 'MaintenanceModel{id: $id, studentId: $studentId, roomId: $roomId, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
