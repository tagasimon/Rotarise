import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/selected_post_notifier.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/news_feed/models/comment_model.dart';
import 'package:rotaract/news_feed/repos/comments_repo.dart';

final commentsRepoProvider = Provider<CommentsRepo>((ref) {
  return CommentsRepo(ref.watch(commentsCollectionRefProvider));
});

final postCommentsProvider =
    StreamProvider.autoDispose<List<CommentModel>>((ref) {
  final post = ref.read(selectedPostNotifierProvider);
  if (post == null) {
    return const Stream.empty();
  }
  return ref.watch(commentsRepoProvider).fetchCommentByPostId(post.id);
});
