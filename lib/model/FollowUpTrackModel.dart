class FollowUpTrackModel {
  final bool? success;
  final int? count;
  final List<FollowUpData>? data;

  FollowUpTrackModel({
    this.success,
    this.count,
    this.data,
  });

  factory FollowUpTrackModel.fromJson(Map<String, dynamic> json) {
    return FollowUpTrackModel(
      success: json['success'] as bool?,
      count: json['count'] as int?,
      data: (json['data'] as List?)
          ?.map((e) => FollowUpData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class FollowUpData {
  final String? id;
  final String? companyName;
  final List<Person>? persons;
  final AssignedStaff? assignedStaff;
  final Product? product;
  final String? status;
  final String? timeline;
  final List<String>? followDates;
  final List<String>? followTimes;
  final List<String>? details;

  FollowUpData({
    this.id,
    this.companyName,
    this.persons,
    this.assignedStaff,
    this.product,
    this.status,
    this.timeline,
    this.followDates,
    this.followTimes,
    this.details,
  });

  factory FollowUpData.fromJson(Map<String, dynamic> json) {
    return FollowUpData(
      id: json['_id'] as String?,
      companyName: json['companyName'] as String?,
      persons: (json['persons'] as List?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList(),
      assignedStaff: json['assignedStaff'] != null
          ? AssignedStaff.fromJson(json['assignedStaff'])
          : null,
      product:
      json['product'] != null ? Product.fromJson(json['product']) : null,
      status: json['status'] as String?,
      timeline: json['Timeline'] as String?,
      followDates:
      (json['followDates'] as List?)?.map((e) => e.toString()).toList(),
      followTimes:
      (json['followTimes'] as List?)?.map((e) => e.toString()).toList(),
      details: (json['details'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'companyName': companyName,
      'persons': persons?.map((e) => e.toJson()).toList(),
      'assignedStaff': assignedStaff?.toJson(),
      'product': product?.toJson(),
      'status': status,
      'Timeline': timeline,
      'followDates': followDates,
      'followTimes': followTimes,
      'details': details,
    };
  }
}

class Person {
  final String? fullName;
  final String? phoneNumber;

  Person({this.fullName, this.phoneNumber});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}

class AssignedStaff {
  final String? username;

  AssignedStaff({this.username});

  factory AssignedStaff.fromJson(Map<String, dynamic> json) {
    return AssignedStaff(
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}

class Product {
  final String? name;

  Product({this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
