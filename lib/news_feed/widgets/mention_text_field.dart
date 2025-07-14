import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_constants/constants.dart';
import 'package:rotaract/_core/shared_widgets/circle_image_widget.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/news_feed/services/club_mention_service.dart';

class MentionTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final Function(List<String> taggedClubIds)? onMentionsChanged;
  final VoidCallback? onTextChanged;

  const MentionTextField({
    super.key,
    required this.controller,
    this.hintText = "What's on your mind?",
    this.maxLines,
    this.onMentionsChanged,
    this.onTextChanged,
  });

  @override
  ConsumerState<MentionTextField> createState() => _MentionTextFieldState();
}

class _MentionTextFieldState extends ConsumerState<MentionTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  List<ClubModel> _suggestionClubs = [];
  bool _showSuggestions = false;
  List<String> _taggedClubIds = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;

    widget.onTextChanged?.call();

    // Only check for mentions if we have a valid cursor position and we're actually in a mention
    if (cursorPosition >= 0 && cursorPosition <= text.length) {
      if (ClubMentionService.isMentionPosition(text, cursorPosition)) {
        final mention =
            ClubMentionService.getCurrentMention(text, cursorPosition);
        _showClubSuggestions(mention);
      } else {
        _hideSuggestions();
      }
    } else {
      _hideSuggestions();
    }

    // Extract and update tagged club IDs
    _updateTaggedClubs();
  }

  void _updateTaggedClubs() {
    final clubsAsyncValue = ref.read(getAllVerifiedClubsProvider);
    clubsAsyncValue.whenData((clubs) {
      final text = widget.controller.text;
      final mentions = ClubMentionService.extractMentions(text, clubs);

      // Debug logging to track mention extraction
      debugPrint('🔍 Extracting mentions from text: "$text"');
      debugPrint(
          '📋 Found ${mentions.length} mentions: ${mentions.map((m) => m.clubName).toList()}');

      final newTaggedClubIds = mentions.map((m) => m.clubId).toList();
      if (newTaggedClubIds != _taggedClubIds) {
        debugPrint(
            '🔄 Tagged clubs changed from $_taggedClubIds to $newTaggedClubIds');
        _taggedClubIds = newTaggedClubIds;
        widget.onMentionsChanged?.call(_taggedClubIds);
      }
    });
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _hideSuggestions();
    }
  }

  void _showClubSuggestions(String query) {
    final clubsAsyncValue = ref.read(getAllVerifiedClubsProvider);

    clubsAsyncValue.whenData((clubs) {
      final suggestions = ClubMentionService.searchClubs(query, clubs);

      if (suggestions.isNotEmpty) {
        setState(() {
          _suggestionClubs = suggestions;
          _showSuggestions = true;
        });
        _showOverlay();
      } else {
        _hideSuggestions();
      }
    });
  }

  void _hideSuggestions() {
    if (_showSuggestions) {
      setState(() {
        _showSuggestions = false;
        _suggestionClubs = [];
      });
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestionClubs.length,
                itemBuilder: (context, index) {
                  final club = _suggestionClubs[index];
                  return ListTile(
                    leading: CircleImageWidget(
                      imageUrl: club.imageUrl ?? Constants.kDefaultImageLink,
                      size: 40,
                    ),
                    title: Text(
                      club.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: club.nickName != null
                        ? Text('@${club.nickName}')
                        : null,
                    onTap: () => _selectClub(club),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectClub(ClubModel club) {
    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;

    final newText = ClubMentionService.replaceMention(
      text,
      cursorPosition,
      club.name,
    );

    // Calculate new cursor position: should be right after the mention and space
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');

    int newCursorPosition = newText.length;
    if (lastAtIndex != -1) {
      // Position cursor right after @clubname and space
      newCursorPosition =
          lastAtIndex + club.name.length + 2; // +2 for @ and space
    }

    // Temporarily remove listener to avoid issues
    widget.controller.removeListener(_onTextChanged);

    // Set text and cursor position
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPosition.clamp(0, newText.length)),
    );

    // Re-add listener
    widget.controller.addListener(_onTextChanged);

    _hideSuggestions();

    // Manually trigger update for tagged clubs
    _updateTaggedClubs();

    // Call onTextChanged to ensure any other listeners are notified
    widget.onTextChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 18),
        ),
        style: const TextStyle(fontSize: 16),
        // Ensure the text field allows typing in all positions
        enableInteractiveSelection: true,
        textInputAction: TextInputAction.newline,
      ),
    );
  }
}
