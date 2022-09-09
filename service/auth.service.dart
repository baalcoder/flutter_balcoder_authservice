import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_balcoder_verdorcompany/ui/auth/model/user_model.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  // Future<User> getCurrentUser();

  Future<UserModel> getUser();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> signIn(String email, String password) async {
    User? user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user!.uid;
  }

  // Future<User> getCurrentUser() async {
  //   User user = _firebaseAuth.currentUser;
  //   return user;
  // }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    user!.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    return user!.emailVerified;
  }

  Future<UserModel> getUser() async {
    DocumentSnapshot querySnapshot;

    User? user = _firebaseAuth.currentUser;
    late UserModel userModel = new UserModel();

    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('userCollection')
          .doc(user!.uid)
          .get()
          .catchError((onError) => {print(onError)});
      if (querySnapshot.exists) {
        var userModel = new UserModel.fromSnapshot(
            data: querySnapshot.data(), id: querySnapshot.id);
        userModel.email = user.email!;

        print(userModel.toJson());
        return userModel;
      } else {
        return userModel;
      }
    } catch (e) {
      return userModel;
    }
  }
}
