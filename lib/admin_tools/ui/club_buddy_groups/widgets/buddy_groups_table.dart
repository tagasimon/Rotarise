import 'package:flutter/material.dart';
import 'package:rotaract/admin_tools/models/buddy_group_model.dart';
import 'package:rotaract/admin_tools/ui/club_buddy_groups/widgets/buddy_group_table_view.dart';

class BuddyGroupsTable extends StatelessWidget {
  final List<BuddyGroupModel> buddyGroups;

  const BuddyGroupsTable({
    super.key,
    required this.buddyGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Group Name',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 48), // Space for actions
                ],
              ),
            ),

            // Table Body
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buddyGroups.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              itemBuilder: (context, index) {
                final buddyGroup = buddyGroups[index];
                return BuddyGroupTableRow(
                  buddyGroup: buddyGroup,
                  isEven: index.isEven,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
