// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_model.dart';

import 'package:rotaract/news_feed/repos/posts_repo.dart';

// club controller provider
final postsControllerProvider =
    StateNotifierProvider<PostsController, AsyncValue>(
  (ref) => PostsController(ref.watch(postsRepoProvider)),
);

class PostsController extends StateNotifier<AsyncValue> {
  final PostsRepo _repo;
  PostsController(this._repo) : super(const AsyncData(null));

  // Add a new post
  Future<bool> addPost(PostModel post) async {
    state = const AsyncLoading();
    try {
      await _repo.addPost(post);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  // Update an existing project
  Future<bool> updatePost(PostModel post) async {
    state = const AsyncLoading();
    try {
      await _repo.updatePost(post);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  // Delete a project
  Future<bool> deletePost(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.deletePost(id);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}
