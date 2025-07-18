class Place {
  final String title;
  final String description;
  final List<String> categories;
  final List<String> images;

  Place({
    required this.title,
    required this.description,
    required this.images,
    required this.categories,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'],
      description: json['description'],
      images: List<String>.from(json['images']),
      categories: List<String>.from(json['categories']),
    );
  }
}
