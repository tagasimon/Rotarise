import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
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
          _buildSection(
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
          _buildSection(
            title: 'Meeting Information',
            icon: Icons.schedule,
            child: Column(
              children: [
                if (club.meetingDay != null)
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Meeting Day',
                    value: club.meetingDay!,
                  ),
                if (club.meetingTime != null)
                  _buildInfoRow(
                    icon: Icons.access_time,
                    label: 'Meeting Time',
                    value: club.meetingTime!,
                  ),
                if (club.meetingDay == null && club.meetingTime == null)
                  _buildInfoRow(
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
            _buildSection(
              title: 'Location',
              icon: Icons.location_on_outlined,
              child: Column(
                children: [
                  if (club.location != null)
                    _buildInfoRow(
                      icon: Icons.place,
                      label: 'Meeting Location',
                      value: club.location!,
                    ),
                  if (club.address != null)
                    _buildInfoRow(
                      icon: Icons.home,
                      label: 'Address',
                      value: club.address!,
                    ),
                  if (club.city != null)
                    _buildInfoRow(
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
            _buildSection(
              title: 'Contact Information',
              icon: Icons.contact_phone_outlined,
              child: Column(
                children: [
                  if (club.email != null)
                    _buildContactRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: club.email!,
                      onTap: () => _launchEmail(club.email!),
                    ),
                  if (club.phone != null)
                    _buildContactRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: club.phone!,
                      onTap: () => _launchPhone(club.phone!),
                    ),
                  if (club.website != null)
                    _buildContactRow(
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
            _buildSection(
              title: 'Social Media',
              icon: Icons.share_outlined,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (club.facebook != null)
                    _buildSocialButton(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2),
                      onTap: () => _launchUrl(club.facebook!),
                    ),
                  if (club.instagram != null)
                    _buildSocialButton(
                      icon: Icons.camera_alt,
                      label: 'Instagram',
                      color: const Color(0xFFE4405F),
                      onTap: () => _launchUrl(club.instagram!),
                    ),
                  if (club.twitter != null)
                    _buildSocialButton(
                      icon: Icons.alternate_email,
                      label: 'Twitter',
                      color: const Color(0xFF1DA1F2),
                      onTap: () => _launchUrl(club.twitter!),
                    ),
                  if (club.linkedin != null)
                    _buildSocialButton(
                      icon: Icons.business,
                      label: 'LinkedIn',
                      color: const Color(0xFF0A66C2),
                      onTap: () => _launchUrl(club.linkedin!),
                    ),
                  if (club.youtube != null)
                    _buildSocialButton(
                      icon: Icons.play_arrow,
                      label: 'YouTube',
                      color: const Color(0xFFFF0000),
                      onTap: () => _launchUrl(club.youtube!),
                    ),
                  if (club.whatsapp != null)
                    _buildSocialButton(
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
          _buildSection(
            title: 'Club Statistics',
            icon: Icons.analytics_outlined,
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people_outline,
                    label: 'Members',
                    value: club.membersCount?.toString() ?? '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.event_outlined,
                    label: 'Events',
                    value: club.eventsCount?.toString() ?? '0',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
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
            _buildSection(
              title: 'Established',
              icon: Icons.history,
              child: _buildInfoRow(
                icon: Icons.cake_outlined,
                label: 'Founded',
                value: _formatDate(club.foundedDate),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.launch,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
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
