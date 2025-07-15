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

    // Create a map for faster lookups
    final clubMap = <String, ClubModel>{};
    for (final club in allClubs) {
      clubMap[club.name.toLowerCase()] = club;
      if (club.nickName != null) {
        clubMap[club.nickName!.toLowerCase()] = club;
      }
    }

    // Find all @ symbols and check for mentions after each one
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '@') {
        // Find the end of this potential mention
        int endIndex = i + 1;

        // Look for the longest possible club name match
        ClubModel? matchedClub;
        int bestMatchEnd = i + 1;

        // Try to match club names of different lengths
        while (endIndex <= text.length) {
          final potentialMention = text.substring(i + 1, endIndex);

          // Stop if we hit a line break
          if (potentialMention.contains('\n')) break;

          // Check if this matches any club name
          final club = clubMap[potentialMention.toLowerCase()];
          if (club != null) {
            matchedClub = club;
            bestMatchEnd = endIndex;
          }

          // Stop extending if we hit certain boundaries
          if (endIndex < text.length) {
            final nextChar = text[endIndex];
            // Continue if it's a letter, space, or common word characters
            if (!RegExp(r'[a-zA-Z0-9\s]').hasMatch(nextChar)) {
              break;
            }
          }

          endIndex++;
        }

        // If we found a match, add it to mentions
        if (matchedClub != null) {
          mentions.add(ClubMention(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            clubId: matchedClub.id,
            clubName: matchedClub.name,
            handle: _generateHandle(matchedClub.name),
            startIndex: i,
            endIndex: bestMatchEnd,
          ));

          // Skip past this mention to avoid overlapping matches
          i = bestMatchEnd - 1;
        }
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
    if (cursorPosition <= 0 || cursorPosition > text.length) return false;

    // Look for @ symbol before cursor
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    if (lastAtIndex == -1) return false;

    // Get text between @ and cursor
    final afterAt = beforeCursor.substring(lastAtIndex + 1);

    // If there's already a space or newline after @, check if we're in a completed mention
    if (afterAt.contains(' ') || afterAt.contains('\n')) {
      // This is not a mention position - user is typing after a completed mention
      return false;
    }

    // Check if we're at the end of a potentially completed mention
    // by looking at what comes after the cursor
    if (cursorPosition < text.length) {
      final charAfterCursor = text[cursorPosition];

      // If the next character is a space, we might be at the end of a mention
      // Don't treat this as a mention position if there's already a valid mention here
      if (charAfterCursor == ' ') {
        // This could be the end of a completed mention, don't trigger suggestions
        return false;
      }
    }

    return true;
  }

  /// Check if cursor position is within an existing mention
  static bool isWithinExistingMention(
      String text, int cursorPosition, List<ClubModel> allClubs) {
    final mentions = extractMentions(text, allClubs);

    for (final mention in mentions) {
      if (cursorPosition >= mention.startIndex &&
          cursorPosition <= mention.endIndex) {
        return true;
      }
    }

    return false;
  }

  /// Get current mention being typed
  static String getCurrentMention(String text, int cursorPosition) {
    if (cursorPosition < 0 || !isMentionPosition(text, cursorPosition)) {
      return '';
    }

    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    return beforeCursor.substring(lastAtIndex + 1);
  }

  /// Replace mention in text
  static String replaceMention(
      String text, int cursorPosition, String mentionText) {
    // Validate cursor position
    if (cursorPosition < 0 || cursorPosition > text.length) {
      return text;
    }

    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    if (lastAtIndex == -1) return text;

    final beforeMention = text.substring(0, lastAtIndex);
    final afterCursor = text.substring(cursorPosition);

    // Always add a space after the mention to separate it from following text
    return '$beforeMention@$mentionText $afterCursor';
  }
}
