import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/selected_club_notifier.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/club_home_screen/club_home_screen.dart';
import 'package:rotaract/news_feed/services/club_mention_service.dart';

class MentionableText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const MentionableText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubsAsyncValue = ref.watch(getAllVerifiedClubsProvider);

    return clubsAsyncValue.when(
      data: (clubs) => _buildRichText(context, ref, clubs),
      loading: () => Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
      error: (_, __) => Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  Widget _buildRichText(
      BuildContext context, WidgetRef ref, List<ClubModel> clubs) {
    final mentions = ClubMentionService.extractMentions(text, clubs);

    if (mentions.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final mention in mentions) {
      // Add text before mention
      if (mention.startIndex > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, mention.startIndex),
          style: style,
        ));
      }

      // Add clickable mention
      spans.add(TextSpan(
        text: text.substring(mention.startIndex, mention.endIndex),
        style: (style ?? const TextStyle()).copyWith(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _onMentionTap(context, ref, mention.clubId, clubs),
      ));

      currentIndex = mention.endIndex;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
    );
  }

  void _onMentionTap(BuildContext context, WidgetRef ref, String clubId,
      List<ClubModel> clubs) {
    final club = clubs.firstWhere(
      (c) => c.id == clubId,
      orElse: () => ClubModel(id: '', name: '', isVerified: false),
    );

    if (club.id.isNotEmpty) {
      ref.read(selectedClubNotifierProvider.notifier).updateClub(club);
      context.push(const ClubHomeScreen());
    }
  }
}
