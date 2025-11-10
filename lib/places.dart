class Place {
  final String name;
  final String state;
  final String imageUrl;
  final double rating;
  final String description;
  final String contact;
  final double latitude;
  final double longitude;
  final String category;

  Place({
    required this.name,
    required this.state,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.contact,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  // Factory constructor to create Place from JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Unknown',
      state: json['state'] ?? 'Unknown',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      description: json['description'] ?? 'No description available.',
      contact: json['contact'] ?? 'No contact info.',
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      category: json['category'] ?? 'Uncategorized',
    );
  }
}
