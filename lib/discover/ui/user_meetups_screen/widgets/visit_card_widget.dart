import 'package:flutter/material.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_details_sheet.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_image_widget.dart';
import 'package:rotaract/discover/ui/user_meetups_screen/widgets/visit_info_widget.dart';

class VisitCardWidget extends StatelessWidget {
  final VisitModel visit;

  const VisitCardWidget({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showVisitDetails(context, visit),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Visit Image
              VisitImageWidget(visit: visit),
              const SizedBox(width: 16),

              // Visit Info
              Expanded(
                child: VisitInfoWidget(visit: visit),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVisitDetails(BuildContext context, VisitModel visit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VisitDetailsSheet(visit: visit),
    );
  }
}
