import 'package:rotaract/admin_tools/models/project_model.dart';

abstract class ProjectsInterface {
  Future<void> createProject(ProjectModel project);
  Future<void> updateProject(ProjectModel project);
  Future<void> deleteProject(String id);
  Future<ProjectModel?> getProjectById(String id);
  Future<int> getTotalProjectsCount();
  Future<int> getTotalProjectsCountByClubId(String clubId);
  Future<List<ProjectModel>> getAllProjects();
  Future<List<ProjectModel>> getProjectsByClubId(String clubId);
}
