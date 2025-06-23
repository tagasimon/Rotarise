// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';

import 'package:rotaract/news_feed/repos/likes_repo.dart';

final likesRepoProvider = Provider<LikesRepo>((ref) {
  return LikesRepo(ref.watch(likesCollectionRefProvider));
});

final isLikedProvider = StreamProvider.family<bool, String>((ref, postId) {
  final cUser = ref.watch(currentUserNotifierProvider);
  if (cUser == null) {
    return Stream.value(false);
  }
  return ref.watch(likesRepoProvider).isLiked(postId, cUser.id);
});
