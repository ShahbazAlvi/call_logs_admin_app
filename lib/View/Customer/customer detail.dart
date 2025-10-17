import 'package:flutter/material.dart';
import '../../model/Customer_model.dart';


class CompanyDetailScreen extends StatelessWidget {
  final Datum company;
  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
          title: Text(company.companyName,style: TextStyle(color: Colors.white),)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (company.companyLogo != null)
              Center(
                child: Image.network(
                  company.companyLogo!.url,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text('Business Type: ${company.businessType}'),
            Text('City: ${company.city}'),
            Text('Email: ${company.email}'),
            Text('Phone: ${company.phoneNumber}'),
            const SizedBox(height: 16),
            if (company.assignedStaff != null)
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(company.assignedStaff!.username),
                subtitle: Text(company.assignedStaff!.email),
              ),
            if (company.assignedProducts != null)
              ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: Text(company.assignedProducts!.name),
                subtitle: Text(company.assignedProducts!.id),
              ),
            const SizedBox(height: 16),
            Text('Persons', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...company.persons.map((p) => ListTile(
              title: Text(p.fullName),
              subtitle: Text('${p.designation} • ${p.department}'),
              trailing: Text(p.phoneNumber),
            )),
          ],
        ),
      ),
    );
  }
}
