import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/discover/ui/search_clubs_screen/widgets/club_card_widget.dart';

class ClubsSearchDeligate extends SearchDelegate {
  final List<ClubModel> searchTerms;
  ClubsSearchDeligate({required this.searchTerms})
      : super(searchFieldLabel: "Club Name");
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = "", icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ClubModel> matchQuery = [];
    for (var club in searchTerms) {
      if (club.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(club);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (_, i) {
        return ClubCardWidget(club: matchQuery[i]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ClubModel> matchQuery = [];
    for (var club in searchTerms) {
      if (club.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(club);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (_, i) {
        return ClubCardWidget(club: matchQuery[i]);
      },
    );
  }
}
