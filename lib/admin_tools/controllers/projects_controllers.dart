import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/providers/projects_provider.dart';
import 'package:rotaract/admin_tools/repos/projects_repo.dart';

// Projects controller provider
final projectsControllerProvider =
    StateNotifierProvider<ProjectsControllers, AsyncValue>(
  (ref) => ProjectsControllers(ref.watch(projectsRepoProvider)),
);

class ProjectsControllers extends StateNotifier<AsyncValue> {
  final ProjectsRepo _repo;
  ProjectsControllers(this._repo) : super(const AsyncData(null));

  // Add a new project
  Future<bool> addProject(ProjectModel project) async {
    state = const AsyncLoading();
    try {
      await _repo.createProject(project);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  // Update an existing project
  Future<bool> updateProject(ProjectModel project) async {
    state = const AsyncLoading();
    try {
      await _repo.updateProject(project);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }

  // Delete a project
  Future<bool> deleteProject(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteProject(id);
      state = const AsyncData(null);
      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}
