import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinity/model/productModel.dart' hide Image;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Provider/product/product_provider.dart';
import 'Add_product.dart';



class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String? userRole;
  @override
  void initState() {
    super.initState();
    _loadUserRole();
    // Fetch API on start
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }
  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role'); // 👈 e.g. "admin" or "staff"
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (userRole == 'admin')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add Product",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.products.isEmpty
          ? const Center(child: Text("No products found"))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          // final product = provider.products[index];
          // final imageUrl = product.image != null &&
          //     product.image!.isNotEmpty
          //     ? product.image!.first.url
          //     : "https://via.placeholder.com/150";
          final product = provider.products[index];
          final imageUrl = (product.image != null &&
              product.image!.isNotEmpty &&
              product.image![0].url != null &&
              product.image![0].url!.isNotEmpty)
              ? product.image![0].url!
              : "https://via.placeholder.com/150"; // fallback


          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      height: 120,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  )

                  // Image.network(
                  //   imageUrl!,
                  //   height: 120,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name ?? "Unknown",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "₨ ${product.price}",
                    style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Orders: ${product.totalOrders}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                if (userRole == 'admin')
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _showEditDialog(context, product, provider);
                      },
                      icon: const Icon(Icons.edit_document, color: Colors.blue),
                    ),


                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Product'),
                            content: const Text('Are you sure you want to delete this product?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );

                        // If user pressed "Yes"
                        if (confirm == true) {
                          provider.deleteProduct("${product.sId}");

                          // Optional: show success message/snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product deleted successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    )

                  ],
                )

              ],
            ),
          );
        },
      ),
    );
  }
  void _showEditDialog(BuildContext context, Data product, ProductProvider provider) {
    final nameController = TextEditingController(text: product.name ?? '');
    final priceController = TextEditingController(text: product.price?.toString() ?? '');
    final totalOrdersController = TextEditingController(text: product.totalOrders?.toString() ?? '');

    File? pickedImageFile;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Product"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product name
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Product Name"),
                    ),

                    // Product price
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                    ),

                    // Total Orders
                    TextField(
                      controller: totalOrdersController,
                      decoration: const InputDecoration(labelText: "Total Orders"),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 10),

                    // Image preview
                    pickedImageFile != null
                        ? Image.file(pickedImageFile!, height: 100)
                        : (product.image != null && product.image!.isNotEmpty)
                        ? Image.network(product.image![0].url ?? '', height: 100)
                        : const Icon(Icons.image, size: 80, color: Colors.grey),

                    const SizedBox(height: 8),

                    // Pick Image button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            pickedImageFile = File(pickedFile.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Pick Image"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.updateProduct(
                      id: product.sId ?? '',
                      name: nameController.text,
                      price: priceController.text,
                      totalOrders: totalOrdersController.text,
                      imageFile: pickedImageFile, // pass image file
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }


}
