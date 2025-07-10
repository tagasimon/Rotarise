import 'package:flutter/material.dart';
import 'package:rotaract/discover/models/visit_model.dart';

class VisitDetailsImage extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailsImage({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          visit.imageUrl,
          fit: BoxFit.fitHeight,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.image,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
