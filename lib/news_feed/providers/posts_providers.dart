// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';

import 'package:rotaract/news_feed/models/post_model.dart';
import 'package:rotaract/news_feed/repos/posts_repo.dart';

final postsRepoProvider = Provider<PostsRepo>((ref) {
  return PostsRepo(ref.watch(postsCollectionRefProvider));
});

// Optional: Simple caching with Timer
final fetchPostsProvider =
    FutureProvider.autoDispose<List<PostModel>>((ref) async {
  return ref.watch(postsRepoProvider).fetchPosts();
});

final fetchMorePostsProvider = FutureProvider.autoDispose
    .family<List<PostModel>, DateTime>((ref, dateTime) async {
  return ref.watch(postsRepoProvider).fetchMorePosts(dateTime);
});

final postCommentsCountProvider = StreamProvider.autoDispose<int?>((ref) {
  final post = ref.watch(selectedPostNotifierProvider);
  if (post == null) {
    return Stream.value(0);
  }
  return ref.watch(postsRepoProvider).watchPostCommentsCount(post.id);
});

final postLikesCountProvider = StreamProvider.autoDispose<int?>((ref) {
  final post = ref.watch(selectedPostNotifierProvider);
  if (post == null) {
    return Stream.value(0);
  }
  return ref.watch(postsRepoProvider).watchPostLikesCount(post.id);
});
