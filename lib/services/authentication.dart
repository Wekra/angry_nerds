import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<BaseUser> getCurrentUser();

  Future<void> signOut();
}

abstract class BaseUser {
  String getUid();

  String getLogIn();
}

class FireUser implements BaseUser {
  final FirebaseUser firebaseUser;

  FireUser(this.firebaseUser);

  @override
  String getLogIn() {
    return this.firebaseUser.email;
  }

  @override
  String getUid() {
    return this.firebaseUser.uid;
  }
}

class FireAuth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FireUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user == null ? null : new FireUser(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
