import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/news_feed/models/club_mention_model.dart';

class ClubMentionService {
  /// Search clubs by name or nickname
  static List<ClubModel> searchClubs(String query, List<ClubModel> allClubs) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return allClubs
        .where((club) {
          return club.name.toLowerCase().contains(lowerQuery) ||
              (club.nickName?.toLowerCase().contains(lowerQuery) ?? false);
        })
        .take(5) // Limit to 5 suggestions
        .toList();
  }

  /// Extract mentions from text
  static List<ClubMention> extractMentions(
      String text, List<ClubModel> allClubs) {
    final mentions = <ClubMention>[];

    // Regex to match @mentions (supports multi-word names)
    final regex = RegExp(r'@(\w+(?:\s+\w+)*)', caseSensitive: false);
    final matches = regex.allMatches(text);

    for (final match in matches) {
      final mentionText = match.group(1)!.toLowerCase();

      // Find matching club
      final club = allClubs.firstWhere(
        (club) =>
            club.name.toLowerCase() == mentionText ||
            (club.nickName?.toLowerCase() == mentionText),
        orElse: () => ClubModel(id: '', name: '', isVerified: false),
      );

      if (club.id.isNotEmpty) {
        mentions.add(ClubMention(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          clubId: club.id,
          clubName: club.name,
          handle: _generateHandle(club.name),
          startIndex: match.start,
          endIndex: match.end,
        ));
      }
    }

    return mentions;
  }

  /// Generate a handle from club name
  static String _generateHandle(String clubName) {
    return clubName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  /// Check if cursor is at mention position
  static bool isMentionPosition(String text, int cursorPosition) {
    if (cursorPosition == 0) return false;

    // Look for @ symbol before cursor
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    if (lastAtIndex == -1) return false;

    // Check if there's any whitespace between @ and cursor
    final afterAt = beforeCursor.substring(lastAtIndex + 1);
    return !afterAt.contains(' ') && !afterAt.contains('\n');
  }

  /// Get current mention being typed
  static String getCurrentMention(String text, int cursorPosition) {
    if (!isMentionPosition(text, cursorPosition)) return '';

    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    return beforeCursor.substring(lastAtIndex + 1);
  }

  /// Replace mention in text
  static String replaceMention(
      String text, int cursorPosition, String mentionText) {
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    if (lastAtIndex == -1) return text;

    final beforeMention = text.substring(0, lastAtIndex);
    final afterCursor = text.substring(cursorPosition);

    return '$beforeMention@$mentionText $afterCursor';
  }
}
