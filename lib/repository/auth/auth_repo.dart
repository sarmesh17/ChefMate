
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRepo(this.firebaseAuth,this.firestore);

  // Login with email and password
  Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }


  Future<void> signupScreen({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match.");
    }

    try {
      // Step 1: Create user in Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception("User ID is null.");

      // Step 2: Save user data to Firestore
      await firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

    } on FirebaseAuthException catch (e) {
      throw Exception("Signup failed: ${e.message}");
    }
  }

}