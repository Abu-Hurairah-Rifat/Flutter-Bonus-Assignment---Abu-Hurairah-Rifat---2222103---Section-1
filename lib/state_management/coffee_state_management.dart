import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';

class CoffeeStateManagement with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<CoffeeRecordsModel> items = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _coffeeSubscription;

  CoffeeStateManagement() {
    listenToCoffeeRecords();
  }

  CollectionReference<Map<String, dynamic>> get coffeeCollection =>
      _firestore.collection('coffee_records');

  Stream<List<CoffeeRecordsModel>> get coffeeRecordsStream => coffeeCollection
      .orderBy('date', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs
                .map((doc) => CoffeeRecordsModel.fromFirestore(doc))
                .toList(),
      );

  void listenToCoffeeRecords() {
    _coffeeSubscription?.cancel();
    _coffeeSubscription = coffeeCollection
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
          items
            ..clear()
            ..addAll(
              snapshot.docs
                  .map((doc) => CoffeeRecordsModel.fromFirestore(doc))
                  .toList(),
            );
          notifyListeners();
        });
  }

  Future<void> addData() async {
    final newRecord = CoffeeRecordsModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: 'Coffee Record ${items.length + 1}',
      des: 'Details about Coffee Record ${items.length + 1}',
      amount: 10.0,
      date: DateTime.now(),
    );

    await addCoffeeRecord(newRecord);
  }

  Future<void> addCoffeeRecord(CoffeeRecordsModel coffeeRecord) async {
    try {
      final record =
          coffeeRecord.id.isNotEmpty
              ? coffeeRecord
              : coffeeRecord.copyWith(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
              );

      await coffeeCollection.doc(record.id).set(record.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCoffeeRecord(CoffeeRecordsModel coffeeRecord) async {
    if (coffeeRecord.id.isEmpty) {
      return;
    }

    try {
      await coffeeCollection
          .doc(coffeeRecord.id)
          .update(coffeeRecord.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCoffeeRecord(String id) async {
    try {
      await coffeeCollection.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    _coffeeSubscription?.cancel();
    super.dispose();
  }
}
