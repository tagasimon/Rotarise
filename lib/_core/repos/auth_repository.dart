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

  Stream<ClubMemberModel> watchCurrentUserInfoSimple() {
    final auth = _firebaseAuth.currentUser;
    if (auth == null) {
      throw Exception('User not authenticated');
    }

    final ref = _ref.doc(auth.uid);

    return ref.snapshots().asyncMap((doc) async {
      if (!doc.exists) {
        final firstTimeUser = ClubMemberModel(
          id: auth.uid,
          email: auth.email!,
          firstName: "Name",
          lastName: "",
        );

        // Use set with merge: false to create only if doesn't exist
        // This will fail silently if document already exists
        await ref.set(firstTimeUser.toMap()).catchError((error) {
          // Ignore errors - document might have been created by another process
          print('Error creating user document (likely already exists): $error');
        });

        // Fetch the document again to get the actual data
        final newDoc = await ref.get();
        return ClubMemberModel.fromFirestore(newDoc);
      }

      return ClubMemberModel.fromFirestore(doc);
    });
  }

  Stream<ClubMemberModel> watchUserInfo(String userId) {
    return _ref
        .doc(userId)
        .snapshots()
        .map((doc) => ClubMemberModel.fromFirestore(doc));
  }
}
