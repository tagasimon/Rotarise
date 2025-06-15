import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/news_feed/models/post_model.dart';

// current user notifier provider
final selectedPostNotifierProvider =
    StateNotifierProvider<SelectedPostNotifier, PostModel?>(
        (ref) => SelectedPostNotifier());

class SelectedPostNotifier extends StateNotifier<PostModel?> {
  SelectedPostNotifier() : super(null);

  // update selected club
  void updatePost(PostModel? post) {
    state = post;
  }

  // reset selected club
  void resetPost() {
    state = null;
  }
}
