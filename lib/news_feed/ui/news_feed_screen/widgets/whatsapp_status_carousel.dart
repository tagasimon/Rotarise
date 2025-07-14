import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WhatsAppStatusCarousel extends StatelessWidget {
  final List<ClubEventModel> events;
  final Duration storyDuration;

  const WhatsAppStatusCarousel({
    super.key,
    required this.events,
    this.storyDuration = const Duration(seconds: 5),
  });

  void _openStoryViewer(BuildContext context, int startIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventStoryViewer(
          events: events,
          startIndex: startIndex,
          storyDuration: storyDuration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () => _openStoryViewer(context, index),
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status ring container
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withAlphaa(0.6),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: SizedBox(
                        width: 62,
                        height: 62,
                        child: event.imageUrl != null
                            ? Image.network(
                                event.imageUrl!,
                                fit: BoxFit.cover,
                                width: 62,
                                height: 62,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.event,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.event,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Event Title
                  Flexible(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Full-screen story viewer
class EventStoryViewer extends StatefulWidget {
  final List<ClubEventModel> events;
  final int startIndex;
  final Duration storyDuration;

  const EventStoryViewer({
    super.key,
    required this.events,
    required this.startIndex,
    this.storyDuration = const Duration(seconds: 5),
  });

  @override
  State<EventStoryViewer> createState() => _EventStoryViewerState();
}

class _EventStoryViewerState extends State<EventStoryViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  Timer? _timer;
  int _currentIndex = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pageController = PageController(initialPage: widget.startIndex);
    _progressController = AnimationController(
      vsync: this,
      duration: widget.storyDuration,
    );
    _startStory();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _startStory() {
    _progressController.forward();
    _timer = Timer(widget.storyDuration, () {
      _nextStory();
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.events.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.reset();
      _startStory();
    } else {
      // Close the story viewer when done
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _timer?.cancel();
      _progressController.reset();
      _startStory();
    }
  }

  void _pauseStory() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
    _progressController.stop();
  }

  void _resumeStory() {
    setState(() {
      _isPaused = false;
    });
    final remaining = widget.storyDuration * (1 - _progressController.value);
    _timer = Timer(remaining, () {
      _nextStory();
    });
    _progressController.forward();
  }

  String _formatEventDate(Object dateObject) {
    try {
      DateTime date;
      if (dateObject is Timestamp) {
        date = dateObject.toDate();
      } else if (dateObject is DateTime) {
        date = dateObject;
      } else {
        return 'Date TBA';
      }

      final formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(date);
    } catch (e) {
      return 'Date TBA';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main story content
            GestureDetector(
              onTapDown: (details) {
                _pauseStory();
              },
              onTapUp: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                final tapPosition = details.localPosition.dx;

                if (tapPosition < screenWidth * 0.3) {
                  _previousStory();
                } else if (tapPosition > screenWidth * 0.7) {
                  _nextStory();
                } else {
                  _resumeStory();
                }
              },
              onTapCancel: () {
                _resumeStory();
              },
              onLongPressStart: (details) {
                _pauseStory();
              },
              onLongPressEnd: (details) {
                _resumeStory();
              },
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _timer?.cancel();
                  _progressController.reset();
                  _startStory();
                },
                itemCount: widget.events.length,
                itemBuilder: (context, index) {
                  final event = widget.events[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withAlphaa(0.8),
                          Theme.of(context).primaryColor.withAlphaa(0.3),
                          Colors.black.withAlphaa(0.6),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Event image (main content)
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: event.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      event.imageUrl!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.event,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        // Event details
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        event.location,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatEventDate(event.startDate),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Progress indicators at the top
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  widget.events.length,
                  (index) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlphaa(0.3),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          double progress = 0.0;
                          if (index < _currentIndex) {
                            progress = 1.0;
                          } else if (index == _currentIndex) {
                            progress = _progressController.value;
                          }
                          return LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlphaa(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Pause indicator
            if (_isPaused)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlphaa(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
