import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:follow/features/authentication/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
class FirebaseAuthFunctions{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userData = FirebaseFirestore.instance
    .collection('firestore-example-app')
    .withConverter<UserModel>(
      fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    
  
  signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
        
    }
    
    return googleUser;
  }

}