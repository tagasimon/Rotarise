import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/drag_indicator.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/header_title.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/info_sections.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/member_action_button.dart';
import 'package:rotaract/discover/ui/members_tab_screen/widgets/profile_section.dart';

class MemberDetailSheet extends ConsumerStatefulWidget {
  final ClubMemberModel member;
  final bool isProfileScreen;
  const MemberDetailSheet(
      {super.key, required this.member, this.isProfileScreen = true});

  @override
  ConsumerState<MemberDetailSheet> createState() => _MemberDetailSheetState();
}

class _MemberDetailSheetState extends ConsumerState<MemberDetailSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scrollController = ScrollController();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.grey[900]!, Colors.black]
                : [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Column(
          children: [
            if (widget.isProfileScreen) const DragIndicator(),
            if (widget.isProfileScreen) HeaderTitle(isDark: isDark),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileSection(
                          member: widget.member,
                          isProfileScreen: widget.isProfileScreen,
                        ),
                        const SizedBox(height: 32),
                        InfoSections(member: widget.member, isDark: isDark),
                        const SizedBox(height: 32),
                        if (widget.isProfileScreen) const MemberActionButton(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
