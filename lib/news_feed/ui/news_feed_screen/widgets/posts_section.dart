import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/discover/ui/events_screen/models/club_event_model.dart';
import 'package:rotaract/discover/ui/events_screen/providers/club_events_providers.dart';
import 'package:rotaract/discover/ui/events_screen/widgets/event_item_widget.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/repos/posts_repo.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_card.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/posts_error_widget.dart';

// Add this enum to differentiate between posts and events
enum FeedItemType { post, event }

// Add this class to represent a feed item
class FeedItem {
  final FeedItemType type;
  final dynamic data; // Will be either a Post or Event object
  final int originalIndex; // To maintain animation delay logic

  FeedItem({
    required this.type,
    required this.data,
    required this.originalIndex,
  });
}

class PostsSection extends ConsumerStatefulWidget {
  const PostsSection({super.key});

  @override
  ConsumerState<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends ConsumerState<PostsSection> {
  Future<void> _handleRefresh() async {
    // Refresh both providers
    ref.invalidate(fetchPostsProvider);
    ref.invalidate(allEventsProvider);

    // Optional: Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  List<FeedItem> _createMixedFeed(List posts, List events) {
    final List<FeedItem> mixedFeed = [];
    int eventIndex = 0;

    for (int i = 0; i < posts.length; i++) {
      // Add the post
      mixedFeed.add(FeedItem(
        type: FeedItemType.post,
        data: posts[i],
        originalIndex: i,
      ));

      // Every 10 posts (1-indexed), add an event if available
      if ((i + 1) % 5 == 0 && eventIndex < events.length) {
        mixedFeed.add(FeedItem(
          type: FeedItemType.event,
          data: events[eventIndex],
          originalIndex: i, // Use post index for consistency
        ));
        eventIndex++;
      }
    }

    return mixedFeed;
  }

  @override
  Widget build(BuildContext context) {
    final postsProv = ref.watch(fetchPostsProvider);
    final eventsProv = ref.watch(allEventsProvider);

    return postsProv.when(
      data: (posts) {
        if (posts.isEmpty) {
          return Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No Posts Yet",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Pull down to refresh",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return eventsProv.when(
          data: (events) {
            final mixedFeed = _createMixedFeed(posts, events);

            return Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: mixedFeed.length,
                  itemBuilder: (context, index) {
                    final feedItem = mixedFeed[index];

                    if (feedItem.type == FeedItemType.post) {
                      return PostCard(
                        post: feedItem.data,
                        animationDelay: feedItem.originalIndex * 100,
                      );
                    } else {
                      return EventItemWidget(event: feedItem.data);
                    }
                  },
                ),
              ),
            );
          },
          loading: () {
            return Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: posts[index],
                      animationDelay: index * 100,
                    );
                  },
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            debugPrint("Events error: $error, $stackTrace");
            // Show posts only if events fail to load
            return Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: posts[index],
                      animationDelay: index * 100,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        debugPrint("Posts error: $error, $stackTrace");
        return Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: const OnErrorRefreshPosts(),
          ),
        );
      },
    );
  }
}
