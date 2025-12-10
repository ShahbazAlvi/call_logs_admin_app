import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Provider/CustomersTrackProvider/CustomerTrackProvider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';


class CustomersTrackScreen extends StatefulWidget {
  const CustomersTrackScreen({super.key});

  @override
  State<CustomersTrackScreen> createState() => _CustomersTrackScreenState();
}  

class _CustomersTrackScreenState extends State<CustomersTrackScreen> {
  final List<String> dateOptions = ['today', '1week', '14days', 'all'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<CustomersTrackProvider>(context, listen: false)
          .fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Customer Tracking',
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
      body: Consumer<CustomersTrackProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // 🔍 Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by company or city...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: provider.setSearch,
                ),
                const SizedBox(height: 12),

                // 🔽 Dropdowns Row
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Consumer<StaffProvider>(
                //         builder: (context, staffProvider, _) {
                //           final staffList = staffProvider.staffs;
                //
                //           if (staffProvider.isLoading) {
                //             return const Center(child: CircularProgressIndicator());
                //           }
                //
                //           if (staffList.isEmpty) {
                //             return const Text('No staff available');
                //           }
                //
                //           return Padding(
                //             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                //             child: SizedBox(
                //               width: 180, // ✅ finite width
                //               child: DropdownButtonFormField<String>(
                //                 decoration: const InputDecoration(
                //                   labelText: 'Assigned Staff',
                //                   border: OutlineInputBorder(),
                //                 ),
                //                 value: staffList.any((s) => s.username == provider.selectedStaffName)
                //                     ? provider.selectedStaffName
                //                     : null,
                //                 items: staffList.map((staff) {
                //                   return DropdownMenuItem<String>(
                //                     value: staff.username,
                //                     child: Text(staff.username ?? 'Unnamed Staff'),
                //                   );
                //                 }).toList(),
                //                 onChanged: (value) {
                //                   provider.selectedStaffName = value;
                //                   provider.notifyListeners();
                //                 },
                //               ),
                //             ),
                //           );
                //         },
                //       ),
                //
                //       const SizedBox(width: 8),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                //         child: SizedBox(
                //           width: 180, // ✅ finite width
                //           child: Consumer<ProductProvider>(
                //             builder: (context, productProvider, _) {
                //               final productList = productProvider.products;
                //
                //               if (productProvider.isLoading) {
                //                 return const Center(child: CircularProgressIndicator());
                //               }
                //
                //               if (productList.isEmpty) {
                //                 return const Text('No products available');
                //               }
                //
                //               return DropdownButtonFormField<String>(
                //                 decoration: const InputDecoration(
                //                   labelText: 'Assigned Product',
                //                   border: OutlineInputBorder(),
                //                 ),
                //                 value: productList.any((s) => s.name == provider.selectedProductName)
                //                     ? provider.selectedProductName
                //                     : null,
                //                 items: productList.map((product) {
                //                   return DropdownMenuItem<String>(
                //                     value: product.name,
                //                     child: Text(product.name ?? 'Unnamed Product'),
                //                   );
                //                 }).toList(),
                //                 onChanged: (value) {
                //                   provider.selectedProductName = value;
                //                   provider.notifyListeners();
                //                 },
                //               );
                //             },
                //           ),
                //         ),
                //       ),
                //
                //       const SizedBox(width: 8),
                //       // SizedBox(
                //       //   width: 180,
                //       //   child: DropdownButtonFormField<String>(
                //       //     decoration: const InputDecoration(
                //       //         labelText: 'Date Range',
                //       //         border: OutlineInputBorder()),
                //       //     value: provider.selectedDateRange,
                //       //     items: dateOptions
                //       //         .map((d) => DropdownMenuItem(
                //       //       value: d,
                //       //       child: Text(d.toUpperCase()),
                //       //     ))
                //       //         .toList(),
                //       //     onChanged: provider.setDateRange,
                //       //   ),
                //       // ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                //         child: SizedBox(
                //           width: 180, // ✅ finite width
                //           child: DropdownButtonFormField<String>(
                //             decoration: const InputDecoration(
                //               labelText: 'Date Range',
                //               border: OutlineInputBorder(),
                //             ),
                //             value: provider.selectedDateRange,
                //             items: dateOptions
                //                 .map((d) => DropdownMenuItem(
                //               value: d,
                //               child: Text(d.toUpperCase()),
                //             ))
                //                 .toList(),
                //             onChanged: provider.setDateRange,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // 🔹 Staff Dropdown
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
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            child: SizedBox(
                              width: 180, // ✅ finite width
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Assigned Staff',
                                  border: OutlineInputBorder(),
                                ),
                                value: provider.selectedStaffName,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('All Staff'),
                                  ),
                                  ...staffList.map((staff) {
                                    return DropdownMenuItem<String>(
                                      value: staff.username,
                                      child: Text(staff.username ?? 'Unnamed Staff'),
                                      onTap: () {
                                        provider.setStaff(staff.sId ?? '', staff.username);
                                      },
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  if (value == null) {
                                    provider.setStaff(null, null); // clear filter
                                  }
                                },
                              ),


                            ),
                          );
                        },
                      ),

                      // 🔹 Product Dropdown
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: SizedBox(
                          width: 220, // ✅ finite width
                          child: Consumer<ProductProvider>(
                            builder: (context, productProvider, _) {
                              final productList = productProvider.products;

                              if (productProvider.isLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (productList.isEmpty) {
                                return const Text('No products available');
                              }

                              return DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Assigned Product',
                                  border: OutlineInputBorder(),
                                ),
                                value: provider.selectedProductName,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('All Products'),
                                  ),
                                  ...productList.map((product) {
                                    return DropdownMenuItem<String>(
                                      value: product.name,
                                      child: Text(product.name ?? 'Unnamed Product'),
                                      onTap: () {
                                        provider.setProduct(product.sId ?? '', product.name);
                                      },
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  if (value == null) {
                                    provider.setProduct(null, null); // clear filter
                                  }
                                },
                              )

                              ;
                            },
                          ),
                        ),
                      ),

                      // 🔹 Date Range Dropdown
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: SizedBox(
                          width: 180, // ✅ finite width
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Date Range',
                              border: OutlineInputBorder(),
                            ),
                            value: provider.selectedDateRange,
                            items: dateOptions
                                .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text(d.toUpperCase()),
                            ))
                                .toList(),
                            onChanged: provider.setDateRange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 📋 Data list
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.filteredCustomers.isEmpty
                      ? const Center(child: Text('No customers found'))
                      : ListView.builder(
                    itemCount: provider.filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = provider.filteredCustomers[index];
                      return Card(
                        child: ListTile(
                          title: Text(customer.company),
                          subtitle: Text(
                              '${customer.city} • ${customer.staff} • ${customer.product}'),
                          trailing: Text(
                            DateFormat('yyyy-MM-dd').format(customer.date),
                            style: const TextStyle(color: Colors.blueAccent),
                          ),

                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
