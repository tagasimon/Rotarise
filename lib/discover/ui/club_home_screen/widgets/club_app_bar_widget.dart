import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/shared_widgets/image_widget.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_header_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/gradient_overlay_widget.dart';
import 'package:rotaract/_core/shared_widgets/action_button_widget.dart';
import 'package:share_plus/share_plus.dart';

class ClubAppBarWidget extends StatelessWidget {
  final ClubModel club;
  final bool isScrolled;
  const ClubAppBarWidget({
    super.key,
    required this.club,
    this.isScrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      floating: false,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: isScrolled ? Colors.white : Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: ActionButtonWidget(
        icon: Icons.arrow_back_ios_new_rounded,
        onPressed: () => context.pop(false),
        isLight: !isScrolled,
      ),
      title: AnimatedOpacity(
        opacity: isScrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          club.name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      actions: [
        ActionButtonWidget(
          icon: Icons.share_rounded,
          onPressed: () async {
            await Share.share(
              'Check out this Rotaract Club: ${club.name}\n\nDownload the app: ${Constants.kAppLink}',
              subject: 'Rotaract Club - ${club.name}',
            );
          },
          isLight: !isScrolled,
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // HeroImageWidget(club: club),
            ImageWidget(
              imageUrl: club.coverImageUrl ?? club.imageUrl,
              size: const Size(350.0, 240.0),
            ),
            const GradientOverlayWidget(),
            ClubHeaderWidget(club: club),
          ],
        ),
      ),
    );
  }
}
