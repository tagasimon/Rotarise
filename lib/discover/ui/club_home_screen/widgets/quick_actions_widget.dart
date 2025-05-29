import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickActionsWidget extends StatelessWidget {
  final ClubModel club;
  const QuickActionsWidget({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final actions = <Map<String, dynamic>>[];

    if (club.email != null) {
      actions.add({
        'icon': FontAwesomeIcons.envelope,
        'label': 'Email',
        'color': Colors.red.shade400,
        'onTap': () => _launchUrl('mailto:${club.email}'),
      });
    }

    if (club.phone != null) {
      actions.add({
        'icon': FontAwesomeIcons.phoneVolume,
        'label': 'Call',
        'color': Colors.green.shade400,
        'onTap': () => _launchUrl('tel:${club.phone}'),
      });
    }

    if (club.website != null) {
      actions.add({
        'icon': FontAwesomeIcons.globe,
        'label': 'Website',
        'color': Colors.blue.shade400,
        'onTap': () => _launchUrl(club.website!),
      });
    }

    if (club.whatsapp != null) {
      actions.add({
        'icon': FontAwesomeIcons.whatsapp,
        'label': 'WhatsApp',
        'color': Colors.green.shade600,
        'onTap': () => _launchUrl('https://wa.me/${club.whatsapp}'),
      });
    }

    if (actions.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: actions
              .map((action) => Expanded(
                    child: _buildQuickActionButton(
                      icon: action['icon'],
                      label: action['label'],
                      color: action['color'],
                      onTap: action['onTap'],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
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
