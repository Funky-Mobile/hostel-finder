import 'package:flutter/material.dart';

import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';

class CreateRoommateRequestDialog extends StatefulWidget {

  final String? preSelectedRoomId;
  final String? preSelectedRoomNumber;

  const CreateRoommateRequestDialog({super.key, this.preSelectedRoomId, this.preSelectedRoomNumber});

  @override
  State<CreateRoommateRequestDialog> createState() => _CreateRoommateRequestDialogState();
}


class _CreateRoommateRequestDialogState extends State<CreateRoommateRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _preferencesController = TextEditingController();
  String? selectedRoomId;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedRoomId != null) {
      selectedRoomId = widget.preSelectedRoomId;
    }
  }

  @override
  void dispose() {
    _preferencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomAppHeaderText(
        text: "Create Roommate Request",
        size: 18,
        fontWeight: FontWeight.bold,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.preSelectedRoomId != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.room, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomAppBodyText(
                        text: "Room ${widget.preSelectedRoomNumber} selected",
                        fontWeight: FontWeight.w600,
                        textColor: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _preferencesController,
              decoration: const InputDecoration(
                labelText: 'Roommate Preferences',
                hintText: 'Describe your ideal roommate...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your preferences';
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
              // TODO: Create the roommate request
              Navigator.pop(context, true);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const CustomAppBodyText(
            text: "Create Request",
            fontWeight: FontWeight.w600,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}