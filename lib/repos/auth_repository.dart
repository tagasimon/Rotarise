// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rotaract/models/app_user.dart';
import 'package:rotaract/models/member_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _ref;
  AuthRepository(
    this._firebaseAuth,
    this._ref,
  );
  AppUser _userFromFirebase(User? firebaseUser) {
    return firebaseUser == null ? AppUser(null) : AppUser(firebaseUser.uid);
  }

  Stream<AppUser> onAuthStateChanges() {
    return _firebaseAuth
        .authStateChanges()
        .map((event) => _userFromFirebase(event));
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Stream<MemberModel> watchCurrentUserInfo() {
    final auth = _firebaseAuth.currentUser;
    final firstTimeUser = MemberModel(
      id: auth!.uid,
      email: auth.email!,
      firstName: "First Name",
      lastName: "Last Name",
    );

    final ref = _ref.doc(auth.uid);
    return ref.snapshots().map((doc) {
      if (!doc.exists) {
        ref.set(firstTimeUser.toMap());
      }
      return MemberModel.fromMap(doc);
    });
  }

  Stream<MemberModel> watchUserInfo(String userId) {
    return _ref.doc(userId).snapshots().map((doc) => MemberModel.fromMap(doc));
  }
}
