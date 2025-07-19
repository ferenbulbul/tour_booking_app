import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  User? _user;
  User? get user => _user; // ✅ dışarıdan erişim için getter

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      _user = userCredential.user;

      if (_user != null) {
        print("🎉 Google ile giriş başarılı!");
        print("👤 Ad: ${_user!.displayName}");
        print("📧 Email: ${_user!.email}");
        print("🆔 UID: ${_user!.uid}");
        print("🖼️ Foto: ${_user!.photoURL}");
        print("📱 Telefon: ${_user!.phoneNumber}");
        print("📅 Oluşturulma: ${_user!.metadata.creationTime}");
        print("🔁 Son Giriş: ${_user!.metadata.lastSignInTime}");
      }

      notifyListeners();
    } catch (e) {
      print('🚨 Google Sign-In hatası: $e');
    }
  }
}
