import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/extensions.dart';

class EventsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? clubName;
  final TabController tabController;
  final Function(String) onSearchChanged;

  const EventsAppBar({
    super.key,
    this.clubName,
    required this.tabController,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      // leading: IconButton(
      //     onPressed: () => context.pop(false),
      //     icon: const Icon(
      //       Icons.close,
      //       color: Colors.red,
      //     )),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   clubName ?? 'Club Events',
          //   style: const TextStyle(
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Text(
          //   'Manage and view all events',
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: Colors.grey[600],
          //     fontWeight: FontWeight.normal,
          //   ),
          // ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Increased from 10 to 100
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(1), // Increased padding from 1 to 16
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
                      onChanged: onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        prefixIcon: const Icon(Icons.search),
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
              const SizedBox(
                  height: 16), // Added spacing between search and tabs
              // Tabs
              TabBar(
                controller: tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.view_list),
                    text: 'List View',
                  ),
                  Tab(
                    icon: Icon(Icons.table_chart),
                    text: 'Table View',
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
