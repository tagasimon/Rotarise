// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rotaract/news_feed/domain/posts_interface.dart';
import 'package:rotaract/news_feed/models/post_model.dart';

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
    try {
      final querySnapshot = await _ref
          .orderBy("timestamp", descending: true)
          .limit(20) // Initial page size
          .get();

      final posts = querySnapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();

      return posts;
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      rethrow;
    }
  }

// New function for loading more posts using cursor pagination
  @override
  Future<List<PostModel>> fetchMorePosts(DateTime lastDateTime) async {
    try {
      final querySnapshot = await _ref
          .orderBy("timestamp", descending: true)
          .startAfter([lastDateTime]) // Start after the last post's datetime
          .limit(20) // Page size
          .get();

      final posts = querySnapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();

      return posts;
    } catch (e) {
      debugPrint('Error fetching more posts: $e');
      rethrow;
    }
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

  @override
  Stream<int?> watchPostCommentsCount(String postId) {
    return FirebaseFirestore.instance
        .collection('COMMENTS')
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Stream<int?> watchPostLikesCount(String postId) {
    return FirebaseFirestore.instance
        .collection('LIKES')
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
