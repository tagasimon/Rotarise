import 'package:rotaract/news_feed/models/comment_model.dart';

abstract class CommentsInterface {
  /// Adds a new post to the newsfeed.
  Future<void> addComment(CommentModel comment);

  /// Updates an existing post.
  Future<void> removeComment(String commentId);

  // Get Posts by clubId
  Future<List<CommentModel>> fetchCommentByPostId(String postId);
}
