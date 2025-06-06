import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/projects/models/project_model.dart';
import 'package:rotaract/projects/providers/projects_provider.dart';
import 'package:rotaract/projects/repo/projects_repo.dart';

// Projects controller provider
final projectsControllerProvider =
    StateNotifierProvider<ProjectsControllers, AsyncValue>(
  (ref) => ProjectsControllers(ref.watch(projectsRepoProvider)),
);

class ProjectsControllers extends StateNotifier<AsyncValue> {
  final ProjectsRepo _repo;
  ProjectsControllers(this._repo) : super(const AsyncData(null));

  // Add a new project
  Future<void> addProject(ProjectModel project) async {
    state = const AsyncLoading();
    try {
      await _repo.createProject(project);
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // Update an existing project
  Future<void> updateProject(ProjectModel project) async {
    state = const AsyncLoading();
    try {
      await _repo.updateProject(project);
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // Delete a project
  Future<void> deleteProject(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteProject(id);
      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
