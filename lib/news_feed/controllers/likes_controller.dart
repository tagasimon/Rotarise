import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/like_model.dart';
import 'package:rotaract/news_feed/repos/likes_repo.dart';

final likesControllerProvider =
    StateNotifierProvider<LikesController, AsyncValue>(
  (ref) => LikesController(ref.watch(likesRepoProvider)),
);

class LikesController extends StateNotifier<AsyncValue> {
  final LikesRepo _repo;
  LikesController(this._repo) : super(const AsyncData(null));

  // Add a new post
  Future<bool> addLike(LikeModel like) async {
    state = const AsyncLoading();
    try {
      await _repo.addLike(like);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  // Add a new post
  Future<bool> removeLike(String postId, String userId) async {
    state = const AsyncLoading();
    try {
      await _repo.removeLike(postId, userId);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}
