import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinity/compoents/AppTextfield.dart';
import 'package:provider/provider.dart';

import '../../Provider/product/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isEnable = true;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Add Product',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile == null
                      ? Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[200],
                    child: const Icon(Icons.camera_alt, size: 50),
                  )
                      : Image.file(_imageFile!, height: 150, width: 150, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                AppTextField(controller: _nameController, label: 'Product Name',
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 10),
                AppTextField(controller:_priceController, label:'Price',
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter price' : null,),
                // TextFormField(
                //   controller: _priceController,
                //   decoration: const InputDecoration(labelText: 'Price'),
                //   keyboardType: TextInputType.number,
                //   validator: (value) => value!.isEmpty ? 'Enter price' : null,
                // ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Is Enabled?'),
                  value: _isEnable,
                  onChanged: (val) => setState(() => _isEnable = val),
                ),
                const SizedBox(height: 20),
                provider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _imageFile != null) {
                      provider.addProduct(
                        name: _nameController.text.trim(),
                        price: _priceController.text.trim(),
                        isEnable: _isEnable,
                        imageFile: _imageFile!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields & pick an image')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
