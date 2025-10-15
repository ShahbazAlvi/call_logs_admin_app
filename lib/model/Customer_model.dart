// import 'dart:convert';
//
// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
//
// class Welcome {
//   bool success;
//   int count;
//   List<Datum> data;
//
//   Welcome({required this.success, required this.count, required this.data});
//
//   factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//     success: json["success"],
//     count: json["count"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
// }
//
// class Datum {
//   CompanyLogo? companyLogo;
//   String id;
//   String businessType;
//   String companyName;
//   String address;
//   String city;
//   String email;
//   String phoneNumber;
//   List<Person> persons;
//   CreatedBy? createdBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int v;
//   AssignedStaff? assignedStaff;
//   AssignedProducts? assignedProducts;
//
//   Datum({
//     required this.companyLogo,
//     required this.id,
//     required this.businessType,
//     required this.companyName,
//     required this.address,
//     required this.city,
//     required this.email,
//     required this.phoneNumber,
//     required this.persons,
//     this.createdBy,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     this.assignedStaff,
//     this.assignedProducts,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     companyLogo: json["companyLogo"] != null
//         ? CompanyLogo.fromJson(json["companyLogo"])
//         : null,
//     id: json["id"],
//     businessType: json["businessType"],
//     companyName: json["companyName"],
//     address: json["address"],
//     city: json["city"],
//     email: json["email"],
//     phoneNumber: json["phoneNumber"],
//     persons: List<Person>.from(
//         json["persons"].map((x) => Person.fromJson(x))),
//     createdBy: json["createdBy"] != null
//         ? CreatedBy.fromJson(json["createdBy"])
//         : null,
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     assignedStaff: json["assignedStaff"] != null
//         ? AssignedStaff.fromJson(json["assignedStaff"])
//         : null,
//     assignedProducts: json["assignedProducts"] != null
//         ? AssignedProducts.fromJson(json["assignedProducts"])
//         : null,
//   );
// }
//
// class CompanyLogo {
//   String url;
//   String publicId;
//
//   CompanyLogo({required this.url, required this.publicId});
//
//   factory CompanyLogo.fromJson(Map<String, dynamic> json) =>
//       CompanyLogo(url: json["url"], publicId: json["publicId"]);
// }
//
// class CreatedBy {
//   String id;
//   String username;
//
//   CreatedBy({required this.id, required this.username});
//
//   factory CreatedBy.fromJson(Map<String, dynamic> json) =>
//       CreatedBy(id: json["id"], username: json["username"]);
// }
//
// class Person {
//   String fullName;
//   String designation;
//   String department;
//   String phoneNumber;
//   String email;
//
//   Person({
//     required this.fullName,
//     required this.designation,
//     required this.department,
//     required this.phoneNumber,
//     required this.email,
//   });
//
//   factory Person.fromJson(Map<String, dynamic> json) => Person(
//     fullName: json["fullName"],
//     designation: json["designation"],
//     department: json["department"],
//     phoneNumber: json["phoneNumber"],
//     email: json["email"],
//   );
// }
//
// class AssignedProducts {
//   String id;
//   String name;
//
//   AssignedProducts({required this.id, required this.name});
//
//   factory AssignedProducts.fromJson(Map<String, dynamic> json) =>
//       AssignedProducts(id: json["id"], name: json["name"]);
// }
//
// class AssignedStaff {
//   String id;
//   String username;
//   String email;
//
//   AssignedStaff({required this.id, required this.username, required this.email});
//
//   factory AssignedStaff.fromJson(Map<String, dynamic> json) => AssignedStaff(
//       id: json["id"], username: json["username"], email: json["email"]);
// }
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

class Welcome {
  bool success;
  int count;
  List<Datum> data;

  Welcome({required this.success, required this.count, required this.data});

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    success: json["success"] ?? false,
    count: json["count"] ?? 0,
    data: json["data"] != null
        ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
        : [],
  );
}

class Datum {
  CompanyLogo? companyLogo;
  String id;
  String businessType;
  String companyName;
  String address;
  String city;
  String email;
  String phoneNumber;
  List<Person> persons;
  CreatedBy? createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  AssignedStaff? assignedStaff;
  AssignedProducts? assignedProducts;

  Datum({
    this.companyLogo,
    required this.id,
    required this.businessType,
    required this.companyName,
    required this.address,
    required this.city,
    required this.email,
    required this.phoneNumber,
    required this.persons,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.assignedStaff,
    this.assignedProducts,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    companyLogo: json["companyLogo"] != null
        ? CompanyLogo.fromJson(json["companyLogo"])
        : null,
    id: json["_id"] ?? '', // ✅ fixed key
    businessType: json["businessType"] ?? '',
    companyName: json["companyName"] ?? '',
    address: json["address"] ?? '',
    city: json["city"]?.toString() ?? '',
    email: json["email"] ?? '',
    phoneNumber: json["phoneNumber"] ?? '',
    persons: json["persons"] != null
        ? List<Person>.from(json["persons"].map((x) => Person.fromJson(x)))
        : [],
    createdBy: json["createdBy"] != null
        ? CreatedBy.fromJson(json["createdBy"])
        : null,
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"] != null
        ? DateTime.parse(json["updatedAt"])
        : DateTime.now(),
    v: json["__v"] ?? 0,
    assignedStaff: json["assignedStaff"] != null
        ? AssignedStaff.fromJson(json["assignedStaff"])
        : null,
    assignedProducts: json["assignedProducts"] != null
        ? AssignedProducts.fromJson(json["assignedProducts"])
        : null,
  );
}

class CompanyLogo {
  String url;
  String publicId;

  CompanyLogo({required this.url, required this.publicId});

  factory CompanyLogo.fromJson(Map<String, dynamic> json) => CompanyLogo(
    url: json["url"] ?? '',
    publicId: json["public_id"] ?? '', // ✅ fixed key
  );
}

class CreatedBy {
  String id;
  String username;

  CreatedBy({required this.id, required this.username});

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["_id"] ?? '', // ✅ fixed key
    username: json["username"] ?? '',
  );
}

class Person {
  String fullName;
  String designation;
  String department;
  String phoneNumber;
  String email;

  Person({
    required this.fullName,
    required this.designation,
    required this.department,
    required this.phoneNumber,
    required this.email,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    fullName: json["fullName"] ?? '',
    designation: json["designation"] ?? '',
    department: json["department"] ?? '',
    phoneNumber: json["phoneNumber"] ?? '',
    email: json["email"] ?? '',
  );
}

class AssignedProducts {
  String id;
  String name;

  AssignedProducts({required this.id, required this.name});

  factory AssignedProducts.fromJson(Map<String, dynamic> json) =>
      AssignedProducts(
        id: json["_id"] ?? '', // ✅ fixed key
        name: json["name"] ?? '',
      );
}

class AssignedStaff {
  String id;
  String username;
  String email;

  AssignedStaff({
    required this.id,
    required this.username,
    required this.email,
  });

  factory AssignedStaff.fromJson(Map<String, dynamic> json) => AssignedStaff(
    id: json["_id"] ?? '', // ✅ fixed key
    username: json["username"] ?? '',
    email: json["email"] ?? '',
  );
}
