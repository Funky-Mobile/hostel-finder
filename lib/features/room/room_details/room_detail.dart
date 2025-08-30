import 'package:flutter/material.dart';
import 'package:hostel_finder/features/room/room_details/widgets/hostel_photos.dart';
import 'package:hostel_finder/features/room/room_details/widgets/room_enquiry.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import '../dao/room_dao.dart';


class RoomDetail extends StatefulWidget {

  final RoomDao room;

  const RoomDetail({super.key, required this.room});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pageController = PageController();

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool get _isAvailable {
    return widget.room.status.toLowerCase() == 'available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Hero Image Section
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageCarousel(),
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
              child: FadeTransition(
                opacity: _fadeController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeOutCubic,
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Main Room Info Section
                      _buildMainInfoSection(),

                      const SizedBox(height: 24),

                      // Room Details Section
                      _buildRoomDetailsSection(),

                      const SizedBox(height: 24),

                      // Amenities Section
                      _buildAmenitiesSection(),

                      const SizedBox(height: 24),

                      // Photos Section
                      _buildPhotosSection(),

                      const SizedBox(height: 100), // Bottom padding for FAB
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _isAvailable
              ? () => RoomEnquiry().showBottomModalSheet(context, widget.room)
              : null,
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          label: CustomAppBodyText(
            text: _isAvailable
                ? "Book This Room"
                : "Room Not Available",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAvailable
                ? const Color(0xFF3B82F6)
                : Colors.grey.shade400,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageCarousel() {
    final images = widget.room.images;

    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.home_work_outlined, size: 80, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.home_work_outlined, size: 80, color: Colors.grey),
                ),
              ),
            );
          },
        ),

        // Image Indicator
        Positioned(
          bottom: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomAppBodyText(
              text: "${_currentImageIndex + 1}/${images.length}",
              fontSize: 12,
              textColor: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Availability Badge
        Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _isAvailable
                  ? Colors.green.shade600
                  : Colors.red.shade600,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomAppBodyText(
              text: _isAvailable ? "Available" : "Occupied",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBodyText(
                      text: "GHS${widget.room.price.toInt()}",
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      textColor: Colors.white,
                    ),
                    const CustomAppBodyText(
                      text: "per semester",
                      fontSize: 12,
                      textColor: Colors.white70,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isAvailable ? Colors.green.shade300 : Colors.red.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isAvailable ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: _isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                    const SizedBox(width: 4),
                    CustomAppBodyText(
                      text: widget.room.status.toUpperCase(),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: _isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Room Number and Type
          CustomAppHeaderText(
            text: "Room ${widget.room.number}",
            size: 28,
            fontWeight: FontWeight.w800,
            textColor: Colors.grey.shade800,
          ),

          const SizedBox(height: 8),

          // Room Type and Capacity
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomAppBodyText(
                  text: widget.room.type,
                  fontSize: 14,
                  textColor: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomAppBodyText(
                  text: "${widget.room.capacity} ${widget.room.capacity == 1 ? 'person' : 'people'}",
                  fontSize: 14,
                  textColor: Colors.purple.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.room.gender.toLowerCase() == 'male'
                      ? Colors.cyan.shade50
                      : Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomAppBodyText(
                  text: "${widget.room.gender} only",
                  fontSize: 14,
                  textColor: widget.room.gender.toLowerCase() == 'male'
                      ? Colors.cyan.shade700
                      : Colors.pink.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppHeaderText(
              text: "Room Description",
              size: 18,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 12),
            CustomAppBodyText(
              text: widget.room.description,
              fontSize: 15,
              textColor: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    if (widget.room.amenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppHeaderText(
            text: "Room Amenities",
            size: 22,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.room.amenities.length,
              itemBuilder: (context, index) {
                final amenity = widget.room.amenities[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getAmenityIcon(amenity),
                        size: 16,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: CustomAppBodyText(
                          text: amenity,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.blue.shade700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    if (widget.room.images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppHeaderText(
            text: "Room Photos",
            size: 22,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          HostelPhotos(hostelPhotosUrls: widget.room.images),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi') || lowerAmenity.contains('internet')) {
      return Icons.wifi;
    } else if (lowerAmenity.contains('ac') || lowerAmenity.contains('air')) {
      return Icons.ac_unit;
    } else if (lowerAmenity.contains('bed') || lowerAmenity.contains('mattress')) {
      return Icons.bed;
    } else if (lowerAmenity.contains('desk') || lowerAmenity.contains('table')) {
      return Icons.desk;
    } else if (lowerAmenity.contains('wardrobe') || lowerAmenity.contains('closet')) {
      return Icons.weekend;
    } else if (lowerAmenity.contains('window') || lowerAmenity.contains('ventilation')) {
      return Icons.window;
    } else if (lowerAmenity.contains('fan')) {
      return Icons.toys;
    } else if (lowerAmenity.contains('light') || lowerAmenity.contains('lamp')) {
      return Icons.lightbulb;
    }
    // else if (lowerAmenity.contains('mirror')) {
    //   return Icons.mirror;
    // }
    else if (lowerAmenity.contains('socket') || lowerAmenity.contains('outlet')) {
      return Icons.power;
    } else {
      return Icons.check_circle;
    }
  }
}