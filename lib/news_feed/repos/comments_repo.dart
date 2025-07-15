import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/news_feed/domain/comments_interface.dart';
import 'package:rotaract/news_feed/models/comment_model.dart';

class CommentsRepo implements CommentsInterface {
  final CollectionReference _ref;
  CommentsRepo(this._ref);

  @override
  Future<void> addComment(CommentModel comment) async {
    await _ref.add(comment.toMap());
  }

  @override
  Stream<List<CommentModel>> fetchCommentByPostId(String postId) {
    return _ref
        .where('postId', isEqualTo: postId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
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
