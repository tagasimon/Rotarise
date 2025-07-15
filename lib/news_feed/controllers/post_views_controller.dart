import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_view_model.dart';
import 'package:rotaract/news_feed/repos/post_views_repo.dart';

// postViewsControllerProvider

final postViewsControllerProvider =
    StateNotifierProvider<PostViewsController, AsyncValue>(
  (ref) => PostViewsController(ref.watch(postViewRepoProvider)),
);

class PostViewsController extends StateNotifier<AsyncValue> {
  final PostViewsRepo _repo;
  PostViewsController(this._repo) : super(AsyncValue.data(null));

  Future<void> addView(PostViewModel view) async {
    state = const AsyncLoading();
    try {
      await _repo.addView(view);
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
