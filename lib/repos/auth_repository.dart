// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rotaract/models/app_user.dart';
import 'package:rotaract/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  AuthRepository(
    this._firebaseAuth,
    this._firestore,
  );
  AppUser _userFromFirebase(User? firebaseUser) {
    return firebaseUser == null ? AppUser(null) : AppUser(firebaseUser.uid);
  }

  Stream<AppUser> onAuthStateChanges() {
    return FirebaseAuth.instance
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
    return FirebaseAuth.instance.signOut();
  }

  Stream<UserModel> watchCurrentUserInfo() {
    final auth = _firebaseAuth.currentUser;
    final firstTimeUser = UserModel(
      id: auth!.uid,
      email: auth.email!,
      isActive: true,
      createdAt: DateTime.now(),
      isVerified: false,
      name: "New User",
    );

    final ref = _firestore.collection("USERS").doc(auth.uid);
    return ref.snapshots().map((doc) {
      if (!doc.exists) {
        ref.set(firstTimeUser.toMap());
      }
      return UserModel.fromMap(doc);
    });
  }

  // Future<void> saveDeviceToken() async {
  //   final fcm = FirebaseMessaging.instance;

  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //   String? fcmToken = await fcm.getToken();
  //   if (fcmToken != null) {
  //     FirebaseFirestore.instance.collection("users").doc(uid).update(
  //       {
  //         "token": fcmToken,
  //         "platform": Platform.operatingSystem,
  //       },
  //     );
  //   }
  // }

  Stream<UserModel> watchUserInfo(String userId) {
    final ref = _firestore.collection("USERS").doc(userId);
    return ref.snapshots().map((doc) => UserModel.fromMap(doc));
  }
}
