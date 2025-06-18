import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/admin_tools/domain/projects_interface.dart';
import 'package:rotaract/projects/models/project_model.dart';

class ProjectsRepo implements ProjectsInterface {
  final CollectionReference _ref;
  ProjectsRepo(this._ref);

  @override
  Future<void> createProject(ProjectModel project) async {
    await _ref.add(project.toMap());
  }

  @override
  Future<void> updateProject(ProjectModel project) async {
    final ref = await _ref.where('id', isEqualTo: project.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.update(project.toMap());
    }
  }

  @override
  Future<void> deleteProject(ProjectModel project) async {
    final ref = await _ref.where('id', isEqualTo: project.id).get();

    if (ref.docs.isNotEmpty) {
      await ref.docs.first.reference.delete();
    }
  }

  @override
  Future<ProjectModel?> getProjectById(String id) async {
    final ref = await _ref.where('id', isEqualTo: id).get();

    if (ref.docs.isNotEmpty) {
      return ProjectModel.fromFirestore(ref.docs.first);
    }
    return null;
  }

  @override
  Future<int> getTotalProjectsCount() async {
    return _ref.count().get().then((value) => value.count ?? 0);
  }

  @override
  Future<int> getTotalProjectsCountByClubId(String clubId) async {
    return await _ref
        .where('clubId', isEqualTo: clubId)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }

  @override
  Future<List<ProjectModel>> getProjectsByClubId(String clubId) async {
    final ref = await _ref.where('clubId', isEqualTo: clubId).get();
    return ref.docs.map((e) => ProjectModel.fromFirestore(e)).toList();
  }
}
