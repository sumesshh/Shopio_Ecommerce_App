import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopio/Pages/category_products_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF2F2F2),
      ),

      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .orderBy('isLast')
              .orderBy('name')
              .snapshots(),

          builder: (context, snapshot) {
            /// Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            /// Error
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            /// No data
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Categories Found"));
            }

            final categories = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(16),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),

              itemCount: categories.length,

              itemBuilder: (context, index) {
                final data = categories[index].data() as Map<String, dynamic>;

                final categoryName = data['name'] ?? "No Name";
                final imageUrl = data['image'] ?? "";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryProductsPage(category: categoryName),
                      ),
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// CATEGORY IMAGE
                        if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),

                            child: Image.network(
                              imageUrl,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,

                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.category,
                                  size: 60,
                                  color: Colors.blue,
                                );
                              },
                            ),
                          )
                        else
                          Icon(
                            getCategoryIcon(categoryName),
                            size: 60,
                            color: Colors.blue,
                          ),
                        const SizedBox(height: 12),

                        /// CATEGORY NAME
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),

                          child: Text(
                            categoryName,
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case "Beauty & Personal Care":
        return Icons.spa;

      case "Electronics":
        return Icons.devices;

      case "Fashion":
        return Icons.checkroom;

      case "Kids Fashion":
        return Icons.child_care;

      case "Laptops":
        return Icons.laptop_mac;

      case "Mobiles":
        return Icons.smartphone;

      case "vehicles":
        return Icons.directions_car;

      case "Others":
        return Icons.widgets;

      default:
        return Icons.category;
    }
  }
}
