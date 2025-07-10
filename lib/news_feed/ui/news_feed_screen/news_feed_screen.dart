import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/create_post_sliver_section.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/events_carousel_sliver_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/posts_silver_section.dart';

class NewsFeedScreen extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  const NewsFeedScreen({super.key, this.scrollController});

  @override
  NewsFeedScreenState createState() => NewsFeedScreenState();
}

class NewsFeedScreenState extends ConsumerState<NewsFeedScreen>
    with AutomaticKeepAliveClientMixin {
  // Keep alive to maintain scroll position
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _listenToUserChanges();

    return Scaffold(
      body: CustomScrollView(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // App bar
          const ModernAppBarWidget(
            title: "Rotarise",
            subtitle: "Stay updated with club activities",
          ),

          // Events carousel
          const EventsCarouselSliverWidget(),

          // Create post section - REMOVED the extra SliverToBoxAdapter wrapper
          const CreatePostSliverSection(),

          // Posts section - convert to proper sliver
          const PostsSliverSection(),
        ],
      ),
    );
  }

  void _listenToUserChanges() {
    ref.listen<AsyncValue>(watchCurrentUserProvider, (_, next) {
      next.whenData((value) {
        ref.read(currentUserNotifierProvider.notifier).updateUser(value);
      });
    });
  }
}
