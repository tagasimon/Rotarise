import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverTabIndexProvider =
    StateNotifierProvider<DiscoverTabIndexNotifier, int>(
  (ref) => DiscoverTabIndexNotifier(),
);

class DiscoverTabIndexNotifier extends StateNotifier<int> {
  DiscoverTabIndexNotifier() : super(0);

  void setTabIndex(int index) {
    state = index;
  }
}
