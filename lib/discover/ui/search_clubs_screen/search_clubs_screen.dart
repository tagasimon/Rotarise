import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/shared_widgets/error_screen_widget.dart';
import 'package:rotaract/_core/shared_widgets/loading_screen_widget.dart';
import 'package:rotaract/admin_tools/providers/club_repo_providers.dart';
import 'package:rotaract/discover/ui/search_clubs_screen/widgets/club_card_widget.dart';

class SearchClubsScreen extends ConsumerStatefulWidget {
  static const String route = "/search-clubs";

  const SearchClubsScreen({super.key});

  @override
  ConsumerState<SearchClubsScreen> createState() => _SearchClubsScreenState();
}

class _SearchClubsScreenState extends ConsumerState<SearchClubsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredClubs = [];
  List<dynamic> _allClubs = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredClubs = _allClubs;
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredClubs = _allClubs.where((club) {
          final name = club?.name?.toString().toLowerCase() ?? '';
          final location = club?.location?.toString().toLowerCase() ?? '';
          return name.contains(query) || location.contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredClubs = _allClubs;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubsProv = ref.watch(getAllVerifiedClubsProvider);

    return clubsProv.when(
      data: (clubs) {
        // Update clubs list when data changes
        if (_allClubs != clubs) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _allClubs = clubs;
                if (!_isSearching) {
                  _filteredClubs = clubs;
                }
              });
            }
          });
        }

        return Scaffold(
          // backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text('Discover Clubs'),
            backgroundColor: Colors.pink,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search clubs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),

              // Results Count
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${_filteredClubs.length} club${_filteredClubs.length == 1 ? '' : 's'} ${_isSearching ? 'found' : 'available'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Clubs List
              Expanded(
                child: _filteredClubs.isEmpty && _isSearching
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredClubs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClubCardWidget(club: _filteredClubs[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) => const ErrorScreenWidget(
        error: "Failed to load clubs",
      ),
      loading: () => const LoadingScreenWidget(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No clubs found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search term',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearSearch,
            child: const Text('Show All Clubs'),
          ),
        ],
      ),
    );
  }
}
