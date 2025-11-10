class Place {
  String name;
  String state;
  String imageUrl;
  double rating;
  String description;
  String contact;
  double latitude;
  double longitude;
  String category;

  Place(
    this.name,
    this.state,
    this.imageUrl,
    this.rating,
    this.description,
    this.contact,
    this.latitude,
    this.longitude,
    this.category,
  );
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'state': state,
      'image_url': imageUrl,
      'rating': rating,
      'description': description,
      'contact': contact,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };
  }
  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      map['name'] ?? 'Unknown',
      map['state'] ?? 'Unknown',
      map['image_url'] ?? '',
      (map['rating'] is num) ? (map['rating'] as num).toDouble() : 0.0,
      map['description'] ?? 'No description available.',
      map['contact'] ?? 'No contact info.',
      double.tryParse(map['latitude']?.toString() ?? '') ?? 0.0,
      double.tryParse(map['longitude']?.toString() ?? '') ?? 0.0,
      map['category'] ?? 'Uncategorized',
    );
  }
  factory Place.fromJson(Map<String, dynamic> json) => Place.fromMap(json);
}
