import 'package:flutter/material.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../home_screen.dart';

class RoomCardHorizontal extends StatelessWidget {
  final RoomDao room;
  final VoidCallback? onTap;

  const RoomCardHorizontal({
    super.key,
    required this.room,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = room.status.toLowerCase() == 'available';

    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Row(
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.network(
                        room.images.isNotEmpty ? room.images.first : '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.bed_outlined,
                            size: 30,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Availability indicator
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green.shade600 : Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomAppBodyText(
                        text: isAvailable ? 'Available' : 'Occupied',
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Details Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room number and price row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomAppHeaderText(
                            text: 'Room ${room.number}',
                            size: 16,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textColor: Colors.grey.shade800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomAppBodyText(
                            text: 'GHS${room.price.toInt()}',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            textColor: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Room type and capacity
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomAppBodyText(
                            text: room.type,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomAppBodyText(
                          text: '${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}',
                          fontSize: 11,
                          textColor: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Gender restriction and amenities count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: room.gender.toLowerCase() == 'male'
                                ? Colors.cyan.shade50
                                : Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomAppBodyText(
                            text: '${room.gender} only',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            textColor: room.gender.toLowerCase() == 'male'
                                ? Colors.cyan.shade700
                                : Colors.pink.shade700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.featured_play_list_outlined,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 2),
                            CustomAppBodyText(
                              text: '${room.amenities.length} amenities',
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              textColor: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomCardVertical extends StatelessWidget {
  final RoomDao room;
  final VoidCallback? onTap;

  const RoomCardVertical({
    super.key,
    required this.room,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = room.status.toLowerCase() == 'available';

    return Card(
      elevation: 6,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      child: Image.network(
                        room.images.isNotEmpty ? room.images.first : '',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: Icon(
                              Icons.bed_outlined,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Price overlay
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomAppBodyText(
                        text: 'GHS${room.price.toInt()}/sem',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        textColor: Colors.green.shade700,
                      ),
                    ),
                  ),

                  // Gender badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: room.gender.toLowerCase() == 'male'
                            ? Colors.cyan.shade600
                            : Colors.pink.shade600,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomAppBodyText(
                        text: '${room.gender} only',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                    ),
                  ),

                  // Availability badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green.shade600 : Colors.red.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomAppBodyText(
                        text: isAvailable ? 'Available' : 'Occupied',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room number and type row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomAppHeaderText(
                            text: 'Room ${room.number}',
                            size: 18,
                            fontWeight: FontWeight.w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textColor: Colors.grey.shade800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomAppBodyText(
                            text: room.type,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Capacity and status
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        CustomAppBodyText(
                          text: '${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}',
                          fontSize: 12,
                          textColor: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomAppBodyText(
                            text: room.status.toUpperCase(),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            textColor: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Quick features and amenities preview
                    Row(
                      children: [
                        if (room.amenities.contains('WiFi') || room.amenities.any((a) => a.toLowerCase().contains('wifi')))
                          _buildQuickFeature(Icons.wifi, 'WiFi'),
                        if (room.amenities.contains('AC') || room.amenities.any((a) => a.toLowerCase().contains('ac')))
                          const SizedBox(width: 12),
                        if (room.amenities.contains('AC') || room.amenities.any((a) => a.toLowerCase().contains('ac')))
                          _buildQuickFeature(Icons.ac_unit, 'AC'),
                        if (room.amenities.length > 2) ...[
                          const SizedBox(width: 12),
                          _buildQuickFeature(Icons.more_horiz, '+${room.amenities.length - 2}'),
                        ],
                        const Spacer(),
                        TextButton(
                          onPressed: onTap,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            backgroundColor: Colors.blue.shade50,
                            foregroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const CustomAppBodyText(
                            text: 'View Details',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFeature(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.blue.shade600,
        ),
        const SizedBox(width: 4),
        CustomAppBodyText(
          text: label,
          fontSize: 10,
          textColor: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

// Alternative simplified room list item for lists
class RoomListItem extends StatelessWidget {
  final RoomDao room;
  final VoidCallback? onTap;
  final bool showImage;

  const RoomListItem({
    super.key,
    required this.room,
    this.onTap,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = room.status.toLowerCase() == 'available';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: showImage
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 50,
          height: 50,
          child: Image.network(
            room.images.isNotEmpty ? room.images.first : '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: Icon(
                Icons.bed_outlined,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ),
      )
          : Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.bed_outlined,
          color: isAvailable ? Colors.green.shade600 : Colors.red.shade600,
          size: 20,
        ),
      ),
      title: CustomAppHeaderText(
        text: 'Room ${room.number}',
        size: 16,
        fontWeight: FontWeight.w600,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              CustomAppBodyText(
                text: room.type,
                fontSize: 12,
                textColor: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              CustomAppBodyText(
                text: '${room.capacity} ${room.capacity == 1 ? 'person' : 'people'}',
                fontSize: 12,
                textColor: Colors.grey.shade600,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: room.gender.toLowerCase() == 'male'
                      ? Colors.cyan.shade50
                      : Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomAppBodyText(
                  text: '${room.gender} only',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  textColor: room.gender.toLowerCase() == 'male'
                      ? Colors.cyan.shade700
                      : Colors.pink.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomAppBodyText(
                  text: room.status,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  textColor: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomAppBodyText(
            text: 'GHS${room.price.toInt()}',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textColor: Colors.green.shade700,
          ),
          const CustomAppBodyText(
            text: '/semester',
            fontSize: 10,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}