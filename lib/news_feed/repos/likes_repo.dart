// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rotaract/news_feed/domain/likes_interface.dart';
import 'package:rotaract/news_feed/models/like_model.dart';

class LikesRepo implements LikesInterface {
  final CollectionReference _ref;
  LikesRepo(this._ref);
  @override
  Future<void> addLike(LikeModel like) async {
    await _ref.doc("${like.postId}_${like.userId}").set(like.toMap());
  }

  @override
  Future<List<LikeModel>> fetchLikesByPostId(String postId) {
    // TODO Might not be needed
    return _ref.where('postId', isEqualTo: postId).get().then((snapshot) =>
        snapshot.docs
            .map((doc) => LikeModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<void> removeLike(String postId, String userId) {
    return _ref.doc("${postId}_$userId").delete();
  }

  @override
  Stream<bool> isLiked(String postId, String userId) {
    return _ref.doc('${postId}_$userId').snapshots().map((snapshot) {
      return snapshot.exists;
    });
  }
}
