import 'package:rotaract/projects/models/project_model.dart';

abstract class ProjectsInterface {
  /// Fetch a list of all projects
  Future<List<ProjectModel>> getAllProjects();

  /// Get a single project by its ID
  Future<ProjectModel?> getProjectById(String id);

  /// Create a new project
  Future<void> createProject(ProjectModel project);

  /// Update an existing project
  Future<void> updateProject(ProjectModel project);

  /// Delete a project by its ID
  Future<void> deleteProject(String id);

  /// Fetch projects by club ID
  Future<List<ProjectModel>?> getProjectsByClubId(String clubId);

  Future<int> getTotalProjectsCount();
}
