import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class FirebaseHelper {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addData({required String email, required String name, required String phoneNo}) async {
    await firestore.collection("users").doc().set({"email": email, "name": name, "phoneNo": phoneNo});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    return await firestore.collection("users").get();
  }

  Future<void> deleteData(String id) async {
    await firestore.collection("users").doc(id).delete();
  }

  Future<void> updateData({
    required String id,
    required String name,
    required String email,
    required String phoneNo,
  }) async {
    await firestore.collection("users").doc(id).update({"email": email, "name": name, "phoneNo": phoneNo});
  }
}

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // scopes: [
    //   'https://www.googleapis.com/auth/drive',
    // ],
  ); // No need for .instance

  Future<User?> signInWithGoogle() async {
   final user = await _googleSignIn.signIn();

   GoogleSignInAuthentication userAuth = await user!.authentication;
   var credential =  GoogleAuthProvider.credential(idToken:  userAuth.idToken,accessToken: userAuth.accessToken);
   await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // --- Sign-Out Function ---
  Future<void> signOut() async {
    // Sign out from Google first
    await _googleSignIn.signOut();
    // Then sign out from Firebase
    await _auth.signOut();
    print("User signed out.");
  }
}