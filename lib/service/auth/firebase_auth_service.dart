import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
Future<void> saveUserDetails(User user, String username) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': username,
      'email': user.email,
    }, SetOptions(merge: true)); 
    print("User details saved successfully");
  } catch (e) {
    print("Error saving user details: $e");
  }
}


Future<User?> signUpWithEmailAndPassword(String username, String email, String password) async {
  try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = credential.user;

    if (user != null) {
      await saveUserDetails(user, username); 
      print("User registered and details saved");
    }

    return user;
  } catch (e) {
    print("Error during sign-up: $e"); 
  }
  return null;
}

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  } catch (e) {
    print("Some error accured");
  }
  return null;
  }
}