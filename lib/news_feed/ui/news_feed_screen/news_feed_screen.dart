import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/auth_provider.dart';
import 'package:rotaract/_core/shared_widgets/modern_app_bar_widget.dart';
import 'package:rotaract/news_feed/providers/posts_providers.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/create_post_sliver_section.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/events_carousel_sliver_widget.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/posts_silver_section.dart';
import 'package:rotaract/notifications/notifications_screen.dart';

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

  Future<void> _handleRefresh() async {
    debugPrint('🔄 Pull-to-refresh triggered');

    // Invalidate the posts provider to refresh data
    ref.invalidate(fetchPostsProvider);

    // Wait a bit to ensure the provider has time to refresh
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('✅ Pull-to-refresh completed');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _listenToUserChanges();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // App bar
            ModernAppBarWidget(
              title: "Rotarise",
              subtitle: "Stay updated with club activities",
              actions: [
                IconButton(
                    onPressed: () => context.push(NotificationsScreen()),
                    icon: Icon(Icons.notifications)),
                SizedBox(width: 5),
              ],
            ),

            // Events carousel
            const EventsCarouselSliverWidget(),

            // Create post section - REMOVED the extra SliverToBoxAdapter wrapper
            const CreatePostSliverSection(),

            // Posts section - convert to proper sliver
            const PostsSliverSection(),

            // Add minimum space to ensure scrollability for RefreshIndicator
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ),
          ],
        ),
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
