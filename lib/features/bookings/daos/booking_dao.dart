class BookingDao {
  final String id;
  final String roomId;
  final String roomNumber;
  final String roomType;
  final String customerName;
  final String customerEmail;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalAmount;
  final String paymentStatus;
  final String bookingStatus;
  final DateTime bookingDate;
  final List<String> amenities;
  final String gender;
  final int capacity;
  final String? specialRequests;

  BookingDao({
    required this.roomId,
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.customerName,
    required this.customerEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalAmount,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.bookingDate,
    required this.amenities,
    required this.gender,
    required this.capacity,
    this.specialRequests,
  });

  factory BookingDao.fromJson(Map<String, dynamic> json) {
    return BookingDao(
      id: json['id'],
      roomId: json['roomId'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      checkInDate: DateTime.parse(json['checkInDate']),
      checkOutDate: DateTime.parse(json['checkOutDate']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'],
      bookingStatus: json['bookingStatus'],
      bookingDate: DateTime.parse(json['bookingDate']),
      amenities: List<String>.from(json['amenities'] ?? []),
      gender: json['gender'],
      capacity: json['capacity'],
      specialRequests: json['specialRequests'],
    );
  }

  static List<BookingDao> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BookingDao.fromJson(json)).toList();
  }

  int get durationInDays {
    return checkOutDate.difference(checkInDate).inDays;
  }

  bool get isActive {
    final now = DateTime.now();
    return checkInDate.isBefore(now) && checkOutDate.isAfter(now);
  }

  bool get isUpcoming {
    return checkInDate.isAfter(DateTime.now());
  }

  bool get isPast {
    return checkOutDate.isBefore(DateTime.now());
  }

  @override
  String toString() {
    return 'BookingDao{id: $id, roomId: $roomId, roomNumber: $roomNumber, roomType: $roomType, customerName: $customerName, customerEmail: $customerEmail, checkInDate: $checkInDate, checkOutDate: $checkOutDate, totalAmount: $totalAmount, paymentStatus: $paymentStatus, bookingStatus: $bookingStatus, bookingDate: $bookingDate, amenities: $amenities, gender: $gender, capacity: $capacity, specialRequests: $specialRequests}';
  }
}