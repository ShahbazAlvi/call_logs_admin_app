import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/customer/customer_provider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class UpdateCustomerScreen extends StatefulWidget {
  final String? customerId; // 👈 null = Add mode, not null = Edit mode
  const UpdateCustomerScreen({super.key, this.customerId});

  @override
  State<UpdateCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<UpdateCustomerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final staff = Provider.of<StaffProvider>(context, listen: false);
      final product = Provider.of<ProductProvider>(context, listen: false);
      final companyProvider = Provider.of<CompanyProvider>(context, listen: false);

      await staff.fetchStaff();
      await product.fetchProducts();

      // 👇 If editing existing customer, load its data
      if (widget.customerId != null) {
        await companyProvider.fetchCustomerById(widget.customerId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Update Customer',
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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🖼 Company Logo
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
            const Text('Person Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),

            // 👨‍💼 Dynamic person fields
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
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (provider.personsList.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => provider.removePerson(index),
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

            OutlinedButton.icon(
              onPressed: provider.addPerson,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Person'),
            ),

            const Divider(height: 40),

            // Assigned Staff Dropdown
            Consumer<StaffProvider>(
              builder: (context, staffProvider, _) {
                if (staffProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final staffList = staffProvider.staffs;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Assigned Staff',
                    border: OutlineInputBorder(),
                  ),
                  value: provider.selectedStaffId,
                  items: staffList.map((staff) {
                    return DropdownMenuItem<String>(
                      value: staff.sId,
                      child: Text(staff.username ?? 'Unnamed Staff'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    provider.selectedStaffId = value;
                    provider.notifyListeners();
                  },
                );
              },
            ),

            const SizedBox(height: 10),

            // Assigned Product Dropdown
            Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final productList = productProvider.products;
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Assigned Product',
                    border: OutlineInputBorder(),
                  ),
                  value: provider.selectedProductId,
                  items: productList.map((product) {
                    return DropdownMenuItem<String>(
                      value: product.sId,
                      child: Text(product.name ?? 'Unnamed Product'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    provider.selectedProductId = value;
                    provider.notifyListeners();
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () async {
                if (widget.customerId == null) {
                  await provider.createCustomer();
                } else {
                  await provider.UpdateCustomer(widget.customerId!);
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(provider.message),
                    backgroundColor: Colors.blue,
                  ));
                }
              },
              icon: const Icon(Icons.save),
              label: Text(widget.customerId == null
                  ? 'Create Customer'
                  : 'Update Customer'),
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
