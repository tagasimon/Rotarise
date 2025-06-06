import 'package:flutter_riverpod/flutter_riverpod.dart';

final clubTabIndexProvider = StateNotifierProvider<ClubTabIndexNotifier, int>(
  (ref) => ClubTabIndexNotifier(),
);

class ClubTabIndexNotifier extends StateNotifier<int> {
  ClubTabIndexNotifier() : super(0);

  void setTabIndex(int index) {
    state = index;
  }
}
