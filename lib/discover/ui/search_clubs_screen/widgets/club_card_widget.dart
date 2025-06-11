import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
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
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  // Enhanced color palette with gradients
  List<Color> get _colorGradient {
    final hash = widget.club.name.hashCode;
    const gradients = [
      [Color(0xFF667EEA), Color(0xFF764BA2)], // Purple-Blue
      [Color(0xFF06BEB6), Color(0xFF48B1BF)], // Teal-Blue
      [Color(0xFFFF9A8B), Color(0xFFA8EDEA)], // Coral-Mint
      [Color(0xFFFEAC5E), Color(0xFFC779D0)], // Orange-Purple
      [Color(0xFF4FACFE), Color(0xFF00F2FE)], // Blue-Cyan
      [Color(0xFF43E97B), Color(0xFF38F9D7)], // Green-Turquoise
    ];
    return gradients[hash.abs() % gradients.length];
  }

  Color get _primaryColor => _colorGradient[0];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.02, 0),
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
    HapticFeedback.mediumImpact();
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
          child: SlideTransition(
            position: _slideAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: _handleTap,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: -5,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        _buildBackgroundPattern(),
                        _buildMainContent(),
                        _buildGlowEffect(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              _colorGradient[0].withOpacity(0.02),
              _colorGradient[1].withOpacity(0.01),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _colorGradient[0].withOpacity(0.03),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _colorGradient[1].withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowEffect() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          gradient: LinearGradient(
            colors: _colorGradient,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_hasDescription) ...[
            const SizedBox(height: 20),
            _buildDescription(),
          ],
          const SizedBox(height: 20),
          _buildMetrics(),
          const SizedBox(height: 16),
          _buildActionArea(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildClubAvatar(),
        const SizedBox(width: 18),
        Expanded(child: _buildClubInfo()),
      ],
    );
  }

  Widget _buildClubAvatar() {
    return Hero(
      tag: 'club_${widget.club.id}',
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _colorGradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: widget.club.imageUrl != null
              ? ImageWidget(
                  imageUrl: widget.club.imageUrl!,
                  size: const Size(24, 24),
                )
              : _buildAvatarFallback(),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _colorGradient,
        ),
      ),
      child: Center(
        child: Text(
          _getClubInitials(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1,
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
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        _buildLocationInfo(),
        const SizedBox(height: 8),
        _buildMeetingInfo(),
      ],
    );
  }

  Widget _buildLocationInfo() {
    if (!_hasAddress) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.location_on_rounded,
              size: 14,
              color: _primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              widget.club.address!,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingInfo() {
    final hasMeetingDay = _hasMeetingDay;
    final hasMeetingTime = _hasMeetingTime;

    if (!hasMeetingDay && !hasMeetingTime) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        if (hasMeetingDay)
          _buildMeetingChip(
              Icons.calendar_today_rounded, widget.club.meetingDay!),
        if (hasMeetingTime)
          _buildMeetingChip(
              Icons.access_time_rounded, widget.club.meetingTime!),
      ],
    );
  }

  Widget _buildMeetingChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAFBFC),
            Color(0xFFF8FAFC),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Text(
        widget.club.description!,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
          height: 1.6,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMetrics() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryColor.withOpacity(0.05),
            _colorGradient[1].withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildMetricItem(Icons.people_rounded,
                  '${widget.club.membersCount ?? 0}', 'Members')),
          Container(
              width: 1, height: 30, color: _primaryColor.withOpacity(0.2)),
          Expanded(
              child: _buildMetricItem(Icons.event_rounded,
                  '${widget.club.eventsCount ?? 0}', 'Events')),
          Container(
              width: 1, height: 30, color: _primaryColor.withOpacity(0.2)),
          Expanded(
              child: _buildMetricItem(Icons.volunteer_activism_rounded,
                  '${widget.club.projectsCount ?? 0}', 'Projects')),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 18, color: _primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: _primaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _colorGradient,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'View Club Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getClubInitials() {
    final words = widget.club.name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
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
