import 'package:rotaract/news_feed/models/post_view_model.dart';

abstract class PostViewsInterface {
  /// Adds a new view to the post.
  Future<void> addView(PostViewModel view);
}
