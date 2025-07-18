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
  DateTime? _lastDateTime;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleRefresh() async {
    if (!mounted) return;

    setState(() {
      _allPosts = [];
      _lastDateTime = null;
      _hasMore = true;
      _isLoadingMore = false;
    });

    ref.invalidate(fetchPostsProvider);
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
        // Initialize posts only once
        if (_allPosts.isEmpty && initialPosts.isNotEmpty) {
          _allPosts = List.from(initialPosts);
          _lastDateTime = initialPosts.last.timestamp;
          _hasMore = initialPosts.length == _pageSize;
        }

        if (_allPosts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildPostsList();
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) {
        debugPrint("Posts error: $error");
        return _buildErrorState();
      },
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
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
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
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
    );
  }

  Widget _buildPostsList() {
    return Column(
      children: [
        // Posts list
        ListView.separated(
          shrinkWrap:
              true, // Important: Let the ListView take only needed space
          physics:
              const NeverScrollableScrollPhysics(), // Disable internal scrolling
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: _allPosts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = _allPosts[index];
            return RepaintBoundary(
              child: PostCard(
                key: ValueKey(post.id),
                post: post,
                animationDelay: 1,
              ),
            );
          },
        ),

        // Load more section
        if (_hasMore || _isLoadingMore) ...[
          const SizedBox(height: 16),
          _buildLoadMoreSection(),
        ],

        // Bottom spacing
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildLoadMoreSection() {
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
