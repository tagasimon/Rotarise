import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rotaract/_constants/widget_helpers.dart';
import 'package:rotaract/_core/notifiers/current_user_notifier.dart';
import 'package:rotaract/admin_tools/models/club_model.dart';
import 'package:rotaract/discover/controllers/visits_controller.dart';
import 'package:rotaract/discover/models/visit_model.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/club_action_widget.dart';
import 'package:rotaract/discover/ui/club_home_screen/widgets/visit_club_widget.dart';
import 'package:uuid/uuid.dart';

class QuickActionsWidget extends ConsumerWidget {
  final ClubModel club;
  const QuickActionsWidget({super.key, required this.club});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
                child: ClubActionWidget(
              icon: FontAwesomeIcons.doorOpen,
              label: 'Meetup',
              color: Theme.of(context).primaryColor,
              onTap: () async {
                final Map<String, dynamic>? result =
                    await showModalBottomSheet<Map<String, dynamic>>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const VisitClubWidget(),
                );
                if (result == null) return;
                final cUser = ref.read(currentUserNotifierProvider);
                if (cUser == null) return;
                final visit = VisitModel(
                  id: Uuid().v4(),
                  userId: cUser.id,
                  clubId: cUser.clubId ?? "",
                  visitDesc: result['desc'] ?? "",
                  visitedClubId: club.id,
                  visitedClubName: club.name,
                  visitDate: DateTime.now(),
                  imageUrl: result['downloadUrl'] ?? "",
                );
                final res = await ref
                    .read(visitsControllerProvider.notifier)
                    .addVisit(visit);
                if (res) {
                  Fluttertoast.showToast(msg: "Meetup Added!!");
                }
              },
            )),
            if (club.phone != null && club.phone!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.phoneVolume,
                  label: 'Call',
                  color: Colors.blue.shade400,
                  onTap: () => WidgetHelpers.launchPhone(club.phone!),
                ),
              ),
            if (club.whatsapp != null && club.whatsapp!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  color: Colors.green.shade600,
                  onTap: () => WidgetHelpers.launchWhatsApp(club.whatsapp!),
                ),
              ),
            if (club.location != null && club.location!.isNotEmpty)
              Expanded(
                child: ClubActionWidget(
                  icon: FontAwesomeIcons.diamondTurnRight,
                  label: 'Directions',
                  color: Colors.purple.shade600,
                  onTap: () => WidgetHelpers.launchDirections(club.location!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
