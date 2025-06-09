// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';

import 'package:rotaract/news_feed/domain/posts_interface.dart';
import 'package:rotaract/news_feed/models/post_model.dart';

final postsRepoProvider = Provider<PostsRepo>((ref) {
  return PostsRepo(ref.watch(postsCollectionRefProvider));
});

final fetchPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return ref.watch(postsRepoProvider).fetchPosts();
});

class PostsRepo implements PostsInterface {
  final CollectionReference _ref;
  PostsRepo(this._ref);

  @override
  Future<void> addPost(PostModel post) async {
    await _ref.add(post.toMap());
  }

  @override
  Future<void> deletePost(String postId) async {
    final query = await _ref.where("id", isEqualTo: postId).get();
    for (final doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<List<PostModel>> fetchPosts() async {
    final querySnapshot =
        await _ref.orderBy("timestamp", descending: true).limit(1000).get();
    return querySnapshot.docs
        .map((doc) => PostModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<PostModel>> fetchPostsByClubId(String clubId) async {
    final querySnapshot = await _ref.where('clubId', isEqualTo: clubId).get();
    return querySnapshot.docs
        .map((doc) => PostModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<PostModel?> getPostById(String postId) async {
    final docSnapshot = await _ref.doc(postId).get();
    if (docSnapshot.exists) {
      return PostModel.fromFirestore(docSnapshot);
    }
    return null;
  }

  @override
  Future<void> updatePost(PostModel post) async {
    await _ref.doc(post.id).update(post.toMap());
  }
}
