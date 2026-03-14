class CategoryModel {
  final String name;
  final String image;
  final bool isLast;

  CategoryModel({
    required this.name,
    required this.image,
    required this.isLast,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> data) {
    return CategoryModel(
      name: data['name'] ?? "",
      image: data['image'] ?? "",
      isLast: data['isLast'] ?? false,
    );
  }
}
