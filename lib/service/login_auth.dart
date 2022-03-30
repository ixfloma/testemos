import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

enum Status {Uninitialized, Authenticated, Authenticating, Unauthenticated}

class loginAuth extends ChangeNotifier {
  FirebaseAuth auth;
  User? _user;

  Status _status = Status.Uninitialized;

  loginAuth.instance() : auth = FirebaseAuth.instance {
    auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;

  User? get user => _user;

  Future<bool> signIn(email, password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e){
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null){
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

}