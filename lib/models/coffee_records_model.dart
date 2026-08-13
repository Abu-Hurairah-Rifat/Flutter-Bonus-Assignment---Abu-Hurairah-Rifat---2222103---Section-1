// To parse this JSON data, do
//
//     final coffeeRecordsModel = coffeeRecordsModelFromJson(jsonString);

import 'dart:convert';

CoffeeRecordsModel coffeeRecordsModelFromJson(String str) =>
    CoffeeRecordsModel.fromJson(json.decode(str));

String coffeeRecordsModelToJson(CoffeeRecordsModel data) =>
    json.encode(data.toJson());

class CoffeeRecordsModel {
  final String id;
  final String name;
  final double price;

  CoffeeRecordsModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory CoffeeRecordsModel.fromJson(Map<String, dynamic> json) =>
      CoffeeRecordsModel(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price};
}
