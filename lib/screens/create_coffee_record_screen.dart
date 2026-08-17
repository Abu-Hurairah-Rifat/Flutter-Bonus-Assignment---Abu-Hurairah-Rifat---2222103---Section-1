import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summer_iub_app/models/coffee_records_model.dart';
import 'package:summer_iub_app/state_management/coffee_state_management.dart';
import 'package:summer_iub_app/utility/vlaidators.dart';
import 'package:summer_iub_app/widgets/app_backgroud_design_widget.dart';
import 'package:summer_iub_app/widgets/core_input_widget.dart';

class CreateCoffeeRecordScreen extends StatefulWidget {
  final CoffeeRecordsModel? record;

  const CreateCoffeeRecordScreen({super.key, this.record});

  @override
  State<CreateCoffeeRecordScreen> createState() =>
      _CreateCoffeeRecordScreenState();
}

class _CreateCoffeeRecordScreenState extends State<CreateCoffeeRecordScreen> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final TextEditingController descriptionController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.record?.title ?? '');
    amountController = TextEditingController(
      text: widget.record == null ? '' : widget.record!.amount.toString(),
    );
    descriptionController = TextEditingController(
      text: widget.record?.des ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final csm = Provider.of<CoffeeStateManagement>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.record == null
              ? 'Create Coffee Record'
              : 'Update Coffee Record',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.00),
        ),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: AppBackgroudDesignWidget(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CoreInputWidget(
                  controller: titleController,
                  labelText: 'Title',
                  validator: CustomValidators.validateTitle,
                ),
                const SizedBox(height: 20.00),
                CoreInputWidget(
                  controller: amountController,
                  labelText: 'Amount',
                  keyboardType: TextInputType.number,
                  validator: CustomValidators.validateAmount,
                ),
                const SizedBox(height: 20.00),
                CoreInputWidget(
                  controller: descriptionController,
                  labelText: 'Description',
                  keyboardType: TextInputType.multiline,
                  maxLine: 5,
                  validator: CustomValidators.validateDescreption,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final coffeeRecord = CoffeeRecordsModel(
                          id:
                              widget.record?.id ??
                              DateTime.now().microsecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          des: descriptionController.text.trim(),
                          amount: double.tryParse(amountController.text) ?? 0.0,
                          date: widget.record?.date ?? DateTime.now(),
                        );

                        if (widget.record == null) {
                          await csm.addCoffeeRecord(coffeeRecord);
                        } else {
                          await csm.updateCoffeeRecord(coffeeRecord);
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Coffee record saved successfully.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Save failed: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  label: Text(
                    widget.record == null
                        ? 'Save Coffee Record'
                        : 'Update Coffee Record',
                    style: const TextStyle(
                      fontSize: 18.00,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.save, size: 30.00),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50.00),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.00,
                      vertical: 15.00,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
