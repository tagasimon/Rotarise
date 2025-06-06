import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rotaract/projects/domain/projects_interface.dart';
import 'package:rotaract/projects/models/project_model.dart';

class ProjectsRepo implements ProjectsInterface {
  final CollectionReference _ref;
  ProjectsRepo(this._ref);
  @override
  Future<void> createProject(ProjectModel project) async {
    await _ref.add(project.toMap());
  }

  @override
  Future<void> deleteProject(String id) {
    // find the project by id and delete it
    final docRef = _ref.where('id', isEqualTo: id).limit(1);
    return docRef.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.reference.delete();
      } else {
        throw Exception('Project with id $id not found');
      }
    });
  }

  @override
  Future<List<ProjectModel>> getAllProjects() {
    return _ref.get().then((snapshot) {
      return snapshot.docs.map((doc) {
        return ProjectModel.fromFirestore(doc);
      }).toList();
    });
  }

  @override
  Future<ProjectModel?> getProjectById(String id) {
    final docRef = _ref.where('id', isEqualTo: id).limit(1);
    return docRef.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return ProjectModel.fromFirestore(snapshot.docs.first);
      } else {
        return null;
      }
    });
  }

  @override
  Future<List<ProjectModel>?> getProjectsByClubId(String clubId) {
    final query = _ref.where('clubId', isEqualTo: clubId);
    return query.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return snapshot.docs.map((doc) {
        return ProjectModel.fromFirestore(doc);
      }).toList();
    });
  }

  @override
  Future<void> updateProject(ProjectModel project) {
    // find the project by id and update it
    final docRef = _ref.where('id', isEqualTo: project.id).limit(1);
    return docRef.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.reference.update(project.toMap());
      } else {
        throw Exception('Project with id ${project.id} not found');
      }
    });
  }
}
