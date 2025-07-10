import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/admin_tools/models/club_role.dart';
import 'package:rotaract/admin_tools/providers/club_roles_repo_providers.dart';
import 'package:rotaract/admin_tools/ui/club_roles/widgets/role_detail_modal.dart';

class ClubRolesScreen extends ConsumerStatefulWidget {
  const ClubRolesScreen({super.key});

  @override
  ConsumerState<ClubRolesScreen> createState() => _ClubRolesScreenState();
}

class _ClubRolesScreenState extends ConsumerState<ClubRolesScreen> {
  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(rolesByClubIdProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Club Roles'),
        centerTitle: true,
      ),
      body: rolesAsync.when(
        data: (roles) => _buildRolesTable(roles ?? []),
        loading: () => Center(
            child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        )),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildRolesTable(List<ClubRole> roles) {
    if (roles.isEmpty) {
      return Center(
        child: Text(
          'No Roles Added Yet!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlphaa(0.05),
              offset: const Offset(0, 5),
              blurRadius: 15,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DataTable(
            columnSpacing: 20,
            dataRowMinHeight: 50,
            dataRowMaxHeight: 70,
            headingRowHeight: 60,
            headingRowColor: WidgetStateProperty.all(const Color(0xFFE2E8F0)),
            columns: const [
              DataColumn(
                label: Text(
                  'Title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Responsibilities',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
            rows: roles.map((role) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Icon(
                          _getRoleIcon(role.title),
                          color: const Color(0xFF3B82F6),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            role.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _showRoleDetails(context, role),
                  ),
                  DataCell(
                    Text(
                      role.description ?? 'No description',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontStyle: role.description == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _showRoleDetails(context, role),
                  ),
                  DataCell(
                    Text(
                      '${role.responsibilities.length} tasks',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                      ),
                    ),
                    onTap: () => _showRoleDetails(context, role),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withAlphaa(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref.refresh(rolesByClubIdProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('president') || titleLower.contains('leader')) {
      return Icons.stars;
    } else if (titleLower.contains('secretary')) {
      return Icons.edit_note;
    } else if (titleLower.contains('treasurer')) {
      return Icons.account_balance_wallet;
    } else if (titleLower.contains('member')) {
      return Icons.person;
    } else if (titleLower.contains('organizer') ||
        titleLower.contains('event')) {
      return Icons.event;
    } else if (titleLower.contains('marketing')) {
      return Icons.campaign;
    } else if (titleLower.contains('fundraising')) {
      return Icons.volunteer_activism;
    } else {
      return Icons.work;
    }
  }

  void _showRoleDetails(BuildContext context, ClubRole role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RoleDetailsModal(
        role: role,
        gradientColors: const [Colors.pink, Colors.pinkAccent],
      ),
    );
  }
}
