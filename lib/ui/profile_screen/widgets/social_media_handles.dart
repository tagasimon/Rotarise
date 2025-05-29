import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMediaHandles extends StatelessWidget {
  const SocialMediaHandles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // twitter
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.xTwitter,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        // youtube
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.youtube,
            size: 30,
            color: Colors.red,
          ),
          onPressed: () {},
        ),
        // facebook
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.facebook,
            size: 30,
            color: Colors.blue,
          ),
          onPressed: () {},
        ),
        // instagram
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.instagram,
            size: 30,
            color: Colors.pink,
          ),
          onPressed: () {},
        ),

        // tiktok
        IconButton(
          icon: const Icon(
            FontAwesomeIcons.tiktok,
            size: 30,
            color: Colors.pinkAccent,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
