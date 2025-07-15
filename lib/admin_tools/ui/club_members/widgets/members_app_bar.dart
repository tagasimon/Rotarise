import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/nav_ext.dart';

class MembersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? clubName;
  final Function(String) onSearchChanged;
  final VoidCallback? onRefresh;
  final TextEditingController? searchController;

  const MembersAppBar({
    super.key,
    this.clubName,
    required this.onSearchChanged,
    this.onRefresh,
    this.searchController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      toolbarHeight: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
          child: Column(
            children: [
              // Search Bar
              Row(
                children: [
                  IconButton(
                      onPressed: () => context.pop(false),
                      icon: const Icon(Icons.arrow_back_ios)),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search members...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: onRefresh != null
                            ? IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: onRefresh,
                                tooltip: 'Refresh',
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
