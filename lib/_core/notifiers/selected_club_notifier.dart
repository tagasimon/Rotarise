import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';

// current user notifier provider
final selectedClubNotifierProvider =
    StateNotifierProvider<SelectedClubNotifier, ClubModel?>(
        (ref) => SelectedClubNotifier());

class SelectedClubNotifier extends StateNotifier<ClubModel?> {
  SelectedClubNotifier() : super(null);

  // update selected club
  void updateClub(ClubModel? club) => state = club;

  // reset selected club
  void resetClub() => state = null;
}
