import 'package:flutter/material.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_details_header.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_details_image.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_details_info.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_share_button.dart';

class VisitDetailsSheet extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailsSheet({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  VisitDetailsHeader(visit: visit),

                  const SizedBox(height: 16),

                  // Visit Image
                  if (visit.imageUrl.isNotEmpty)
                    VisitDetailsImage(visit: visit),

                  const SizedBox(height: 24),

                  // Visit Details
                  VisitDetailsInfo(visit: visit),

                  const Spacer(),

                  // Share Button
                  VisitShareButton(visit: visit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
