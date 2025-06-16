
import 'package:airecipe/repository/auth/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

final firebaseAuthProvider = Provider((ref)=> FirebaseAuth.instance);
final firestoreProvider=Provider((ref)=>FirebaseFirestore.instance);

@riverpod
AuthRepo authRepo(Ref ref){
 return AuthRepo(ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider));
}
