import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/news_feed/domain/comments_interface.dart';
import 'package:rotaract/news_feed/models/comment_model.dart';

final commentsRepoProvider = Provider<CommentsRepo>((ref) {
  return CommentsRepo(ref.watch(commentsCollectionRefProvider));
});

final postCommentsProvider = StreamProvider.family
    .autoDispose<List<CommentModel>, String>((ref, postId) {
  return ref.watch(commentsRepoProvider).fetchCommentByPostId(postId);
});

class CommentsRepo implements CommentsInterface {
  final CollectionReference _ref;
  CommentsRepo(this._ref);

  @override
  Future<void> addComment(CommentModel comment) async {
    await _ref.add(comment.toMap());
  }

  @override
  Stream<List<CommentModel>> fetchCommentByPostId(String postId) {
    return _ref.where('postId', isEqualTo: postId).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => CommentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<void> removeComment(String commentId) {
    // TODO: implement removeComment
    throw UnimplementedError();
  }
}
