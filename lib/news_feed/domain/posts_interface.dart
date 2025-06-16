import 'package:rotaract/news_feed/models/post_model.dart';

abstract class PostsInterface {
  /// Fetches all posts for the newsfeed.
  Future<List<PostModel>> fetchPosts();

  Future<List<PostModel>> fetchMorePosts(DateTime lastTimestamp);

  /// Adds a new post to the newsfeed.
  Future<void> addPost(PostModel post);

  /// Updates an existing post.
  Future<void> updatePost(PostModel post);

  /// Deletes a post by its ID.
  Future<void> deletePost(String postId);

  /// Gets a single post by its ID.
  Future<PostModel?> getPostById(String postId);

  // Get Posts by clubId
  Future<List<PostModel>> fetchPostsByClubId(String clubId);

  Stream<int?> watchPostCommentsCount(String postId);

  Stream<int?> watchPostLikesCount(String postId);
}
