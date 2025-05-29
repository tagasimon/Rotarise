import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabIndexProvider = StateNotifierProvider<TabIndexNotifier, int>(
  (ref) => TabIndexNotifier(),
);

class TabIndexNotifier extends StateNotifier<int> {
  TabIndexNotifier() : super(0);

  void setTabIndex(int index) {
    state = index;
  }
}
