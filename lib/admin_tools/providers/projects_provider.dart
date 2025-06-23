// projects repo provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/providers/firebase_providers.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/repos/projects_repo.dart';

final projectsRepoProvider = Provider<ProjectsRepo>((ref) {
  return ProjectsRepo(ref.watch(projectsCollectionRefProvider));
});

// get all projects provider
final allProjectsProvider =
    FutureProvider.autoDispose<List<ProjectModel>>((ref) {
  return ref.watch(projectsRepoProvider).getAllProjects();
});

// get project by id provider
final projectByIdProvider =
    FutureProvider.family<ProjectModel?, String>((ref, id) {
  return ref.watch(projectsRepoProvider).getProjectById(id);
});

// get projects by club id provider
final projectsByClubIdProvider =
    FutureProvider.family<List<ProjectModel>?, String>((ref, clubId) {
  return ref.watch(projectsRepoProvider).getProjectsByClubId(clubId);
});

// get total projects count
final getTotalProjectsCountProvider = FutureProvider((ref) async {
  return ref.read(projectsRepoProvider).getTotalProjectsCount();
});
