import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/_core/extensions/extensions.dart';
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

class _SearchClubsScreenState extends ConsumerState<SearchClubsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<dynamic> _filteredClubs = [];
  List<dynamic> _allClubs = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    // Use mounted check to prevent setState on disposed widget
    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredClubs =
            List.from(_allClubs); // Create new list to avoid reference issues
        _isSearching = false;
      } else {
        _isSearching = true;
        _filteredClubs = _allClubs.where((club) {
          try {
            // Safe null checks with proper null handling
            final clubName = club?.name?.toString().toLowerCase() ?? '';
            final clubLocation = club?.location?.toString().toLowerCase() ?? '';
            final clubDescription =
                club?.description?.toString().toLowerCase() ?? '';

            return clubName.contains(query) ||
                clubLocation.contains(query) ||
                clubDescription.contains(query);
          } catch (e) {
            // Handle any errors in filtering gracefully
            print('Error filtering club: $e');
            return false;
          }
        }).toList();
      }
    });

    // Only animate if controller is not disposed
    if (_animationController.isAnimating || !_animationController.isCompleted) {
      _animationController.reset();
    }
    _animationController.forward();
  }

  void _clearSearch() {
    if (!mounted) return;

    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _filteredClubs = List.from(_allClubs);
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubsProv = ref.watch(getAllVerifiedClubsProvider);

    return clubsProv.when(
      data: (clubs) {
        if (_allClubs.length != clubs.length ||
            !_listsEqual(_allClubs, clubs)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _allClubs = List.from(clubs);
                if (!_isSearching) {
                  _filteredClubs = List.from(clubs);
                }
              });
              if (_animationController.isAnimating ||
                  !_animationController.isCompleted) {
                _animationController.reset();
              }
              _animationController.forward();
            }
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with Search
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                floating: true,
                pinned: true,
                snap: false,
                expandedHeight: 120,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black87, size: 20),
                    onPressed: () {
                      if (context.mounted) {
                        context.pop(false);
                      }
                    },
                  ),
                ),
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text(
                    'Discover Clubs',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  titlePadding: EdgeInsets.only(left: 72, bottom: 16),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        // Remove autofocus for web compatibility
                        autofocus: false,
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search clubs by name',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: Colors.grey[500],
                              size: 18,
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Results Header
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.users,
                                      color: Theme.of(context).primaryColor,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_filteredClubs.length} club${_filteredClubs.length == 1 ? '' : 's'}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          _isSearching
                                              ? 'found matching your search'
                                              : 'available to join',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_isSearching)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'FILTERED',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      if (_filteredClubs.isEmpty && _isSearching)
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.magnifyingGlass,
                                        color: Colors.grey[400],
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No clubs found',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your search terms or browse all available clubs.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: _clearSearch,
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Show All Clubs',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                      // Clubs Grid
                      if (_filteredClubs.isNotEmpty)
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _filteredClubs.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 5),
                                itemBuilder: (context, index) {
                                  // Add safety check for list bounds
                                  if (index >= _filteredClubs.length) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClubCardWidget(
                                        club: _filteredClubs[index]),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) {
        return const ErrorScreenWidget(
          error: "Failed to load club information",
        );
      },
      loading: () => const LoadingScreenWidget(),
    );
  }

  // Helper method to compare lists safely
  bool _listsEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
