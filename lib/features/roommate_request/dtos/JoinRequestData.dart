
class JoinRequestData {
  final String checkInDate;
  final String checkOutDate;
  final double amountPaid;

  JoinRequestData({
    required this.checkInDate,
    required this.checkOutDate,
    required this.amountPaid,
  });

  Map<String, dynamic> toJson() {
    return {
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'amountPaid': amountPaid,
    };
  }
}

class Room {
  final String id;
  final String number;

  Room({required this.id, required this.number});
}