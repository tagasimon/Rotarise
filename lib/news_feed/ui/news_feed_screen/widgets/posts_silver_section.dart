import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/providers/posts_providers.dart';
import 'package:rotaract/news_feed/ui/news_feed_screen/widgets/post_card.dart';

class PostsSliverSection extends ConsumerStatefulWidget {
  const PostsSliverSection({super.key});

  @override
  ConsumerState<PostsSliverSection> createState() => _PostsSliverSectionState();
}

class _PostsSliverSectionState extends ConsumerState<PostsSliverSection> {
  List<PostModel> _allPosts = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  DateTime? _lastDateTime;
  static const int _pageSize = 20;

  Future<void> _handleRefresh() async {
    if (!mounted) return;

    debugPrint('📱 PostsSliverSection: Handling refresh');

    setState(() {
      _allPosts = [];
      _lastDateTime = null;
      _hasMore = true;
      _isLoadingMore = false;
    });

    ref.invalidate(fetchPostsProvider);
    debugPrint('🔄 PostsSliverSection: Provider invalidated');
  }

  // Public method to handle refresh from parent
  Future<void> handleRefresh() async {
    return _handleRefresh();
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _lastDateTime == null || !mounted) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final morePosts =
          await ref.read(fetchMorePostsProvider(_lastDateTime!).future);

      if (!mounted) return;

      setState(() {
        if (morePosts.isEmpty) {
          _hasMore = false;
        } else {
          _allPosts = [..._allPosts, ...morePosts];
          _lastDateTime = morePosts.last.timestamp;
          _hasMore = morePosts.length == _pageSize;
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;

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
        // Initialize or update posts when data changes
        if (_allPosts.isEmpty && initialPosts.isNotEmpty) {
          // First time loading
          _allPosts = List.from(initialPosts);
          _lastDateTime = initialPosts.last.timestamp;
          _hasMore = initialPosts.length == _pageSize;
        } else if (initialPosts.isNotEmpty &&
            (_allPosts.isEmpty ||
                (_allPosts.isNotEmpty &&
                    initialPosts.first.id != _allPosts.first.id))) {
          // Refresh case - new data arrived
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _allPosts = List.from(initialPosts);
                _lastDateTime = initialPosts.last.timestamp;
                _hasMore = initialPosts.length == _pageSize;
              });
            }
          });
        }

        if (_allPosts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildPostsSliver();
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) {
        debugPrint("Posts error: $error");
        return _buildErrorState();
      },
    );
  }

  Widget _buildLoadingState() {
    return const SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error loading posts'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleRefresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No posts yet'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleRefresh,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsSliver() {
    return SliverList.separated(
      itemCount: _allPosts.length + (_hasMore || _isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Load more indicator
        if (index == _allPosts.length) {
          return _buildLoadMoreIndicator();
        }

        final post = _allPosts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RepaintBoundary(
            child: PostCard(
              key: ValueKey(post.id),
              post: post,
              animationDelay: 1, // Optional: Add animation delay if needed
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }

  Widget _buildLoadMoreIndicator() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No more posts',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: _loadMorePosts,
          child: const Text('Load More'),
        ),
      ),
    );
  }
}
