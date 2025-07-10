import 'package:flutter/material.dart';
import 'package:rotaract/discover/models/visit_model.dart';

class VisitImageWidget extends StatelessWidget {
  final VisitModel visit;

  const VisitImageWidget({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: visit.imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                visit.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image, color: Colors.grey.shade400),
              ),
            )
          : Icon(Icons.location_on, color: Colors.grey.shade400),
    );
  }
}
