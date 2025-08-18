import 'package:flutter/material.dart';
import 'package:hostel_finder/core/app_routes.dart';
import 'package:hostel_finder/core/naviagtor/app_navigator.dart';
import 'package:hostel_finder/core/user/user_view_model.dart';
import 'package:hostel_finder/features/all_hostels/all_rooms_screen.dart';
import 'package:hostel_finder/features/bookings/booking_history.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostels.dart';
import 'package:hostel_finder/features/room/room_view_model/room_view_model.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:get/get.dart';
import '../../core/cache/token_cache_service.dart';
import '../favorites/controllers/favorites_controller.dart';
import '../favorites/favorites.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  final RoomViewModel _roomViewModel = Get.put(RoomViewModel());
  final controller = Get.find<FavoritesController>();
  final UserViewModel _userViewModel = Get.find<UserViewModel>();

  late AnimationController _fadeController;
  late AnimationController _slideController;


  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _loadInitDataRooms();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadInitDataRooms() {
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            // Profile Section
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), // replace with user image
              ),
              accountName: Text(
                _userViewModel.user.value!.fullName,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(
                _userViewModel.user.value!.email,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.library_books_sharp,
                    title: 'My bookings',
                    color: Colors.blue,
                    widget: BookingHistory()
                  ),
                  // _buildDrawerItem(
                  //   icon: Icons.card_giftcard,
                  //   title: 'Rewards',
                  //   badgeCount: 2,
                  //   color: Colors.red,
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.location_on,
                  //   title: 'Address',
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.payment,
                  //   title: 'Payments Methods',
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.local_offer,
                  //   title: 'Offers',
                  //   badgeCount: 2,
                  //   color: Colors.green,
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.person_add,
                  //   title: 'Refer a Friend',
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.support_agent,
                  //   title: 'Support',
                  // ),
                ],
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.black),
                title: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  bool? confirmLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirmLogout == true) {
                    // Clear the auth token
                    await TokenCacheService.clearToken();

                    // Navigate to login screen and remove all previous routes
                    if(context.mounted) {
                      setState(() {
                        AppNavigator.popAllUntil(context, AppRoutes.loginScreen);
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),

      body: FutureBuilder(
          future: _roomViewModel.fetchRooms(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
            }

            if(snapshot.connectionState == ConnectionState.done && snapshot.data!.isEmpty) {
              return Center(child: CustomAppBodyText(text: "No hostel available at the moment."));
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeroSection(),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: _buildSearchSection(context),
                  ),
                ),


                // Main Content
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        _buildQuickStats(snapshot.data!.length),

                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomAppHeaderText(
                                text: "Popular Hostels",
                                size: 22,
                                fontWeight: FontWeight.w700,
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (builder) => AllRoomsScreen(
                                      headerString: "All Hostels",
                                    ),
                                  ),
                                ),
                                child: const CustomAppBodyText(
                                  text: "View All",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  textColor: Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        snapshot.data!.isEmpty
                            ? _buildLoadingState()
                            : FadeTransition(
                          opacity: _fadeController,
                          child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _slideController,
                                curve: Curves.easeOutCubic,
                              )),
                              child: PopularHostels(hostelResults: snapshot.data!)
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
      ),

      floatingActionButton: Obx(() {
        return controller.favorites.isNotEmpty
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite, color: Colors.white),
            label: CustomAppBodyText(
              text: "Favorites (${controller.favorites.length})",
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
            backgroundColor: Colors.redAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        )
            : const SizedBox.shrink();
      }),
    );
  }

  // Drawer item helper
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    int? badgeCount,
    Widget? widget,
    Color color = Colors.blue,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade800),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: badgeCount != null
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          badgeCount.toString(),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      )
          : null,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (builder) => widget!));
      },
    );
  }

  Widget _buildHeroSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E40AF),
            const Color(0xFF3B82F6),
            const Color(0xFF60A5FA),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const CustomAppHeaderText(
                        text: "Find Your Perfect",
                        size: 28,
                        fontWeight: FontWeight.w300,
                        textColor: Colors.white,
                      ),
                      const CustomAppHeaderText(
                        text: "Student Hostel.",
                        size: 32,
                        fontWeight: FontWeight.w800,
                        textColor: Colors.white,
                      ),
                    ],
                  ),

                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    }
                  )
                ],
              ),

              CustomAppBodyText(
                text: "Discover comfortable and affordable hostel rooms across campus",
                fontSize: 16,
                textColor: Colors.white.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => AllRoomsScreen(
              headerString: CustomAppStrings.recentSearchString,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Colors.grey.shade400,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomAppBodyText(
                  text: "Search for hostels, locations, amenities...",
                  fontSize: 16,
                  textColor: Colors.grey.shade500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(int availableRoomsCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.home_work,
              title: "$availableRoomsCount+",
              subtitle: "Hostels Available",
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.star,
              title: "4.5★",
              subtitle: "Average Rating",
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.verified,
              title: "100%",
              subtitle: "Verified",
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          CustomAppHeaderText(
            text: title,
            size: 18,
            fontWeight: FontWeight.w700,
            textColor: Colors.grey.shade800,
          ),
          CustomAppBodyText(
            text: subtitle,
            fontSize: 12,
            textColor: Colors.grey.shade600,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                color: Color(0xFF3B82F6),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            const CustomAppHeaderText(
              text: "Finding Perfect Hostels",
              size: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 8),
            CustomAppBodyText(
              text: "We're searching for the best hostels near you...",
              fontSize: 14,
              textColor: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
