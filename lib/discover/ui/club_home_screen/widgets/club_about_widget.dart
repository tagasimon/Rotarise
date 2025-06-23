import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/about_section_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/about_stat_card_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/contact_row_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/info_row_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/social_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubAboutWidget extends ConsumerWidget {
  const ClubAboutWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final club = ref.watch(selectedClubNotifierProvider);

    if (club == null) {
      return const Center(
        child: Text(
          'No club information available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Club Description Section
          AboutSectionWidget(
            title: 'About Us',
            icon: Icons.info_outline,
            child: Text(
              club.description ?? 'No description available',
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Meeting Information Section
          AboutSectionWidget(
            title: 'Meeting Information',
            icon: Icons.schedule,
            child: Column(
              children: [
                if (club.meetingDay != null)
                  InfoRowWidget(
                    icon: Icons.calendar_today,
                    label: 'Meeting Day',
                    value: club.meetingDay!,
                  ),
                if (club.meetingTime != null)
                  InfoRowWidget(
                    icon: Icons.access_time,
                    label: 'Meeting Time',
                    value: club.meetingTime!,
                  ),
                if (club.meetingDay == null && club.meetingTime == null)
                  const InfoRowWidget(
                    icon: Icons.help_outline,
                    label: 'Meeting Schedule',
                    value: 'To be announced',
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Location Information Section
          if (club.location != null ||
              club.address != null ||
              club.city != null)
            AboutSectionWidget(
              title: 'Location',
              icon: Icons.location_on_outlined,
              child: Column(
                children: [
                  if (club.location != null)
                    InfoRowWidget(
                      icon: Icons.place,
                      label: 'Meeting Location',
                      value: club.location!,
                    ),
                  if (club.address != null)
                    InfoRowWidget(
                      icon: Icons.home,
                      label: 'Address',
                      value: club.address!,
                    ),
                  if (club.city != null)
                    InfoRowWidget(
                      icon: Icons.location_city,
                      label: 'City',
                      value:
                          '${club.city}${club.country != null ? ', ${club.country}' : ''}',
                    ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Contact Information Section
          if (_hasContactInfo(club))
            AboutSectionWidget(
              title: 'Contact Information',
              icon: Icons.contact_phone_outlined,
              child: Column(
                children: [
                  if (club.email != null)
                    ContactRowWidget(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: club.email!,
                      onTap: () => _launchEmail(club.email!),
                    ),
                  if (club.phone != null)
                    ContactRowWidget(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: club.phone!,
                      onTap: () => _launchPhone(club.phone!),
                    ),
                  if (club.website != null)
                    ContactRowWidget(
                      icon: Icons.language_outlined,
                      label: 'Website',
                      value: club.website!,
                      onTap: () => _launchUrl(club.website!),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Social Media Section
          if (_hasSocialMedia(club))
            AboutSectionWidget(
              title: 'Social Media',
              icon: Icons.share_outlined,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (club.facebook != null)
                    SocialButtonWidget(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2),
                      onTap: () => _launchUrl(club.facebook!),
                    ),
                  if (club.instagram != null)
                    SocialButtonWidget(
                      icon: Icons.camera_alt,
                      label: 'Instagram',
                      color: const Color(0xFFE4405F),
                      onTap: () => _launchUrl(club.instagram!),
                    ),
                  if (club.twitter != null)
                    SocialButtonWidget(
                      icon: Icons.alternate_email,
                      label: 'Twitter',
                      color: const Color(0xFF1DA1F2),
                      onTap: () => _launchUrl(club.twitter!),
                    ),
                  if (club.linkedin != null)
                    SocialButtonWidget(
                      icon: Icons.business,
                      label: 'LinkedIn',
                      color: const Color(0xFF0A66C2),
                      onTap: () => _launchUrl(club.linkedin!),
                    ),
                  if (club.youtube != null)
                    SocialButtonWidget(
                      icon: Icons.play_arrow,
                      label: 'YouTube',
                      color: const Color(0xFFFF0000),
                      onTap: () => _launchUrl(club.youtube!),
                    ),
                  if (club.whatsapp != null)
                    SocialButtonWidget(
                      icon: Icons.chat,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: () => _launchUrl(club.whatsapp!),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Club Statistics Section
          AboutSectionWidget(
            title: 'Club Statistics',
            icon: Icons.analytics_outlined,
            child: Row(
              children: [
                Expanded(
                  child: AboutStatCardWidget(
                    icon: Icons.people_outline,
                    label: 'Members',
                    value: club.membersCount?.toString() ?? '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AboutStatCardWidget(
                    icon: Icons.event_outlined,
                    label: 'Events',
                    value: club.eventsCount?.toString() ?? '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AboutStatCardWidget(
                    icon: Icons.work_outline,
                    label: 'Projects',
                    value: club.projectsCount?.toString() ?? '0',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Founded Date Section
          if (club.foundedDate != null)
            AboutSectionWidget(
              title: 'Established',
              icon: Icons.history,
              child: InfoRowWidget(
                icon: Icons.cake_outlined,
                label: 'Founded',
                value: _formatDate(club.foundedDate),
              ),
            ),
        ],
      ),
    );
  }

  bool _hasContactInfo(club) {
    return club.email != null || club.phone != null || club.website != null;
  }

  bool _hasSocialMedia(club) {
    return club.facebook != null ||
        club.instagram != null ||
        club.twitter != null ||
        club.linkedin != null ||
        club.youtube != null ||
        club.whatsapp != null;
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';
    try {
      final DateTime dateTime =
          date is DateTime ? date : DateTime.parse(date.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error - could show a snackbar
      debugPrint('Could not launch $url: $e');
    }
  }

  Future<void> _launchEmail(String email) async {
    await _launchUrl('mailto:$email');
  }

  Future<void> _launchPhone(String phone) async {
    await _launchUrl('tel:$phone');
  }
}
