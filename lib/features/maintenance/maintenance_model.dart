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
    print("🔧 PARSING MAINTENANCE MODEL FROM: $json");

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

      print("✅ SUCCESSFULLY CREATED MODEL: $model");
      return model;

    } catch (e) {
      print("❌ ERROR IN fromJson: $e");
      print("🔍 INPUT JSON: $json");
      rethrow;
    }
}}
