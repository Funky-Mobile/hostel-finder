import 'package:flutter/material.dart';
import 'package:hostel_finder/features/home/widgets/hostel_amenities.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import '../../room/dao/room_dao.dart';


class PopularHostelCard extends StatelessWidget {
  final RoomDao hostel;
  final VoidCallback? onViewDetails;
  final VoidCallback? onBookNow;

  const PopularHostelCard({
    super.key,
    required this.hostel,
    this.onViewDetails,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = hostel.images.isNotEmpty ? hostel.images.first : '';

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
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
            /// ---- Image Section ----
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      height: 200,
                      child: const Center(
                        child: Icon(
                          Icons.home_work_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const CustomAppBodyText(
                      text: '🔥 Popular',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                  ),
                ),

                /// Price
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomAppBodyText(
                      text: 'GHS${hostel.price.toStringAsFixed(0)}/Semester',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textColor: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),

            /// ---- Content Section ----
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Hostel (Room) Number + Type
                  CustomAppHeaderText(
                    text: '${hostel.number} - ${hostel.type}',
                    size: 20,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textColor: Colors.grey.shade800,
                  ),

                  const SizedBox(height: 6),

                  /// Capacity & Gender
                  CustomAppBodyText(
                    text:
                    '${hostel.capacity} beds • ${hostel.gender.toUpperCase()} only',
                    fontSize: 12,
                    textColor: Colors.grey.shade600,
                  ),

                  const SizedBox(height: 8),

                  /// Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hostel.status == 'available'
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomAppBodyText(
                      text: hostel.status == 'available'
                          ? 'Available'
                          : 'Unavailable',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      textColor: hostel.status == 'available'
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Description
                  CustomAppBodyText(
                    text: hostel.description,
                    fontSize: 13,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textColor: Colors.grey.shade700,
                  ),

                  const SizedBox(height: 12),

                  /// Amenities (show top 4)
                  HostelAmenities(
                      amenities: hostel.amenities.take(4).toList()),

                  const SizedBox(height: 16),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onViewDetails,
                          icon:
                          const Icon(Icons.visibility_outlined, size: 18),
                          label: const CustomAppBodyText(
                            text: 'View Details',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: hostel.status == 'available'
                              ? onBookNow
                              : null,
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: const CustomAppBodyText(
                            text: 'Book Now',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                          ),
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
    );
  }
}
