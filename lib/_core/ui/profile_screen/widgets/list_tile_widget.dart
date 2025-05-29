import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String tileTitle;
  final IconData tileIcon;
  const ListTileWidget({
    super.key,
    required this.onPressed,
    required this.tileTitle,
    required this.tileIcon,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tileTitle),
      leading: Icon(
        tileIcon,
        // color: Constants.kSafeBodaOrange,
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.keyboard_arrow_right_sharp,
          // color: Constants.kSafeBodaGray,
        ),
      ),
    );
  }
}
