import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/news_feed/domain/post_views_interface.dart';
import 'package:rotaract/news_feed/models/post_view_model.dart';

// postviewrepo Provider

final postViewRepoProvider = Provider<PostViewsRepo>((ref) {
  return PostViewsRepo(ref.watch(postViewsCollectionRefProvider));
});

class PostViewsRepo implements PostViewsInterface {
  final CollectionReference _ref;
  PostViewsRepo(this._ref);

  @override
  Future<void> addView(PostViewModel view) async {
    // check if the view already exists then if it does not exist then add it

    final querySnapshot = await _ref
        .where('postId', isEqualTo: view.postId)
        .where('viewerId', isEqualTo: view.viewerId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      await _ref.add(view.toMap());
    }
  }
}
