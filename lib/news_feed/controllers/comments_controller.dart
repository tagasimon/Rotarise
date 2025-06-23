import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/comment_model.dart';
import 'package:rotaract/news_feed/providers/comments_provider.dart';
import 'package:rotaract/news_feed/repos/comments_repo.dart';

final commentsControllerProvider =
    StateNotifierProvider<CommentsController, AsyncValue>(
  (ref) => CommentsController(ref.watch(commentsRepoProvider)),
);

class CommentsController extends StateNotifier<AsyncValue> {
  final CommentsRepo _repo;
  CommentsController(this._repo) : super(const AsyncData(null));

  // Add a new post
  Future<bool> addComment(CommentModel comment) async {
    state = const AsyncLoading();
    try {
      await _repo.addComment(comment);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}
