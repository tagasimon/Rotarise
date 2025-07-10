import 'package:flutter/material.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/full_screen_image_viewer.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/full_screen_video_viewer.dart';

class ImageHelpers {
  static void showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenImageViewer(imageUrl: imageUrl),
          );
        },
      ),
    );
  }

  static void showFullScreenVideo(BuildContext context, String videoUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenVideoViewer(videoUrl: videoUrl),
          );
        },
      ),
    );
  }
}
