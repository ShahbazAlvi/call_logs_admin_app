import 'package:flutter/material.dart';
import '../../model/Customer_model.dart';


class CompanyDetailScreen extends StatelessWidget {
  final Datum company;
  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:  Text(company.companyName,style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ))),
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
