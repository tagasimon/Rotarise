import 'package:rotaract/projects/models/project_model.dart';

abstract class ProjectsInterface {
  Future<void> createProject(ProjectModel project);
  Future<void> updateProject(ProjectModel project);
  Future<void> deleteProject(ProjectModel project);
  Future<ProjectModel?> getProjectById(String id);
  Future<int> getTotalProjectsCount();
  Future<int> getTotalProjectsCountByClubId(String clubId);
  Future<List<ProjectModel>> getProjectsByClubId(String clubId);
}
