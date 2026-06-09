import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
  json.decode(str).map((x) => ProductModel.fromJson(x)),
);

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final Category category;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"] ?? 0,
    title: json["title"] ?? '',
    slug: json["slug"] ?? '',
    price: (json["price"] as num?)?.toDouble() ?? 0.0,
    description: json["description"] ?? '',
    category: Category.fromJson(json["category"] ?? {}),
    images:
        json["images"] != null
            ? List<String>.from(json["images"].map((x) => x.toString()))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "price": price,
    "description": description,
    "category": category.toJson(),
    "images": List<dynamic>.from(images.map((x) => x)),
  };
}

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
