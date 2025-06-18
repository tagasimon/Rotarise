import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/projects/models/project_model.dart';
import 'package:rotaract/projects/repo/projects_repo.dart';

final projectsRepoProvider = Provider<ProjectsRepo>((ref) {
  return ProjectsRepo(ref.watch(projectsCollectionRefProvider));
});

final projectByIdProvider = FutureProvider.autoDispose
    .family<ProjectModel?, String>((ref, clubId) async {
  return ref.watch(projectsRepoProvider).getProjectById(clubId);
});

// getProjectsByClubId
final totalProjectsCountProvider = FutureProvider<int>((ref) async {
  return await ref.watch(projectsRepoProvider).getTotalProjectsCount();
});

// final totalProjectsByClubIdProvider =
//     FutureProvider.family.autoDispose<int, String>((ref, clubId) async {
//   return await ref
//       .watch(projectsRepoProvider)
//       .getTotalProjectsCountByClubId(clubId);
// });

final projectsByClubIdProvider = FutureProvider.autoDispose
    .family<List<ProjectModel>?, String>((ref, clubId) async {
  return await ref.watch(projectsRepoProvider).getProjectsByClubId(clubId);
});
