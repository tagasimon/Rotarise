import 'package:flutter/material.dart';
import 'package:rotaract/discover/models/visit_model.dart';

class VisitDetailsHeader extends StatelessWidget {
  final VisitModel visit;

  const VisitDetailsHeader({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            visit.visitedClubName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
