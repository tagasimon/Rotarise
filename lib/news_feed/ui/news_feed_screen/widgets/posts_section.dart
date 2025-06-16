import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/providers/posts_providers.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_card.dart';

class PostsSection extends ConsumerStatefulWidget {
  const PostsSection({super.key});

  @override
  ConsumerState<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends ConsumerState<PostsSection> {
  List<PostModel> _allPosts = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DateTime? _lastDateTime; // Track last post's datetime
  static const int _pageSize = 20;

  Future<void> _handleRefresh() async {
    setState(() {
      _allPosts = [];
      _lastDateTime = null;
      _hasMore = true;
    });
    ref.invalidate(fetchPostsProvider);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _lastDateTime == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final morePosts =
          await ref.read(fetchMorePostsProvider(_lastDateTime!).future);

      setState(() {
        if (morePosts.isEmpty) {
          _hasMore = false;
        } else {
          _allPosts.addAll(morePosts);
          // Update last datetime for next pagination
          _lastDateTime = morePosts.last
              .timestamp; // Assuming your PostModel has a DateTime timestamp field
          _hasMore = morePosts.length == _pageSize;
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      debugPrint('Error loading more posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsProv = ref.watch(fetchPostsProvider);

    return postsProv.when(
      data: (initialPosts) {
        // Combine initial posts with loaded posts
        if (_allPosts.isEmpty && initialPosts.isNotEmpty) {
          _allPosts = List.from(initialPosts);
          // Set last datetime for pagination
          _lastDateTime =
              initialPosts.last.timestamp; // Assuming DateTime timestamp field
          _hasMore = initialPosts.length == _pageSize;
        }

        if (_allPosts.isEmpty) {
          return _buildEmptyState();
        }

        return Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _allPosts.length + (_hasMore ? 1 : 0),
              cacheExtent: 500,
              itemBuilder: (context, index) {
                // Load More button at the end
                if (index == _allPosts.length) {
                  return _buildLoadMoreButton();
                }

                return PostCard(
                  key: ValueKey(_allPosts[index].id),
                  post: _allPosts[index],
                  animationDelay: index < 3 ? index * 100 : 0,
                );
              },
            ),
          ),
        );
      },
      loading: () => const Expanded(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) {
        debugPrint("Posts error: $error");
        return _buildErrorState();
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: _isLoadingMore
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: ElevatedButton.icon(
                  onPressed: _loadMorePosts,
                  icon: const Icon(Icons.expand_more),
                  label: const Text('Load More Posts'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No Posts Yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text("Pull down to refresh",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text("Something went wrong",
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                  SizedBox(height: 8),
                  Text("Pull down to try again",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
