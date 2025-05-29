import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreInstanceProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final firebaseStorageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// CLUBS Collection
final clubsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('CLUBS'));

// MEMBERS Collection
final membersCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('MEMBERS'));

// ROLES Collection
final rolesCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('ROLES'));
