// class Productmodels {
//   final String id;
//   final String name;
//   final double price;
//   final String description;
//   final String category;
//   final List<String> imageUrls;
//   final String createdBy;

//   Productmodels({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.imageUrls,
//     required this.createdBy,
//   });

//   factory Productmodels.fromFirestore(Map<String, dynamic> data, String id) {
//     return Productmodels(
//       id: id,
//       name: data['name'] ?? '',
//       price: (data['price'] as num).toDouble(),
//       description: data['description'] ?? '',
//       category: data['category'] ?? '',
//       imageUrls: List<String>.from(data['imageUrls'] ?? []),
//       createdBy: data['createdBy'] ?? '',
//     );
//   }
// }
class Productmodels {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final List<String> imageUrls;
  final String createdBy;

  Productmodels({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrls,
    required this.createdBy,
  });

  /// Convert Firestore document → Productmodels
  factory Productmodels.fromFirestore(Map<String, dynamic> data, String id) {
    return Productmodels(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdBy: data['createdBy'] ?? '',
    );
  }

  /// Convert Productmodels → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'imageUrls': imageUrls,
      'createdBy': createdBy,
    };
  }
}
