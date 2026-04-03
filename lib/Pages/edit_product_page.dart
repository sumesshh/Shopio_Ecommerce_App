import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopio/provider/product_provider.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> data;

  const EditProductPage({
    super.key,
    required this.productId,
    required this.data,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descController;

  String selectedCategory = "";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.data['name']);
    priceController = TextEditingController(
      text: widget.data['price'].toString(),
    );
    descController = TextEditingController(
      text: widget.data['description'] ?? "",
    );
    selectedCategory = widget.data['category'];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(title: const Text("Edit Product"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController),
            TextField(controller: priceController),
            TextField(controller: descController),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.lightBlueAccent.withAlpha(180),
                ),
              ),
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      bool isMediaChanged =
                          provider.pickedImages != null ||
                          provider.pickedVideo != null;

                      await provider.updateProduct(
                        productId: widget.productId,
                        name: nameController.text,
                        price: priceController.text,
                        description: descController.text,
                        category: selectedCategory,
                        updateMedia: isMediaChanged,
                      );

                      Navigator.pop(context);
                    },
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Update",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
