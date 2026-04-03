// class Productmodels {
//   final String id;
//   final String name;
//   final double price;
//   final String description;
//   final String category;
//   final List<String> mediaUrls;
//   final String createdBy;

//   Productmodels({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.mediaUrls,
//     required this.createdBy,
//   });

//   factory Productmodels.fromFirestore(Map<String, dynamic> data, String id) {
//     return Productmodels(
//       id: id,
//       // name: data['name'] ?? '',
//       name: (data['name'] ?? '').toString().toLowerCase(),
//       price: data['price'] is String
//           ? double.tryParse(data['price']) ?? 0
//           : (data['price'] ?? 0).toDouble(),
//       description: data['description'] ?? '',
//       category: data['category'] ?? '',
//       mediaUrls:
//           (data['media'] as List<dynamic>?)
//               ?.map((item) => item['url'] as String)
//               .toList() ??
//           [],
//       createdBy: data['createdBy'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'description': description,
//       'category': category,
//       'createdBy': createdBy,
//     };
//   }
// }
class Productmodels {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final List<String> mediaUrls;
  final String createdBy;

  Productmodels({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.mediaUrls,
    required this.createdBy,
  });

  factory Productmodels.fromFirestore(Map<String, dynamic> data, String id) {
    return Productmodels(
      id: id,

      // 🔥 FIXED (important for search)
      name: (data['name'] ?? '').toString().toLowerCase(),

      price: data['price'] is String
          ? double.tryParse(data['price']) ?? 0
          : (data['price'] ?? 0).toDouble(),

      description: data['description'] ?? '',
      category: data['category'] ?? '',

      // 🔥 SAFE MEDIA PARSING
      mediaUrls:
          (data['media'] as List<dynamic>?)
              ?.map((item) {
                if (item is Map && item['url'] != null) {
                  return item['url'].toString();
                }
                return '';
              })
              .where((url) => url.isNotEmpty)
              .toList() ??
          [],

      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'createdBy': createdBy,
    };
  }
}
