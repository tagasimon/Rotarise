import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/member_detail_sheet.dart';

class MemberItemWidget extends ConsumerStatefulWidget {
  final ClubMemberModel member;
  const MemberItemWidget({super.key, required this.member});

  @override
  ConsumerState<MemberItemWidget> createState() => _MemberItemWidgetState();
}

class _MemberItemWidgetState extends ConsumerState<MemberItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Colors.grey[850]!,
                          Colors.grey[900]!,
                        ]
                      : [
                          Colors.white,
                          Colors.grey[50]!,
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.15),
                    blurRadius: _isHovered ? 20 : 12,
                    offset:
                        _isHovered ? const Offset(0, 8) : const Offset(0, 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.grey[700]!.withOpacity(0.3)
                      : Colors.grey[200]!.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    await _animationController.forward();
                    await _animationController.reverse();

                    if (mounted) {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        builder: (_) =>
                            MemberDetailSheet(member: widget.member),
                      );
                    }
                  },
                  onTapDown: (_) => _animationController.forward(),
                  onTapUp: (_) => _animationController.reverse(),
                  onTapCancel: () => _animationController.reverse(),
                  onHover: (hovering) {
                    setState(() {
                      _isHovered = hovering;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        _buildProfileImage(isDark),
                        const SizedBox(width: 20),
                        Expanded(child: _buildMemberInfo(theme, isDark)),
                        _buildActionButton(isDark),
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

  Widget _buildProfileImage(bool isDark) {
    return Hero(
      tag: 'member_${widget.member.id}',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.purple.shade400,
              Colors.pink.shade300,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(3),
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: widget.member.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: widget.member.imageUrl!,
                    placeholder: (context, url) => Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[400],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64,
                  )
                : Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberInfo(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.member.firstName} ${widget.member.lastName}",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        if (widget.member.currentClubRole?.isNotEmpty == true) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade100,
                  Colors.indigo.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 0.5,
              ),
            ),
            child: Text(
              widget.member.currentClubRole!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (widget.member.profession?.isNotEmpty == true)
          Row(
            children: [
              Icon(
                Icons.work_outline,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.member.profession!,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButton(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _isHovered
            ? LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.indigo.shade500,
                ],
              )
            : LinearGradient(
                colors: isDark
                    ? [Colors.grey[700]!, Colors.grey[800]!]
                    : [Colors.grey[100]!, Colors.grey[200]!],
              ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 200),
        turns: _isHovered ? 0.25 : 0,
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: _isHovered
              ? Colors.white
              : (isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
      ),
    );
  }
}
