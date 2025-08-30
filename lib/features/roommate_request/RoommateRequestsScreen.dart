import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/features/room/dao/room_dao.dart';
import 'package:hostel_finder/features/room/room_details/room_detail.dart';
import 'package:hostel_finder/features/room/room_view_model/room_view_model.dart';
import 'package:hostel_finder/features/roommate_request/dtos/RoommateRequest.dart';
import 'package:hostel_finder/features/roommate_request/viewmodel/roommate_request_viewmodel.dart';

class RoommateRequestsScreen extends StatefulWidget {
  const RoommateRequestsScreen({super.key});

  @override
  State<RoommateRequestsScreen> createState() => _RoommateRequestsScreenState();
}

class _RoommateRequestsScreenState extends State<RoommateRequestsScreen> with TickerProviderStateMixin {

  late TabController _tabController;

  final RoommateRequestViewmodel viewModel = Get.put(RoommateRequestViewmodel());

  final RoomViewModel roomViewModel = Get.find<RoomViewModel>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Roommate Requests'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(icon: Icon(Icons.public), text: 'All Requests'),
            Tab(icon: Icon(Icons.person), text: 'My Requests'),
            Tab(icon: Icon(Icons.handshake), text: 'Joined'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFutureTab(viewModel.loadAllRequests(),
              emptyIcon: Icons.search_off,
              emptyMessage: "No roommate requests available"
          ),
          _buildFutureTab(viewModel.loadMyRequests(),
              emptyIcon: Icons.inbox,
              emptyMessage: "You haven't created any requests yet"
          ),
          _buildFutureTab(viewModel.loadJoinedRequests(),
              emptyIcon: Icons.group_off,
              emptyMessage: "You haven't joined any requests yet"),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => viewModel.createRoommateRequest(context),
      //   backgroundColor: Colors.blue,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Create Request'),
      // ),
    );
  }

  Widget _buildFutureTab(
      Future<List<RoommateRequest>> future, {
        required IconData emptyIcon,
        required String emptyMessage,
      }) {
    return FutureBuilder<List<RoommateRequest>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(emptyIcon, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(emptyMessage, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {}); // re-trigger FutureBuilder
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final request = snapshot.data![index];
              return _buildRequestCard(request);
            },
          ),
        );
      },
    );
  }


  Widget _buildRequestCard(RoommateRequest request) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  request.requesterId[0].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        request.requesterId,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    Text(
                        "Room ${request.roomId}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14)
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: request.open
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(request.open ? "Open" : "Closed",
                    style: TextStyle(
                        color: request.open
                            ? Colors.green[800]
                            : Colors.orange[800],
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text("Preferences:",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700])),
          const SizedBox(height: 4),
          Text(request.preferences, style: const TextStyle(fontSize: 14)),

          // 👇 Actions handled here
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (request.open && request.requesterId != viewModel.currentUserId.value)
                ElevatedButton.icon(
                  onPressed: () {

                    late RoomDao rmDao;

                    for(final rm in roomViewModel.rooms) {
                      if (rm.id == request.roomId) {
                        rmDao = rm;
                      }
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoomDetail(room: rmDao)
                      ),
                    );
                  },
                  icon: const Icon(Icons.handshake, size: 18),
                  label: const Text('Join Request'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
              const SizedBox(width: 8),
              if (request.requesterId == viewModel.currentUserId.value) // add a flag in DTO or check requesterId == currentUser.id
                ElevatedButton.icon(
                  onPressed: () async {
                    await viewModel.cancelRequest(context, request.id, request.requesterId);
                    setState(() {});
                  },
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                ),
            ],
          )
        ]),
      ),
    );
  }
}
