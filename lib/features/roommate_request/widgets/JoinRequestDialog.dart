import 'package:flutter/material.dart';

import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../dtos/JoinRequestData.dart';

class JoinRequestDialog extends StatefulWidget {
  const JoinRequestDialog({super.key});

  @override
  State<JoinRequestDialog> createState() => _JoinRequestDialogState();
}

class _JoinRequestDialogState extends State<JoinRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      controller.text = date.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomAppHeaderText(
        text: "Join Roommate Request",
        size: 18,
        fontWeight: FontWeight.bold,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _checkInController,
              decoration: InputDecoration(
                labelText: 'Check-in Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(_checkInController),
                ),
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select check-in date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _checkOutController,
              decoration: InputDecoration(
                labelText: 'Check-out Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(_checkOutController),
                ),
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select check-out date';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to Pay',
                border: OutlineInputBorder(),
                prefixText: 'GHS ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const CustomAppBodyText(
            text: "Cancel",
            fontWeight: FontWeight.w600,
            textColor: Colors.grey,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final data = JoinRequestData(
                checkInDate: _checkInController.text,
                checkOutDate: _checkOutController.text,
                amountPaid: double.parse(_amountController.text),
              );
              Navigator.pop(context, data);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const CustomAppBodyText(
            text: "Join Request",
            fontWeight: FontWeight.w600,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

