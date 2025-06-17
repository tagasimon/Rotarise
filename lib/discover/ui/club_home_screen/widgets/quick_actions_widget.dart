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
            if (club.email != null && club.email!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.envelope,
                  label: 'Email',
                  color: Colors.red.shade400,
                  onTap: () => _launchEmail(club.email!),
                ),
              ),
            if (club.phone != null && club.phone!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.phoneVolume,
                  label: 'Call',
                  color: Colors.green.shade400,
                  onTap: () => _launchPhone(club.phone!),
                ),
              ),
            if (club.whatsapp != null && club.whatsapp!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  color: Colors.green.shade600,
                  onTap: () => _launchWhatsApp(club.whatsapp!),
                ),
              ),
            if (club.location != null && club.location!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.diamondTurnRight,
                  label: 'Directions',
                  color: Colors.purple.shade600,
                  onTap: () => _launchDirections(club.location!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch email client');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  void _launchPhone(String phone) async {
    // Clean the phone number and ensure it has proper formatting
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch phone dialer');
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  void _launchWhatsApp(String whatsapp) async {
    // Clean the WhatsApp number (remove spaces, dashes, etc.)
    String cleanNumber = whatsapp.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure the number starts with country code
    if (!cleanNumber.startsWith('+')) {
      // If no country code, you might want to add a default one
      // For example, if most numbers are from a specific country
      cleanNumber = '+$cleanNumber';
    }

    final uri = Uri.parse('https://wa.me/$cleanNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp');
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }

  void _launchDirections(String location) async {
    // URL encode the location string for proper handling of spaces and special characters
    String encodedLocation = Uri.encodeComponent(location);

    // Try Google Maps first, then fallback to Apple Maps on iOS
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
    final appleMapsUrl = 'https://maps.apple.com/?q=$encodedLocation';

    try {
      final googleUri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback to Apple Maps
      final appleUri = Uri.parse(appleMapsUrl);
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
        return;
      }

      debugPrint('Could not launch maps application');
    } catch (e) {
      debugPrint('Error launching directions: $e');
    }
  }
}
