import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:katyfestascatalog/features/service/interfaces/i_auth_firebase.dart';

class AuthServiceFirebase implements IAuthFireBase{
  final FirebaseAuth firebaseAuth;
  final GoogleAuthProvider authProvider;
  final GoogleSignIn googleSignIn;
  
  AuthServiceFirebase(this.firebaseAuth, this.authProvider, this.googleSignIn);
  
  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.code; 
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  @override
  Future<User?> createUserWithGoogleAccount() async {
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithPopup(authProvider);
      return  userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  @override
  Future<void> signOutFireBase() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}