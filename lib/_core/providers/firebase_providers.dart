import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreInstanceProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) =>
    FirebaseStorage.instanceFor(
        bucket: "gs://rotaract-584b8.firebasestorage.app"));

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

// EVENTS Collection
final eventsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('EVENTS'));

// PROJECTS Collection
final projectsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('PROJECTS'));

// POSTS Collection
final postsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('POSTS'));

// LIKES Collection
final likesCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('LIKES'));

// COMMENTS Collection
final commentsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('COMMENTS'));

// COMMENTS Collection
final buddyGroupsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('BUDDY_GROUPS'));

// MEETUPS Collection
final meetupsCollectionRefProvider = Provider<CollectionReference>(
    (ref) => ref.watch(firestoreInstanceProvider).collection('MEETUPS'));
