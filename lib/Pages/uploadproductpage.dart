import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopio/provider/product_provider.dart';
import 'package:shopio/widget/buttoncolor.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),

      appBar: AppBar(
        title: const Text("Add Product"),
        centerTitle: true,
        backgroundColor: Color(0xFFF2F2F2),
      ),
      // appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Select Images
            ButtonColor(
              text: "Select Images",
              isFullWidth: true,
              onTap: () => context.read<ProductProvider>().pickImages(),
            ),

            const SizedBox(height: 12),

            if (productProvider.pickedImages != null &&
                productProvider.pickedImages!.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.pickedImages!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(productProvider.pickedImages![index].path),
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Dynamic Categories Dropdown
            StreamBuilder<QuerySnapshot>(
              stream: productProvider.getCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final categories = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  value: selectedCategory,
                  hint: const Text("Select Category"),
                  items: categories.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['name'],
                      child: Text(doc['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            ButtonColor(
              text: productProvider.isLoading
                  ? "Uploading..."
                  : "Upload Product",
              isFullWidth: true,
              onTap: productProvider.isLoading
                  ? null
                  : () async {
                      if (selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Select category")),
                        );
                        return;
                      }

                      await context.read<ProductProvider>().uploadProduct(
                        name: nameController.text,
                        price: priceController.text,
                        description: descriptionController.text,
                        category: selectedCategory!,
                        context: context,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
