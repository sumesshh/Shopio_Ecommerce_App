import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopio/Pages/category_products_page.dart';
import 'package:shopio/Pages/categorypages.dart';
import 'package:shopio/models/product_models.dart';
import 'package:shopio/widget/All_products.dart';
import 'package:shopio/widget/Categories.dart';
import 'package:shopio/widget/support_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Pages/productdetailpage.dart';
import 'package:shopio/widget/category_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER (USER NAME + PROFILE IMAGE)
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  final userName = userData['name'] ?? "User";
                  final imageUrl = userData['image'] ?? "";

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hey, $userName",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepPurple.shade100,

                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : null,

                        child: imageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: Colors.deepPurple,
                                size: 30,
                              )
                            : null,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              /// SEARCH BAR
              Container(
                padding: const EdgeInsets.only(left: 10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: Appwidget.lightTextFieldStyle(),

                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// CATEGORIES TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories", style: Appwidget.semiBoldTextStyle()),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoriesPage(),
                        ),
                      );
                    },

                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.lightBlueAccent.withAlpha(180),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// CATEGORY LIST (FROM MODEL)
              SizedBox(
                height: 110,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 15),

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryProductsPage(category: category.name),
                            ),
                          );
                        },

                        child: Container(
                          width: 90,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                category.image,
                                height: 45,
                                width: 45,
                              ),

                              const SizedBox(height: 6),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),

                                child: Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              /// PRODUCTS TITLE
              Text("All Products", style: Appwidget.semiBoldTextStyle()),

              const SizedBox(height: 15),

              /// PRODUCT LIST
              SizedBox(
                height: 240,

                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(child: Text("No Products"));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,

                      itemBuilder: (context, index) {
                        final product = Productmodels.fromFirestore(
                          docs[index].data() as Map<String, dynamic>,
                          docs[index].id,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(right: 15),

                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Productdetails(product: product),
                                ),
                              );
                            },

                            child: ProductCards(product: product),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
