import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/discover/ui/club_home_screen/club_home_screen.dart';

class ClubCardWidget extends ConsumerStatefulWidget {
  final ClubModel club;
  const ClubCardWidget({super.key, required this.club});

  @override
  ConsumerState<ClubCardWidget> createState() => _ClubCardWidgetState();
}

class _ClubCardWidgetState extends ConsumerState<ClubCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => _animationController.forward();
  void _handleTapUp(TapUpDetails details) => _animationController.reverse();
  void _handleTapCancel() => _animationController.reverse();

  void _handleTap() {
    HapticFeedback.lightImpact();
    ref.read(selectedClubNotifierProvider.notifier).updateClub(widget.club);
    context.push(const ClubHomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: _handleTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlphaa(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildMetrics(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildClubAvatar(),
        const SizedBox(width: 12),
        Expanded(child: _buildClubInfo()),
        if (widget.club.isVerified) _buildVerificationBadge(),
      ],
    );
  }

  Widget _buildClubAvatar() {
    return Hero(
      tag: 'club_${widget.club.id}',
      child: SizedBox(
        width: 48,
        height: 48,
        child: CircleImageWidget(
          imageUrl: widget.club.imageUrl ?? Constants.kDefaultImageLink,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildClubInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.club.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            letterSpacing: -0.2,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        _buildLocationOrMeeting(),
      ],
    );
  }

  Widget _buildLocationOrMeeting() {
    String? displayText;
    IconData icon = Icons.location_on_outlined;

    if (_hasAddress) {
      displayText = widget.club.address!;
      icon = Icons.location_on_outlined;
    } else if (_hasMeetingDay) {
      displayText = widget.club.meetingDay!;
      icon = Icons.schedule_outlined;
    } else if (_hasMeetingTime) {
      displayText = widget.club.meetingTime!;
      icon = Icons.schedule_outlined;
    }

    if (displayText == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            displayText,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.verified,
        size: 12,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMetrics() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            Icons.people_outline,
            '${widget.club.membersCount ?? 0}',
            'Members',
          ),
          Container(
            width: 1,
            height: 20,
            color: const Color(0xFFE2E8F0),
          ),
          _buildMetricItem(
            Icons.event_outlined,
            '${widget.club.eventsCount ?? 0}',
            'Events',
          ),
          Container(
            width: 1,
            height: 20,
            color: const Color(0xFFE2E8F0),
          ),
          _buildMetricItem(
            Icons.volunteer_activism_outlined,
            '${widget.club.projectsCount ?? 0}',
            'Projects',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(height: 2),
        Text(
          count,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool get _hasAddress =>
      widget.club.address != null && widget.club.address!.isNotEmpty;

  bool get _hasMeetingDay =>
      widget.club.meetingDay != null && widget.club.meetingDay!.isNotEmpty;

  bool get _hasMeetingTime =>
      widget.club.meetingTime != null && widget.club.meetingTime!.isNotEmpty;
}
