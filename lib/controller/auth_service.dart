import 'package:firebase_auth/firebase_auth.dart';
import 'package:norq_technologies/model/user_model.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? _userFromCredential(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel?> get userlog {
    return auth
        .authStateChanges()
        .map((User? user) => _userFromCredential(user));
  }

  Future signEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromCredential(user);
    } catch (e) {
      return null;
    }
  }

  Future resgisterwithEmailAndPaswword(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromCredential(user);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'Email-already-in-use') {
          throw 'Email-already-in-use';
        }
      }
      return null;
    }
  }
}
