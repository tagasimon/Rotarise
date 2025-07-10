import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';

/// A stateless widget to display the details of a specific club role in a modal.
class RoleDetailsModal extends StatelessWidget {
  final ClubRole role;
  final List<Color> gradientColors; // Colors for the modal's header gradient

  const RoleDetailsModal({
    super.key,
    required this.role,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7, // Initial height of the modal
      maxChildSize: 0.9, // Maximum height
      minChildSize: 0.5, // Minimum height
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white, // White background for the modal content
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)), // Rounded top corners
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Grey color for the handle
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller:
                      scrollController, // Link to the DraggableScrollableSheet controller
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Role title and description section with gradient background
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (role.description != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              role.description!,
                              style: TextStyle(
                                color: Colors.white.withAlphaa(0.9),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Responsibilities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // List all responsibilities
                    ...role.responsibilities.asMap().entries.map((entry) {
                      return Card(
                        elevation:
                            1, // Subtle shadow for each responsibility card
                        margin: const EdgeInsets.only(
                            bottom: 12), // Spacing between cards
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for responsibility cards
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 12, top: 2),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: gradientColors[
                                      0], // Use the primary gradient color for the number background
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}', // Responsibility number (1-indexed)
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value
                                      .toString(), // The responsibility text
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
