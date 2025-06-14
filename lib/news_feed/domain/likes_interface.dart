import 'package:rotaract/news_feed/models/like_model.dart';

abstract class LikesInterface {
  /// Adds a new post to the newsfeed.
  Future<void> addLike(LikeModel like);

  Stream<bool> isLiked(String postId, String userId);

  /// Updates an existing post.
  Future<void> removeLike(String postId, String userId);

  // Get Posts by clubId
  Future<List<LikeModel>> fetchLikesByPostId(String postId);
}
