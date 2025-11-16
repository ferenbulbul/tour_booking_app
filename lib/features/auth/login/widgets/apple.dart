import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({super.key});

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );

      final user = userCredential.user;
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hoş geldin: ${user.email ?? user.uid}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Apple login hatası: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // tüm genişlik
      height: 45, // sabit yükseklik
      child: SignInWithAppleButton(
        text: "Apple ile Giriş Yap",
        style: SignInWithAppleButtonStyle.black, // klasik siyah buton
        onPressed: () => _signInWithApple(context),
      ),
    );
  }
}
