class CreateBookingRequest {
  final String studentId;
  final String roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double amountPaid;

  CreateBookingRequest({
    required this.studentId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.amountPaid,
  });

  Map<String, dynamic> toJson() {
    return {
      "studentId": studentId,
      "roomId": roomId,
      "checkInDate": checkInDate.toIso8601String(),
      "checkOutDate": checkOutDate.toIso8601String(),
      "amountPaid": amountPaid,
    };
  }
}
