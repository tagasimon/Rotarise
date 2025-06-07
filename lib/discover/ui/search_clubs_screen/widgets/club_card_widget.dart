import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
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
  late Animation<double> _elevationAnimation;

  // Simplified color palette
  Color get _primaryColor {
    final hash = widget.club.name.hashCode;
    const colors = [
      Color(0xFF6366F1), // Indigo
      Color(0xFF3B82F6), // Blue
      Color(0xFF10B981), // Emerald
      Color(0xFF8B5CF6), // Purple
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
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
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.08),
                    blurRadius: _elevationAnimation.value,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: _elevationAnimation.value * 1.5,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  _buildBackgroundGradient(),
                  _buildMainContent(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundGradient() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              _primaryColor.withOpacity(0.03),
              _primaryColor.withOpacity(0.01),
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(60),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_hasDescription) ...[
            const SizedBox(height: 16),
            _buildDescription(),
          ],
          const SizedBox(height: 16),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildClubAvatar(),
        const SizedBox(width: 16),
        Expanded(child: _buildClubInfo()),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildClubAvatar() {
    return Hero(
      tag: 'club_${widget.club.id}',
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryColor,
              _primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: widget.club.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.club.imageUrl!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  placeholder: (context, url) => Container(
                    color: _primaryColor.withOpacity(0.1),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_primaryColor),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: _primaryColor.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        _getClubInitials(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    _getClubInitials(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
            letterSpacing: -0.3,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        ..._buildInfoChips(),
      ],
    );
  }

  List<Widget> _buildInfoChips() {
    final chips = <Widget>[];

    if (_hasAddress) {
      chips.add(_buildInfoChip(
        Icons.location_on_rounded,
        widget.club.address!,
      ));
    }

    if (_hasMeetingDay) {
      chips.add(_buildInfoChip(
        Icons.calendar_today_rounded,
        widget.club.meetingDay!,
      ));
    }

    if (_hasMeetingTime) {
      chips.add(_buildInfoChip(
        Icons.access_time_rounded,
        widget.club.meetingTime!,
      ));
    }

    if (chips.isEmpty) return [];

    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips
              .map((chip) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: chip,
                  ))
              .toList(),
        ),
      ),
    ];
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF64748B),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        color: _primaryColor,
        size: 18,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        widget.club.description!,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
          height: 1.5,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStats() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatChip(
            Icons.people_rounded,
            '${widget.club.membersCount ?? 0}',
            'members',
            const Color(0xFF64748B),
          ),
          const SizedBox(width: 12),
          _buildStatChip(
            Icons.event_rounded,
            '${widget.club.eventsCount ?? 0}',
            'events',
            const Color(0xFF64748B),
          ),
          const SizedBox(width: 12),
          _buildStatChip(
            Icons.volunteer_activism_rounded,
            '${widget.club.projectsCount ?? 0}',
            'projects',
            const Color(0xFF64748B),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
      IconData icon, String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: count,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' $label',
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getClubInitials() {
    final name = widget.club.name.trim();
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  bool get _hasAddress =>
      widget.club.address != null && widget.club.address!.isNotEmpty;

  bool get _hasMeetingDay =>
      widget.club.meetingDay != null && widget.club.meetingDay!.isNotEmpty;

  bool get _hasMeetingTime =>
      widget.club.meetingTime != null && widget.club.meetingTime!.isNotEmpty;

  bool get _hasDescription =>
      widget.club.description != null && widget.club.description!.isNotEmpty;
}
