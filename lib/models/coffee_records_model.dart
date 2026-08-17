// To parse this JSON data, do
//
//     final coffeeRecordsModel = coffeeRecordsModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CoffeeRecordsModel coffeeRecordsModelFromJson(String str) =>
    CoffeeRecordsModel.fromJson(json.decode(str));

String coffeeRecordsModelToJson(CoffeeRecordsModel data) =>
    json.encode(data.toJson());

class CoffeeRecordsModel {
  final String id;
  final String title;
  final String des;
  final double amount;
  final DateTime date;

  CoffeeRecordsModel({
    required this.id,
    required this.title,
    required this.des,
    required this.amount,
    required this.date,
  });

  factory CoffeeRecordsModel.fromJson(Map<String, dynamic> json) {
    return CoffeeRecordsModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      des: (json['des'] ?? '').toString(),
      amount:
          (json['amount'] is num
              ? (json['amount'] as num).toDouble()
              : double.tryParse('${json['amount']}') ?? 0.0),
      date: _parseDate(json['date']),
    );
  }

  factory CoffeeRecordsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return CoffeeRecordsModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'des': des,
    'amount': amount,
    'date': date.toIso8601String(),
  };

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'des': des,
    'amount': amount,
    'date': Timestamp.fromDate(date),
  };

  CoffeeRecordsModel copyWith({
    String? id,
    String? title,
    String? des,
    double? amount,
    DateTime? date,
  }) {
    return CoffeeRecordsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      des: des ?? this.des,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    return DateTime.now();
  }
}
