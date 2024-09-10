import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rotaract/constants/constants.dart';

class CircleImageWidget extends StatelessWidget {
  final String imageUrl;
  final double padding;
  final double radius;
  final double width;
  final Function()? onTap;
  final Color? color;

  const CircleImageWidget({
    super.key,
    required this.imageUrl,
    this.padding = 2,
    this.radius = 18,
    this.width = 40,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color ?? Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(padding), // Border radius
        child: ClipOval(
          child: CachedNetworkImage(
            width: width,
            height: width,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => CachedNetworkImage(
                imageUrl: Constants.kDefaultImageLink, fit: BoxFit.cover),
            // progressIndicatorBuilder: (context, url, downloadProgress) =>
            //     SizedBox(
            //   child: CircularProgressIndicator(
            //       value: downloadProgress.progress, color: Colors.green),
            // ),
          ),
        ),
      ),
    );
  }
}
