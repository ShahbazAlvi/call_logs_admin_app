import 'dart:convert';

UnassignCustomerModel unassignCustomerModelFromJson(String str) =>
    UnassignCustomerModel.fromJson(json.decode(str));

String unassignCustomerModelToJson(UnassignCustomerModel data) =>
    json.encode(data.toJson());

class UnassignCustomerModel {
  final bool? success;
  final int? count;
  final List<CustomerData>? data;

  UnassignCustomerModel({
    this.success,
    this.count,
    this.data,
  });

  factory UnassignCustomerModel.fromJson(Map<String, dynamic> json) =>
      UnassignCustomerModel(
        success: json["success"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<CustomerData>.from(
            json["data"].map((x) => CustomerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CustomerData {
  final CompanyLogo? companyLogo;
  final String? id;
  final String? businessType;
  final String? companyName;
  final String? address;
  final String? city;
  final String? email;
  final String? phoneNumber;
  final List<Person>? persons;
  final int? v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerData({
    this.companyLogo,
    this.id,
    this.businessType,
    this.companyName,
    this.address,
    this.city,
    this.email,
    this.phoneNumber,
    this.persons,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
    companyLogo: json["companyLogo"] == null
        ? null
        : CompanyLogo.fromJson(json["companyLogo"]),
    id: json["_id"],
    businessType: json["businessType"],
    companyName: json["companyName"],
    address: json["address"],
    city: json["city"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    persons: json["persons"] == null
        ? []
        : List<Person>.from(
        json["persons"].map((x) => Person.fromJson(x))),
    v: json["__v"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "companyLogo": companyLogo?.toJson(),
    "_id": id,
    "businessType": businessType,
    "companyName": companyName,
    "address": address,
    "city": city,
    "email": email,
    "phoneNumber": phoneNumber,
    "persons": persons == null
        ? []
        : List<dynamic>.from(persons!.map((x) => x.toJson())),
    "__v": v,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class CompanyLogo {
  final String? url;
  final String? publicId;

  CompanyLogo({
    this.url,
    this.publicId,
  });

  factory CompanyLogo.fromJson(Map<String, dynamic> json) => CompanyLogo(
    url: json["url"],
    publicId: json["public_id"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "public_id": publicId,
  };
}

class Person {
  final String? fullName;
  final String? designation;
  final String? department;
  final String? phoneNumber;
  final String? email;

  Person({
    this.fullName,
    this.designation,
    this.department,
    this.phoneNumber,
    this.email,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    fullName: json["fullName"],
    designation: json["designation"],
    department: json["department"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "designation": designation,
    "department": department,
    "phoneNumber": phoneNumber,
    "email": email,
  };
}
