import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/constants/constants.dart';

class HeroImageWidget extends StatelessWidget {
  final ClubModel club;
  const HeroImageWidget({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          club.coverImageUrl ?? club.imageUrl ?? Constants.kDefaultImageLink,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade400,
            ],
          ),
        ),
      ),
    );
  }
}
