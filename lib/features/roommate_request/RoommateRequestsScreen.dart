import 'package:flutter/material.dart';
import 'package:hostel_finder/features/roommate_request/widgets/CreateRoommateRequestDialog.dart';
import 'package:hostel_finder/features/roommate_request/widgets/JoinRequestDialog.dart';

import 'dtos/JoinRequestData.dart';
import 'dtos/RoommateRequest.dart';

class RoommateRequestsScreen extends StatefulWidget {
  const RoommateRequestsScreen({super.key});

  @override
  State<RoommateRequestsScreen> createState() => _RoommateRequestsScreenState();
}

class _RoommateRequestsScreenState extends State<RoommateRequestsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<RoommateRequest> allRequests = [];
  List<RoommateRequest> myRequests = [];
  List<RoommateRequest> joinedRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      await Future.wait([
        _loadAllRequests(),
        _loadMyRequests(),
        _loadJoinedRequests(),
      ]);
    } catch (e) {
      _showErrorSnackbar('Failed to load data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadAllRequests() async {
    // TODO: Replace with actual API call
    // final response = await ApiService.getAllRoommateRequests();
    // setState(() => allRequests = response);

    // Mock data for now
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      allRequests = [
        RoommateRequest(
          id: 'req001',
          studentId: 'student123',
          roomId: 'room567',
          preferences: 'Looking for a quiet roommate who likes to cook',
          status: 'OPEN',
          studentName: 'John Doe',
          roomNumber: 'A-101',
        ),
        RoommateRequest(
          id: 'req002',
          studentId: 'student789',
          roomId: 'room890',
          preferences: 'Need someone who is clean and studies late',
          status: 'OPEN',
          studentName: 'Jane Smith',
          roomNumber: 'B-205',
        ),
      ];
    });
  }

  Future<void> _loadMyRequests() async {
    // TODO: Replace with actual API call
    // final studentId = await TokenCacheService.getStudentId();
    // final response = await ApiService.getMyRoommateRequests(studentId);
    // setState(() => myRequests = response);

    // Mock data for now
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      myRequests = [
        RoommateRequest(
          id: 'req003',
          studentId: 'currentUser',
          roomId: 'room456',
          preferences: 'Looking for someone who likes music and is social',
          status: 'OPEN',
          studentName: 'You',
          roomNumber: 'C-301',
        ),
      ];
    });
  }

  Future<void> _loadJoinedRequests() async {
    // TODO: Replace with actual API call
    // final studentId = await TokenCacheService.getStudentId();
    // final response = await ApiService.getJoinedRoommateRequests(studentId);
    // setState(() => joinedRequests = response);

    // Mock data for now
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      joinedRequests = [
        RoommateRequest(
          id: 'req004',
          studentId: 'student999',
          roomId: 'room111',
          preferences: 'Early sleeper, likes reading',
          status: 'FILLED',
          partnerStudentId: 'currentUser',
          studentName: 'Alice Johnson',
          roomNumber: 'D-102',
        ),
      ];
    });
  }

  Future<void> _createRoommateRequest() async {
    final result = await showDialog<RoommateRequest>(
      context: context,
      builder: (context) => CreateRoommateRequestDialog(),
    );

    if (result != null) {
      try {
        // TODO: Replace with actual API call
        // await ApiService.createRoommateRequest(result);

        _showSuccessSnackbar('Roommate request created successfully!');
        _loadData(); // Reload data
      } catch (e) {
        _showErrorSnackbar('Failed to create request: $e');
      }
    }
  }

  Future<void> _joinRequest(RoommateRequest request) async {
    final result = await showDialog<JoinRequestData>(
      context: context,
      builder: (context) => JoinRequestDialog(),
    );

    if (result != null) {
      try {
        // TODO: Replace with actual API call
        // await ApiService.joinRoommateRequest(request.id, result);

        _showSuccessSnackbar('Successfully joined the roommate request!');
        _loadData(); // Reload data
      } catch (e) {
        _showErrorSnackbar('Failed to join request: $e');
      }
    }
  }

  Future<void> _cancelRequest(RoommateRequest request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Request'),
        content: Text('Are you sure you want to cancel this roommate request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // TODO: Replace with actual API call
        // await ApiService.cancelRoommateRequest(request.id);

        _showSuccessSnackbar('Roommate request cancelled successfully!');
        _loadData(); // Reload data
      } catch (e) {
        _showErrorSnackbar('Failed to cancel request: $e');
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Roommate Requests'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: [
            Tab(
              icon: Icon(Icons.public),
              text: 'All Requests',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: 'My Requests',
            ),
            Tab(
              icon: Icon(Icons.handshake),
              text: 'Joined',
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildAllRequestsTab(),
          _buildMyRequestsTab(),
          _buildJoinedRequestsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRoommateRequest,
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add),
        label: Text('Create Request'),
      ),
    );
  }

  Widget _buildAllRequestsTab() {
    if (allRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No roommate requests available',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllRequests,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: allRequests.length,
        itemBuilder: (context, index) {
          final request = allRequests[index];
          return _buildRequestCard(
            request: request,
            showJoinButton: true,
            onJoin: () => _joinRequest(request),
          );
        },
      ),
    );
  }

  Widget _buildMyRequestsTab() {
    if (myRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'You haven\'t created any requests yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to create your first request',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMyRequests,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: myRequests.length,
        itemBuilder: (context, index) {
          final request = myRequests[index];
          return _buildRequestCard(
            request: request,
            showCancelButton: true,
            onCancel: () => _cancelRequest(request),
          );
        },
      ),
    );
  }

  Widget _buildJoinedRequestsTab() {
    if (joinedRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'You haven\'t joined any requests yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadJoinedRequests,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: joinedRequests.length,
        itemBuilder: (context, index) {
          final request = joinedRequests[index];
          return _buildRequestCard(request: request);
        },
      ),
    );
  }

  Widget _buildRequestCard({
    required RoommateRequest request,
    bool showJoinButton = false,
    bool showCancelButton = false,
    VoidCallback? onJoin,
    VoidCallback? onCancel,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    request.studentName[0].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.studentName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Room ${request.roomNumber}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: request.status == 'OPEN' ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      color: request.status == 'OPEN' ? Colors.green[800] : Colors.orange[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Preferences:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4),
            Text(
              request.preferences,
              style: TextStyle(fontSize: 14),
            ),
            if (showJoinButton || showCancelButton) ...[
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showJoinButton && request.status == 'OPEN')
                    ElevatedButton.icon(
                      onPressed: onJoin,
                      icon: Icon(Icons.handshake, size: 18),
                      label: Text('Join Request'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  if (showCancelButton)
                    ElevatedButton.icon(
                      onPressed: onCancel,
                      icon: Icon(Icons.cancel, size: 18),
                      label: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

