import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:rotaract/_constants/constants.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Size size;
  final BoxFit? boxFitMobile;
  final BoxFitWeb? boxFitWeb;
  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.size,
    this.boxFitMobile,
    this.boxFitWeb,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ImageNetwork(
        height: size.height,
        width: size.width,
        image: imageUrl ?? Constants.kDefaultImageLink,
        fitAndroidIos: boxFitMobile ?? BoxFit.cover,
        fitWeb: boxFitWeb ?? BoxFitWeb.cover,
        onError: Container(
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
    return CachedNetworkImage(
      height: size.height,
      width: size.width,
      imageUrl: imageUrl ?? Constants.kDefaultImageLink,
      fit: boxFitMobile ?? BoxFit.cover,
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
