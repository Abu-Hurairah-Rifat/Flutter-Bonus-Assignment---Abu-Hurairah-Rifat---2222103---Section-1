import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/screens/create_coffee_record_screen.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';

class CoffeRecordsScreen extends StatelessWidget {
  const CoffeRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final csm = Provider.of<CoffeeStateManagement>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coffee Records',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.00),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<CoffeeRecordsModel>>(
        stream: csm.coffeeRecordsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? csm.items;

          if (records.isEmpty) {
            return const Center(
              child: Text(
                'No coffee records yet.',
                style: TextStyle(fontSize: 18, color: Colors.brown),
              ),
            );
          }

          return AppBackgroudDesignWidget(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final CoffeeRecordsModel coffeeRecord = records[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.coffee),
                    title: Text(coffeeRecord.title),
                    subtitle: Text(
                      '${coffeeRecord.des} - Amount: ${coffeeRecord.amount} - Date: ${coffeeRecord.date.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => CreateCoffeeRecordScreen(
                                      record: coffeeRecord,
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever),
                          onPressed: () async {
                            await csm.deleteCoffeeRecord(coffeeRecord.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateCoffeeRecordScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
