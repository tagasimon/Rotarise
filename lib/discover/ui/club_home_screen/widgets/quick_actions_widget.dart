import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_action_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
            if (club.email != null)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.envelope,
                  label: 'Email',
                  color: Colors.red.shade400,
                  onTap: () => _launchUrl('mailto:${club.email}'),
                ),
              ),
            if (club.phone != null)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.phoneVolume,
                  label: 'Call',
                  color: Colors.green.shade400,
                  onTap: () => _launchUrl('tel:${club.phone}'),
                ),
              ),
            if (club.whatsapp != null)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  color: Colors.green.shade600,
                  onTap: () => _launchUrl('https://wa.me/${club.whatsapp}'),
                ),
              ),
            Expanded(
              child: ClubActionWidget(
                icon: FontAwesomeIcons.diamondTurnRight,
                label: 'Directions',
                color: Colors.purple.shade600,
                onTap: () {
                  // TODO Show scrollable pop up sheet of the club info
                },
              ),
            ),
          ],

          // actions
          //     .map((action) => Expanded(
          //           child: _buildQuickActionButton(
          //             icon: action['icon'],
          //             label: action['label'],
          //             color: action['color'],
          //             onTap: action['onTap'],
          //           ),
          //         ))
          //     .toList(),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
