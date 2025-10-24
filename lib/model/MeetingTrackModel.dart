// meeting_track_model.dart
import 'dart:convert';

class MeetingTrackModel {
  final bool success;
  final int count;
  final List<MeetingData> data;

  MeetingTrackModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory MeetingTrackModel.fromJson(Map<String, dynamic> json) {
    return MeetingTrackModel(
      success: json['success'] ?? false,
      count: (json['count'] is int) ? json['count'] as int : int.tryParse('${json['count']}') ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MeetingData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'data': data.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() => 'MeetingTrackModel(success: $success, count: $count, data: ${data.length})';
}

class MeetingData {
  final String id;
  final String companyName;
  final List<Person> persons;
  final AssignedStaff? assignedStaff;
  final AssignedProduct? assignedProducts;
  final String? status;
  final String? timeline;

  MeetingData({
    required this.id,
    required this.companyName,
    required this.persons,
    this.assignedStaff,
    this.assignedProducts,
    this.status,
    this.timeline,
  });

  factory MeetingData.fromJson(Map<String, dynamic> json) {
    return MeetingData(
      id: json['_id']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      persons: (json['persons'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      assignedStaff: json['assignedStaff'] != null
          ? AssignedStaff.fromJson(json['assignedStaff'] as Map<String, dynamic>)
          : null,
      assignedProducts: json['assignedProducts'] != null
          ? AssignedProduct.fromJson(json['assignedProducts'] as Map<String, dynamic>)
          : null,
      status: json['status']?.toString(),
      timeline: json['Timeline']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyName': companyName,
    'persons': persons.map((p) => p.toJson()).toList(),
    'assignedStaff': assignedStaff?.toJson(),
    'assignedProducts': assignedProducts?.toJson(),
    'status': status,
    'Timeline': timeline,
  };

  @override
  String toString() => 'MeetingData(id: $id, companyName: $companyName)';
}

class Person {
  final String? fullName;
  final String? phoneNumber;

  Person({
    this.fullName,
    this.phoneNumber,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      fullName: json['fullName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  };

  @override
  String toString() => 'Person(fullName: $fullName, phoneNumber: $phoneNumber)';
}

class AssignedStaff {
  final String? username;

  AssignedStaff({this.username});

  factory AssignedStaff.fromJson(Map<String, dynamic> json) {
    return AssignedStaff(
      username: json['username']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
  };

  @override
  String toString() => 'AssignedStaff(username: $username)';
}

class AssignedProduct {
  final String? name;

  AssignedProduct({this.name});

  factory AssignedProduct.fromJson(Map<String, dynamic> json) {
    return AssignedProduct(
      name: json['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
  };

  @override
  String toString() => 'AssignedProduct(name: $name)';
}
