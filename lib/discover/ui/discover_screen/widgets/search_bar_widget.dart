import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
import 'package:rotaract/discover/ui/search_clubs_screen/search_clubs_screen.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.push(const SearchClubsScreen());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Discover Clubs...",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
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
}

// Alternative version with more visual feedback
class SearchBarWidgetWithFeedback extends StatefulWidget {
  const SearchBarWidgetWithFeedback({super.key});

  @override
  State<SearchBarWidgetWithFeedback> createState() =>
      _SearchBarWidgetWithFeedbackState();
}

class _SearchBarWidgetWithFeedbackState
    extends State<SearchBarWidgetWithFeedback> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                onTap: () {
                  context.push(const SearchClubsScreen());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(_isPressed ? 0.15 : 0.1),
                        blurRadius: _isPressed ? 5 : 10,
                        offset: Offset(0, _isPressed ? 2 : 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: _isPressed ? Colors.blue : Colors.grey.shade500,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Discover Clubs...",
                          style: TextStyle(
                            color: _isPressed
                                ? Colors.blue.shade700
                                : Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: _isPressed
                            ? Colors.blue.shade400
                            : Colors.grey.shade400,
                        size: 16,
                      ),
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
}
