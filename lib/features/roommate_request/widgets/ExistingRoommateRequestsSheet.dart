import 'package:flutter/material.dart';
import 'package:hostel_finder/features/roommate_request/viewmodel/roommate_request_viewmodel.dart';

import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../room/dao/room_dao.dart';
import '../dtos/JoinRequestData.dart';
import '../dtos/RoommateRequest.dart';
import 'CreateRoommateRequestDialog.dart';
import 'JoinRequestDialog.dart';
import 'package:get/get.dart';

class ExistingRoommateRequestsSheet extends StatefulWidget {

  final RoomDao room;

  const ExistingRoommateRequestsSheet({super.key, required this.room});

  @override
  State<ExistingRoommateRequestsSheet> createState() => _ExistingRoommateRequestsSheetState();
}

class _ExistingRoommateRequestsSheetState extends State<ExistingRoommateRequestsSheet> {

  final RoommateRequestViewmodel _roommateRequestViewmodel = Get.put(RoommateRequestViewmodel());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppHeaderText(
            text: "Roommate Requests for Room ${widget.room.number}",
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          CustomAppBodyText(
            text: "Join an existing roommate request or create your own",
            fontSize: 14,
            textColor: Colors.grey.shade600,
          ),
          const SizedBox(height: 20),

          FutureBuilder(
              future: _roommateRequestViewmodel.loadRequestsByRoomId(widget.room.id),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          CustomAppBodyText(
                            text: "Be the first to create one!",
                            fontSize: 14,
                            textColor: Colors.grey.shade500,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final request = snapshot.data![index];
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        request.requesterId[0].toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomAppHeaderText(
                                            text: request.requesterId,
                                            size: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          CustomAppBodyText(
                                            text: "Looking for roommate",
                                            fontSize: 12,
                                            textColor: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: CustomAppBodyText(
                                        text: request.open ? "Open" : "Closed",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        textColor: Colors.green.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                CustomAppBodyText(
                                  text: "Preferences:",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.grey.shade700,
                                ),
                                const SizedBox(height: 4),
                                CustomAppBodyText(
                                  text: request.preferences,
                                  fontSize: 14,
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _joinRoomRequest(context, request),
                                    icon: const Icon(Icons.handshake, size: 18),
                                    label: const CustomAppBodyText(
                                      text: "Join Request",
                                      fontWeight: FontWeight.w600,
                                      textColor: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

              }
          ),

          // Bottom buttons
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _createNewRoomRequest(context, widget.room);
                  },
                  icon: const Icon(Icons.add),
                  label: const CustomAppBodyText(
                    text: "Create New Request",
                    fontWeight: FontWeight.w600,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    side: const BorderSide(color: Colors.purple),
                    foregroundColor: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _joinRoomRequest(BuildContext context, RoommateRequest request) async {
    final result = await showDialog<JoinRequestData>(
      context: context,
      builder: (context) => JoinRequestDialog(),
    );

    if (result != null && context.mounted) {
      _roommateRequestViewmodel.confirmAndJoinRequest(context, request.id, result, widget.room);
    }
  }

  void _createNewRoomRequest(BuildContext context, RoomDao room) async {
    await showDialog(
      context: context,
      builder: (context) => CreateRoommateRequestDialog(room: widget.room),
    );
  }
}

