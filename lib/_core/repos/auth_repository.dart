// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rotaract/_core/models/app_user.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';

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

  Stream<ClubMemberModel> watchCurrentUserInfo() {
    final auth = _firebaseAuth.currentUser;
    final firstTimeUser = ClubMemberModel(
      id: auth!.uid,
      email: auth.email!,
      firstName: "First",
      lastName: "Last",
      // Defaults to Kampala North
      clubId: "0b65b229-2114-41e5-be04-d4d688ee08b5",
    );

    final ref = _ref.doc(auth.uid);
    return ref.snapshots().map((doc) {
      if (!doc.exists) {
        ref.set(firstTimeUser.toMap());
      }
      return ClubMemberModel.fromMap(doc);
    });
  }

  Stream<ClubMemberModel> watchUserInfo(String userId) {
    return _ref
        .doc(userId)
        .snapshots()
        .map((doc) => ClubMemberModel.fromMap(doc));
  }
}
