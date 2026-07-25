import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';

import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';

class CoffeRecordsScreen extends StatefulWidget {
  const CoffeRecordsScreen({super.key,});

  @override
  State<CoffeRecordsScreen> createState() => _CoffeRecordsScreenState();
}

class _CoffeRecordsScreenState extends State<CoffeRecordsScreen> {
  
  late Provider<CoffeeStateManagement> csm;

  initState() {
    super.initState();
    csm = Provider.of<CoffeeStateManagement>(context, listen: false) as Provider<CoffeeStateManagement>;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  dispose() {
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Coffee Records",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.00,
          ),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),

      body: Consumer<CoffeeStateManagement>(
        builder: (context,csm,_) {
          return AppBackgroudDesignWidget(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
              itemCount: csm.items.length,
              itemBuilder:(context, index){
          
                final CoffeeRecordsModel coffeeRecord = csm.items[index];
          
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.coffee),
                    title: Text(coffeeRecord.title),
                    subtitle: Text("${coffeeRecord.des} - Amount: ${coffeeRecord.amount} - ID: (${coffeeRecord.id})"),
                  ),
                );
              }
          ),
          
          );
        }
      ),

      floatingActionButton: Consumer<CoffeeStateManagement>(
        builder: (context,csm,_) {
          return FloatingActionButton(
            onPressed: () {
              csm.addData();
              setState(() {});
            },
            child: Icon(Icons.local_cafe),
          );
        }
      ),
    );
  }
}