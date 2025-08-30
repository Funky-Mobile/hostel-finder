import 'package:flutter/material.dart';
import 'package:hostel_finder/features/room/dao/room_dao.dart';
import 'package:hostel_finder/features/roommate_request/viewmodel/roommate_request_viewmodel.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import 'package:get/get.dart';

class CreateRoommateRequestDialog extends StatefulWidget {
  final RoomDao room;

  const CreateRoommateRequestDialog({
    super.key,
    required this.room,
  });

  @override
  State<CreateRoommateRequestDialog> createState() =>
      _CreateRoommateRequestDialogState();
}

class _CreateRoommateRequestDialogState extends State<CreateRoommateRequestDialog> {

  final _formKey = GlobalKey<FormState>();
  final _preferencesController = TextEditingController();

  final RoommateRequestViewmodel roommateRequestViewmodel = Get.put(RoommateRequestViewmodel());

  @override
  void dispose() {
    _preferencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const CustomAppHeaderText(
                text: "Create Roommate Request",
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),

              /// Pre-selected Room Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.meeting_room,
                        color: Colors.blue.shade600, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomAppBodyText(
                        text: "Room ${widget.room.number} selected",
                        fontWeight: FontWeight.w600,
                        textColor: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Preferences Field
              TextFormField(
                controller: _preferencesController,
                decoration: InputDecoration(
                  labelText: 'Roommate Preferences',
                  hintText: 'Describe your ideal roommate...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your preferences';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              /// Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                    label: const CustomAppBodyText(
                      text: "Cancel",
                      fontWeight: FontWeight.w600,
                      textColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {

                        await roommateRequestViewmodel.createRoommateRequest(
                            context,
                            widget.room,
                            _preferencesController.text,
                        );

                      }
                    },
                    icon: const Icon(Icons.check, color: Colors.white, size: 18),
                    label: const CustomAppBodyText(
                      text: "Create Request",
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
