import 'package:flutter/material.dart';
import 'package:hostel_finder/features/maintenance/maintenance_view_model.dart';
import 'package:get/get.dart';
import 'maintenance_model.dart';

class MaintenanceRequestsScreen extends StatefulWidget {
  const MaintenanceRequestsScreen({super.key});

  @override
  State<MaintenanceRequestsScreen> createState() => _MaintenanceRequestsScreenState();
}

class _MaintenanceRequestsScreenState extends State<MaintenanceRequestsScreen> {
  final MaintenanceViewModel _maintenanceViewModel = Get.put(MaintenanceViewModel());

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Colors.orange;
      case "APPROVED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Maintenance Requests")),
      body: FutureBuilder<List<MaintenanceModel>>(
        future: _maintenanceViewModel.fetchUserMaintenanceRequests(),
        builder: (context, snapshot) {
          // Show loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text("Loading maintenance requests..."),
                ],
              ),
            );
          }

          // Show error state with more details
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading data",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Details: ${snapshot.error}",
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}), // Refresh
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Check if data is null or empty
          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 64),
                  SizedBox(height: 16),
                  Text("No data received"),
                ],
              ),
            );
          }

          final requests = snapshot.data!;

          // Show empty state
          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment, color: Colors.grey, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    "No Maintenance Requests",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You haven't submitted any maintenance requests yet.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}), // Refresh
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          // Show data
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Trigger rebuild
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.room, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Room: ${request.roomId}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          request.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              label: Text(request.status),
                              backgroundColor: _statusColor(request.status).withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: _statusColor(request.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Created: ${request.createdAt.toLocal().toString().split(' ').first}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
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
    );
  }
}