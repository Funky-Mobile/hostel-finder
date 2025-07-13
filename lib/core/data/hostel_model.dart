class HostelModel {
  final String id; // typically the Google Place ID
  final String name;
  final String location;
  final double rating;
  final int totalRatings;
  final List<String> photos;
  final List<String> amenities;
  final String overview;
  final List<ReviewModel> reviews;
  final String? phoneNumber;

  HostelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.totalRatings,
    required this.photos,
    required this.amenities,
    required this.overview,
    required this.reviews,
    required this.phoneNumber,
  });

  // ✅ JSON serialization (excluding reviews for favorites persistence)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'rating': rating,
    'totalRatings': totalRatings,
    'photos': photos,
    'amenities': amenities,
    'overview': overview,
    'phoneNumber': phoneNumber,
    // reviews are omitted from favorites persistence
  };

  factory HostelModel.fromJson(Map<String, dynamic> json) => HostelModel(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    rating: (json['rating'] as num).toDouble(),
    totalRatings: json['totalRatings'],
    photos: List<String>.from(json['photos']),
    amenities: List<String>.from(json['amenities']),
    overview: json['overview'],
    phoneNumber: json['phoneNumber'],
    reviews: [], // will be empty if restored from favorites
  );
}


class ReviewModel {
  final String reviewerName;
  final String reviewDate;
  final String reviewText;
  final String? profilePhotoUrl;
  final String? profileLink;
  final int rating;

  ReviewModel({
    required this.reviewerName,
    required this.reviewDate,
    required this.reviewText,
    this.profilePhotoUrl,
    this.profileLink,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
    'reviewerName': reviewerName,
    'reviewDate': reviewDate,
    'reviewText': reviewText,
    'profilePhotoUrl': profilePhotoUrl,
    'profileLink': profileLink,
    'rating': rating,
  };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    reviewerName: json['reviewerName'],
    reviewDate: json['reviewDate'],
    reviewText: json['reviewText'],
    profilePhotoUrl: json['profilePhotoUrl'],
    profileLink: json['profileLink'],
    rating: json['rating'],
  );
}
