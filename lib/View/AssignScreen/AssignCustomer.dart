// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Provider/AssignCustomerProvider/AssignProvider.dart';
//
//
// class UnassignCustomerScreen extends StatefulWidget {
//   const UnassignCustomerScreen({super.key});
//
//   @override
//   State<UnassignCustomerScreen> createState() => _UnassignCustomerScreenState();
// }
//
// class _UnassignCustomerScreenState extends State<UnassignCustomerScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<UnassignCustomerProvider>(context, listen: false)
//             .fetchUnassignedCustomers());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<UnassignCustomerProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.indigo,
//         title: provider.selectedIds.isEmpty
//             ? const Text('Unassigned Customers',style: TextStyle(color: Colors.white),)
//             : Text('Selected: ${provider.selectedIds.length}',style: TextStyle(color: Colors.white),),
//         actions: [
//           if (provider.selectedIds.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.person_add_alt_1),
//               onPressed: () async {
//                 await provider.assignSelectedCustomers();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Customers Assigned Successfully')),
//                 );
//               },
//             )
//         ],
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           // 🔍 Search Bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: provider.searchCustomer,
//               decoration: InputDecoration(
//                 hintText: 'Search company...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//           // 📋 List
//           Expanded(
//             child: ListView.builder(
//               itemCount: provider.customers.length,
//               itemBuilder: (context, index) {
//                 final item = provider.customers[index];
//                 final person =
//                 (item.persons != null && item.persons!.isNotEmpty)
//                     ? item.persons!.first.fullName ?? 'N/A'
//                     : 'N/A';
//                 final phone =
//                 (item.persons != null && item.persons!.isNotEmpty)
//                     ? item.persons!.first.phoneNumber ?? 'N/A'
//                     : 'N/A';
//
//                 return Card(
//                   margin:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: ListTile(
//                     leading: Checkbox(
//                       value: provider.selectedIds.contains(item.id),
//                       onChanged: (_) => provider.toggleSelection(item.id!),
//                     ),
//                     title: Text(item.companyName ?? 'Unknown Company',
//                         style:
//                         const TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Business: ${item.businessType ?? '-'}'),
//                         Text('Person: $person'),
//                         Text('Phone: $phone'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/AssignCustomerProvider/AssignProvider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class UnassignCustomerScreen extends StatefulWidget {
  const UnassignCustomerScreen({super.key});

  @override
  State<UnassignCustomerScreen> createState() => _UnassignCustomerScreenState();
}

class _UnassignCustomerScreenState extends State<UnassignCustomerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UnassignCustomerProvider>(context, listen: false)
            .fetchUnassignedCustomers());
  }

  Future<void> _showAssignDialog(BuildContext context) async {
    final assignProvider =
    Provider.of<UnassignCustomerProvider>(context, listen: false);
    final staffProvider =
    Provider.of<StaffProvider>(context, listen: false);
    final productProvider =
    Provider.of<ProductProvider>(context, listen: false);

    await Future.wait([
      staffProvider.fetchStaff(),
      productProvider.fetchProducts(),
    ]);

    String? selectedStaff;
    String? selectedProduct;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign Staff & Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Staff Dropdown
                Consumer<StaffProvider>(
                  builder: (context, staffProv, _) {
                    if (staffProv.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Staff',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedStaff,
                      items: staffProv.staffs.map((staff) {
                        return DropdownMenuItem<String>(
                          value: staff.sId,
                          child: Text(staff.username ?? 'Unnamed Staff'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedStaff = value;
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Product Dropdown
                Consumer<ProductProvider>(
                  builder: (context, productProv, _) {
                    if (productProv.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Product',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedProduct,
                      items: productProv.products.map((product) {
                        return DropdownMenuItem<String>(
                          value: product.sId,
                          child: Text(product.name ?? 'Unnamed Product'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedProduct = value;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedStaff == null || selectedProduct == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select both fields')),
                  );
                  return;
                }

                await assignProvider.assignSelectedCustomers(
                  staffId: selectedStaff!,
                  productId: selectedProduct!,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Customers Assigned Successfully')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Assign', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UnassignCustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          provider.selectedIds.isEmpty
              ? 'Unassigned Customers'
              : 'Selected: ${provider.selectedIds.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (provider.selectedIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
              onPressed: () => _showAssignDialog(context),
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: provider.searchCustomer,
              decoration: InputDecoration(
                hintText: 'Search company...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // List of customers
          Expanded(
            child: ListView.builder(
              itemCount: provider.customers.length,
              itemBuilder: (context, index) {
                final item = provider.customers[index];
                final person = (item.persons?.isNotEmpty ?? false)
                    ? item.persons!.first.fullName ?? 'N/A'
                    : 'N/A';
                final phone = (item.persons?.isNotEmpty ?? false)
                    ? item.persons!.first.phoneNumber ?? 'N/A'
                    : 'N/A';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: Checkbox(
                      value: provider.selectedIds.contains(item.id),
                      onChanged: (_) => provider.toggleSelection(item.id!),
                    ),
                    title: Text(
                      item.companyName ?? 'Unknown Company',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Business: ${item.businessType ?? '-'}'),
                        Text('Person: $person'),
                        Text('Phone: $phone'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
