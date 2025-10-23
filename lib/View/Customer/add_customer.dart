
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/customer/customer_provider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  Widget build(BuildContext context) {


    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Add Customer',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Company Logo
            GestureDetector(
              onTap: provider.pickImage,
              child: provider.companyLogo != null
                  ? Image.file(provider.companyLogo!,
                  height: 100, width: 100, fit: BoxFit.cover)
                  : Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_a_photo, size: 40),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField(provider.businessTypeController, 'Business Type'),
            _buildTextField(provider.companyNameController, 'Company Name'),
            _buildTextField(provider.addressController, 'Address'),
            _buildTextField(provider.cityController, 'City'),
            _buildTextField(provider.emailController, 'Email'),
            _buildTextField(provider.phoneController, 'Phone Number'),

            const Divider(height: 40),
            const Text(
              'Person Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Dynamic Person Fields
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.personsList.length,
              itemBuilder: (context, index) {
                final person = provider.personsList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Person ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            if (provider.personsList.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    provider.removePerson(index),
                              ),
                          ],
                        ),
                        _buildTextField(person['fullName']!, 'Full Name'),
                        _buildTextField(person['designation']!, 'Designation'),
                        _buildTextField(person['department']!, 'Department'),
                        _buildTextField(person['phoneNumber']!, 'Phone Number'),
                        _buildTextField(person['email']!, 'Email'),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Add another person button
            OutlinedButton.icon(
              onPressed: provider.addPerson,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Person'),
            ),

            const Divider(height: 40),
            //_buildTextField(provider.assignedStaffController, 'Assigned Staff ID'),
            // Consumer<StaffProvider>(
            //   builder: (context, staffProvider, _) {
            //     final staffList = staffProvider.staffs;
            //
            //     if (staffProvider.isLoading) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //
            //     if (staffList.isEmpty) {
            //       return const Text('No staff available');
            //     }
            //
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 6),
            //       child: DropdownButtonFormField<String>(
            //         decoration: const InputDecoration(
            //           labelText: 'Assigned Staff',
            //           border: OutlineInputBorder(),
            //         ),
            //         value: provider.selectedStaffId,
            //         items: staffList.map((staff) {
            //           return DropdownMenuItem<String>(
            //             value: staff.username, // ID for backend
            //             child: Text(staff.username ?? 'Unnamed Staff'), // show name
            //           );
            //         }).toList(),
            //         onChanged: (value) {
            //           provider.selectedStaffName = value;
            //           provider.notifyListeners();
            //         },
            //       ),
            //     );
            //   },
            // ),
            Consumer<StaffProvider>(
              builder: (context, staffProvider, _) {
                final staffList = staffProvider.staffs;

                if (staffProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (staffList.isEmpty) {
                  return const Text('No staff available');
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Assigned Staff',
                      border: OutlineInputBorder(),
                    ),
                    // ✅ Ensure the selected value exists in list
                    value: staffList.any((s) => s.username == provider.selectedStaffName)
                        ? provider.selectedStaffName
                        : null,
                    items: staffList.map((staff) {
                      return DropdownMenuItem<String>(
                        value: staff.username, // ✅ store name as the value
                        child: Text(staff.username ?? 'Unnamed Staff'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      provider.selectedStaffName = value; // ✅ store name in provider
                      provider.notifyListeners();
                    },
                  ),
                );
              },
            ),


            //_buildTextField(provider.assignedProductsController, 'Assigned Product ID'),
            Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                final productList = productProvider.products;

                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productList.isEmpty) {
                  return const Text('No products available');
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Assigned Product',
                      border: OutlineInputBorder(),
                    ),
                    value: provider.selectedProductId,
                    items: productList.map((product) {
                      return DropdownMenuItem<String>(
                        value: product.sId, // ✅ pass product ID
                        child: Text(product.name ?? 'Unnamed Product'), // ✅ show product name
                      );
                    }).toList(),
                    onChanged: (value) {
                      provider.selectedProductId = value;
                      provider.notifyListeners();
                    },
                  ),
                );
              },
            ),


            const SizedBox(height: 20),

            provider.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: () async {
                await provider.createCustomer();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(provider.message),
                    backgroundColor: Colors.blue,
                  ));
                }
                provider.clearForm();
              },
              icon: const Icon(Icons.save),
              label: const Text('Create Customer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
