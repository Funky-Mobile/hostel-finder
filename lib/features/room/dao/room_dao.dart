class RoomDao {
  final String id;
  final String number;
  final String type;
  final int capacity;
  final double price;
  final List<String> amenities;
  final String status;
  final String description;
  final List<String> images;
  final String gender;

  RoomDao({
    required this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.price,
    required this.amenities,
    required this.status,
    required this.description,
    required this.images,
    required this.gender,
  });

  factory RoomDao.fromJson(Map<String, dynamic> json) {
    return RoomDao(
      id: json['id'],
      number: json['number'],
      type: json['type'],
      capacity: json['capacity'],
      price: (json['price'] as num).toDouble(),
      amenities: List<String>.from(json['amenities']),
      status: json['status'],
      description: json['description'],
      images: List<String>.from(json['images']),
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'type': type,
      'capacity': capacity,
      'price': price,
      'amenities': amenities,
      'status': status,
      'description': description,
      'images': images,
      'gender': gender,
    };
  }

  static List<RoomDao> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => RoomDao.fromJson(json)).toList();
  }
}