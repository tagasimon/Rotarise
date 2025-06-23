import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/news_feed/models/comment_model.dart';
import 'package:rotaract/news_feed/repos/comments_repo.dart';

final commentsRepoProvider = Provider<CommentsRepo>((ref) {
  return CommentsRepo(ref.watch(commentsCollectionRefProvider));
});

final postCommentsProvider = StreamProvider.family
    .autoDispose<List<CommentModel>, String>((ref, postId) {
  return ref.watch(commentsRepoProvider).fetchCommentByPostId(postId);
});
