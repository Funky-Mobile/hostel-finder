import 'package:flutter/material.dart';
import 'package:hostel_finder/features/all_hostels/all_hostels.dart';
import 'package:hostel_finder/features/home/widgets/app_hostel_location.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostels.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:get/get.dart';

import '../favorites/controllers/favorites_controller.dart';
import '../favorites/favorites.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final controller = Get.find<FavoritesController>();

  late AnimationController _fadeController;
  late AnimationController _slideController;

  List<RoomDao> _hostelResults = [];

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

    _loadDummyRooms();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadDummyRooms() {
    final dummyRooms = [
      RoomDao(
        id: "1",
        number: "R102",
        type: "double",
        capacity: 2,
        price: 450.0,
        amenities: ["WiFi", "AC", "Study Desk", "Wardrobe"],
        status: "available",
        description: "Spacious double room perfect for sharing",
        images: [
          "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400",
          "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400"
        ],
        gender: "female",
      ),
      RoomDao(
        id: "2",
        number: "R203",
        type: "single",
        capacity: 1,
        price: 300.0,
        amenities: ["WiFi", "Fan", "Table Lamp"],
        status: "occupied",
        description: "Cozy single room ideal for students",
        images: [
          "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?w=400",
        ],
        gender: "male",
      ),
      RoomDao(
        id: "3",
        number: "R305",
        type: "suite",
        capacity: 3,
        price: 800.0,
        amenities: ["WiFi", "AC", "Fridge", "Balcony"],
        status: "available",
        description: "Luxury suite with extra space",
        images: [
          "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400",
        ],
        gender: "mixed",
      ),
      RoomDao(
        id: "4",
        number: "R108",
        type: "double",
        capacity: 2,
        price: 500.0,
        amenities: ["WiFi", "Hot Shower", "Wardrobe"],
        status: "available",
        description: "Comfortable double room with natural light",
        images: [
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400",
        ],
        gender: "female",
      ),
      RoomDao(
        id: "5",
        number: "R410",
        type: "single",
        capacity: 1,
        price: 350.0,
        amenities: ["WiFi", "Desk", "Bookshelf"],
        status: "available",
        description: "Quiet single room perfect for studies",
        images: [
          "https://images.unsplash.com/photo-1600585153934-7a5d5c4380c2?w=400",
        ],
        gender: "male",
      ),
    ];

    setState(() {
      _hostelResults = dummyRooms;
    });

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
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

                  _buildQuickStats(),

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
                              builder: (builder) => AllHostels(
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

                  _hostelResults.isEmpty
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
                      child: PopularHostels(hostelResults: _hostelResults)
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
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
              // Top Row - Location and Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppHostelLocation(
                      location: "Adenta Municipality",
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Welcome Text
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

              // const SizedBox(height: 12),

              CustomAppBodyText(
                text: "Discover comfortable and affordable hostels across your campus",
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
            builder: (builder) => AllHostels(
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

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.home_work,
              title: "${_hostelResults.length}+",
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

// ✅ RoomDao stays the same
class RoomDao {
  final String id;
  final String number;
  final String type;
  final int capacity;
  final double price;
  final List<String> amenities;
  final String status;
  final String description;
  final List<String> images;
  final String gender;

  RoomDao({
    required this.id,
    required this.number,
    required this.type,
    required this.capacity,
    required this.price,
    required this.amenities,
    required this.status,
    required this.description,
    required this.images,
    required this.gender,
  });

  factory RoomDao.fromJson(Map<String, dynamic> json) {
    return RoomDao(
      id: json['id'],
      number: json['number'],
      type: json['type'],
      capacity: json['capacity'],
      price: (json['price'] as num).toDouble(),
      amenities: List<String>.from(json['amenities']),
      status: json['status'],
      description: json['description'],
      images: List<String>.from(json['images']),
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'type': type,
      'capacity': capacity,
      'price': price,
      'amenities': amenities,
      'status': status,
      'description': description,
      'images': images,
      'gender': gender,
    };
  }

  static List<RoomDao> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => RoomDao.fromJson(json)).toList();
  }
}