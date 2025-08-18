import 'package:flutter/material.dart';
import '../../../shared/app_strings/custom_app_strings.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../shared/custom_buttons/custom_text_and_icon_button.dart';

class EnhancedAllRoomsHeader extends StatefulWidget {
  final String headerString;
  final Function(String) onSearchChanged;
  final VoidCallback onFilterPressed;

  const EnhancedAllRoomsHeader({
    super.key,
    required this.headerString,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  @override
  State<EnhancedAllRoomsHeader> createState() => _EnhancedAllRoomsHeaderState();
}

class _EnhancedAllRoomsHeaderState extends State<EnhancedAllRoomsHeader> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with Filter Button
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: widget.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search rooms...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            searchController.clear();
                            widget.onSearchChanged('');
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: widget.onFilterPressed,
                    icon: Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}