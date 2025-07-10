import 'package:flutter/material.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/admin_tools/models/buddy_group_model.dart';

class BuddyGroupTableRow extends StatelessWidget {
  final BuddyGroupModel buddyGroup;
  final bool isEven;

  const BuddyGroupTableRow({
    super.key,
    required this.buddyGroup,
    required this.isEven,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surface.withAlphaa(0.5),
      ),
      child: Row(
        children: [
          // Group Name
          Expanded(
            flex: 3,
            child: Text(
              buddyGroup.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Description
          Expanded(
            flex: 5,
            child: Text(
              buddyGroup.description ?? 'No description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: buddyGroup.description != null
                        ? Colors.grey[700]
                        : Colors.grey[500],
                    fontStyle: buddyGroup.description != null
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editBuddyGroup(context, buddyGroup);
                  break;
                case 'delete':
                  _deleteBuddyGroup(context, buddyGroup);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.more_vert,
                size: 18,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editBuddyGroup(BuildContext context, BuddyGroupModel buddyGroup) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${buddyGroup.name} - Feature coming soon!')),
    );
  }

  void _deleteBuddyGroup(BuildContext context, BuddyGroupModel buddyGroup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Buddy Group'),
        content: Text('Are you sure you want to delete "${buddyGroup.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '${buddyGroup.name} deleted - Feature coming soon!')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
