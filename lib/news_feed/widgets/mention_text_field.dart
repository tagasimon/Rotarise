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

    if (ClubMentionService.isMentionPosition(text, cursorPosition)) {
      final mention =
          ClubMentionService.getCurrentMention(text, cursorPosition);
      _showClubSuggestions(mention);
    } else {
      _hideSuggestions();
    }

    // Extract and update tagged club IDs
    _updateTaggedClubs();
  }

  void _updateTaggedClubs() {
    final clubsAsyncValue = ref.read(getAllVerifiedClubsProvider);
    clubsAsyncValue.whenData((clubs) {
      final mentions = ClubMentionService.extractMentions(
        widget.controller.text,
        clubs,
      );

      final newTaggedClubIds = mentions.map((m) => m.clubId).toList();
      if (newTaggedClubIds != _taggedClubIds) {
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

    widget.controller.text = newText;

    // Set cursor position after the mention
    final beforeCursor = text.substring(0, cursorPosition);
    final lastAtIndex = beforeCursor.lastIndexOf('@');
    final newCursorPosition =
        lastAtIndex + club.name.length + 2; // +2 for @ and space

    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPosition),
    );

    _hideSuggestions();
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
      ),
    );
  }
}
