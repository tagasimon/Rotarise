import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/news_feed/controllers/likes_controller.dart';
import 'package:rotaract/news_feed/models/like_model.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/repos/likes_repo.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_action_widget.dart';
import 'package:uuid/uuid.dart';

class PostLikeWidget extends ConsumerStatefulWidget {
  final PostModel post;
  const PostLikeWidget({super.key, required this.post});

  @override
  ConsumerState<PostLikeWidget> createState() => _PostLikeWidgetState();
}

class _PostLikeWidgetState extends ConsumerState<PostLikeWidget>
    with TickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late AnimationController _burstAnimationController;
  late AnimationController _scaleAnimationController;

  late Animation<double> _likeAnimation;
  late Animation<double> _burstAnimation;
  late Animation<double> _scaleAnimation;

  bool _isAnimating = false;
  bool _showBurst = false;

  @override
  void initState() {
    super.initState();

    // Main like animation (heart bounce)
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _likeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));

    // Burst animation for particles
    _burstAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _burstAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _burstAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Scale animation for tap feedback
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _burstAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  void _animateLike() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _showBurst = true;
    });

    // Quick scale down and up for tap feedback
    await _scaleAnimationController.forward();
    await _scaleAnimationController.reverse();

    // Heart bounce animation
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse();
    });

    // Burst animation
    _burstAnimationController.forward().then((_) {
      setState(() {
        _showBurst = false;
      });
      _burstAnimationController.reset();
    });

    // Delay before allowing next animation
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _isAnimating = false;
    });
  }

  void _animateUnlike() async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    // Quick scale animation for unlike
    await _scaleAnimationController.forward();
    await _scaleAnimationController.reverse();

    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLikedProv = ref.watch(isLikedProvider(widget.post.id));

    return isLikedProv.when(
      data: (isLiked) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _likeAnimation,
            _burstAnimation,
            _scaleAnimation,
          ]),
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Burst effect particles
                if (_showBurst && isLiked)
                  ...List.generate(6, (index) {
                    final angle = (index * 60) * (3.14159 / 180);
                    final distance = 20 * _burstAnimation.value;
                    final opacity = 1.0 - _burstAnimation.value;

                    return Positioned(
                      left: distance * cos(angle),
                      top: distance * sin(angle),
                      child: Transform.scale(
                        scale: 0.8 * _burstAnimation.value,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                // Main widget with animations
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.scale(
                    scale: isLiked ? _likeAnimation.value : 1.0,
                    child: PostActionWidget(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border,
                      count: widget.post.likesCount ?? 0,
                      onTap: () {
                        final cUser = ref.read(currentUserNotifierProvider);
                        if (cUser == null) {
                          Fluttertoast.showToast(msg: "Error!!");
                          return;
                        }

                        if (isLiked) {
                          _animateUnlike();
                          ref
                              .read(likesControllerProvider.notifier)
                              .removeLike(widget.post.id, cUser.id);
                          return;
                        }

                        _animateLike();
                        final likeModel = LikeModel(
                            id: const Uuid().v4(),
                            postId: widget.post.id,
                            userId: cUser.id,
                            likedAt: DateTime.now());
                        ref
                            .read(likesControllerProvider.notifier)
                            .addLike(likeModel);
                      },
                      color: isLiked ? Colors.red : Colors.grey[600]!,
                      isActive: isLiked,
                    ),
                  ),
                ),

                // Glow effect for liked state
                if (isLiked)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red
                                  .withOpacity(0.3 * _likeAnimation.value),
                              blurRadius: 10 * _likeAnimation.value,
                              spreadRadius: 2 * _likeAnimation.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) {
        debugPrint("Error $error, $stackTrace");
        return const SizedBox.shrink();
      },
    );
  }
}

// Helper function for particle positioning
double cos(double angle) => math.cos(angle);
double sin(double angle) => math.sin(angle);
