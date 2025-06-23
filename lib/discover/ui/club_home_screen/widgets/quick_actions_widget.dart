import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/_constants/widget_helpers.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_action_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final ClubModel club;
  const QuickActionsWidget({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (club.email != null && club.email!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.envelope,
                  label: 'Email',
                  color: Colors.red.shade400,
                  onTap: () => WidgetHelpers.launchEmail(club.email!),
                ),
              ),
            if (club.phone != null && club.phone!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.phoneVolume,
                  label: 'Call',
                  color: Colors.green.shade400,
                  onTap: () => WidgetHelpers.launchPhone(club.phone!),
                ),
              ),
            if (club.whatsapp != null && club.whatsapp!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  color: Colors.green.shade600,
                  onTap: () => WidgetHelpers.launchWhatsApp(club.whatsapp!),
                ),
              ),
            if (club.location != null && club.location!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.diamondTurnRight,
                  label: 'Directions',
                  color: Colors.purple.shade600,
                  onTap: () => WidgetHelpers.launchDirections(club.location!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
