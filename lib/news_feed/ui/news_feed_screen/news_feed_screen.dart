import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/create_post_sliver_section.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/events_carousel_sliver_widget.dart'; // Back to original import
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/posts_section.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  NewsFeedScreenState createState() => NewsFeedScreenState();
}

class NewsFeedScreenState extends ConsumerState<NewsFeedScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(watchCurrentUserProvider, (_, next) {
      next.whenData(
        (value) {
          ref.read(currentUserNotifierProvider.notifier).updateUser(value);
        },
      );
    });

    return Scaffold(
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const ModernAppBarWidget(
            title: "Rotarise",
            subtitle: "Stay updated with club activities",
          ),
          const EventsCarouselSliverWidget(),
          const SliverToBoxAdapter(child: SizedBox(height: 5)),
          const CreatePostSliverSection(),
        ],
        body: Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: const Column(
                children: [PostsSection()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
