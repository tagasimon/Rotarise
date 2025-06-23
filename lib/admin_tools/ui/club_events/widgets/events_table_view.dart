import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rotaract/discover/ui/events_tab_screen/models/club_event_model.dart';

class EventsTableView extends StatefulWidget {
  final List<ClubEventModel> events;
  final Function(String, ClubEventModel) onEventAction;

  const EventsTableView({
    super.key,
    required this.events,
    required this.onEventAction,
  });

  @override
  State<EventsTableView> createState() => _EventsTableViewState();
}

class _EventsTableViewState extends State<EventsTableView> {
  final String _searchQuery = '';
  final String _sortBy = 'date';
  final bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ClubEventModel> get filteredEvents {
    var filtered = widget.events.where((event) {
      return event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort events
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'date':
          // comparison = a.startDate!.compareTo(b.startDate!);
          break;
        case 'location':
          comparison = a.location.compareTo(b.location);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM dd, yyyy');
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: _buildModernTable(df, theme)),
        ],
      ),
    );
  }

  Widget _buildModernTable(DateFormat df, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: constraints.maxWidth > 900 ? constraints.maxWidth : 900,
            child: Column(
              children: [
                _buildTableHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventRow(filteredEvents[index], index, df);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildTableHeaderCell('Event', flex: 3, icon: Icons.event),
          _buildTableHeaderCell('Start Date', flex: 2, icon: Icons.play_arrow),
          _buildTableHeaderCell('End Date', flex: 2, icon: Icons.stop),
          _buildTableHeaderCell('Location', flex: 2, icon: Icons.place),
          _buildTableHeaderCell('Status', flex: 1, icon: Icons.info),
          _buildTableHeaderCell('Actions', flex: 1, icon: Icons.settings),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String title, {int flex = 1, IconData? icon}) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey.shade800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventRow(ClubEventModel event, int index, DateFormat df) {
    const status = "Active"; // Replace with your status logic
    const statusColor = Colors.green;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade100,
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => widget.onEventAction('view', event),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        _buildEventCell(event, df),
                        _buildDateCell(df.format(event.startDate as DateTime),
                            flex: 2),
                        _buildDateCell(df.format(event.endDate as DateTime),
                            flex: 2),
                        _buildLocationCell(event.location, flex: 2),
                        _buildStatusCell(status, statusColor, flex: 1),
                        _buildActionsCell(event, flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventCell(ClubEventModel event, DateFormat df) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Hero(
            tag: 'event_${event.title}',
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade400,
                    Colors.purple.shade400,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: event.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.event,
                                color: Colors.white, size: 24),
                      ),
                    )
                  : const Icon(Icons.event, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to view details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCell(String date, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 13,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCell(String location, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Icon(Icons.place, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCell(String status, Color statusColor, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCell(ClubEventModel event, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 18),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.visibility,
                      size: 16, color: Colors.blue.shade600),
                ),
                const SizedBox(width: 12),
                const Text('View Details'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:
                      Icon(Icons.edit, size: 16, color: Colors.orange.shade600),
                ),
                const SizedBox(width: 12),
                const Text('Edit Event'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:
                      Icon(Icons.delete, size: 16, color: Colors.red.shade600),
                ),
                const SizedBox(width: 12),
                const Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        onSelected: (value) => widget.onEventAction(value.toString(), event),
      ),
    );
  }
}
