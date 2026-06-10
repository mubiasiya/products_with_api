class Category {
  final int id;
  final String name;
  final String image;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    image: json["image"] ?? '',
    slug: json["slug"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "slug": slug,
  };
}
