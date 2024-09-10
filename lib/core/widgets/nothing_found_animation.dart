import 'package:flutter/material.dart';
import 'package:rotaract/core/extensions/extensions.dart';
import 'package:rotaract/core/widgets/animation_widget.dart';

class NothingFoundAnimation extends StatelessWidget {
  final String title;
  final String url;
  const NothingFoundAnimation(
      {super.key,
      required this.title,
      this.url =
          "https://lottie.host/702778e1-d822-45fb-9f2f-cccb523ff420/0qjQG4XUcf.json"});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(title, style: context.textTheme.labelSmall)),
        AnimationWidget(url: url)
      ],
    );
  }
}
