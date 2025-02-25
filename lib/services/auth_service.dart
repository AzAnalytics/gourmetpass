import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:gourmetpass/models/user_model.dart';

abstract class AuthService {
  Future<User?> getCurrentUser();
  Future<User?> login(String email, String password);
  Future<User?> signup(String email, String password, String displayName);
  Future<void> logout();
}

class RealAuthService implements AuthService {
  final fbAuth.FirebaseAuth _firebaseAuth;

  RealAuthService({fbAuth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fbAuth.FirebaseAuth.instance;

  @override
  Future<User?> getCurrentUser() async {
    final fbUser = _firebaseAuth.currentUser;
    return fbUser != null ? _userFromFirebaseUser(fbUser) : null;
  }

  @override
  Future<User?> login(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebaseUser(credential.user!);
  }

  @override
  Future<User?> signup(String email, String password, String displayName) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(displayName);
    await credential.user?.reload();
    return _userFromFirebaseUser(_firebaseAuth.currentUser!);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User _userFromFirebaseUser(fbAuth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      isAdmin: false,
      isActive: true,
    );
  }
}
