import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/utils/synced_data_utils.dart';

class AuthenticationProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  File? userPhoto;

  void setUserPhoto(File? uP) {
    userPhoto = uP;
    notifyListeners();
  }

  Future<void> fetchAndUpdateUserPhoto() async {
    try {
      await handleGetUserPhoto(setUserPhoto);
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
      setUserPhoto(null);
    }
  }

  bool loggedIn() {
    bool logged = true;
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        logged = false;
      }
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
      logged = false;
    }
    return logged;
  }

  GoogleSignInAccount? _userGoogle;
  GoogleSignInAccount get userGoogle => _userGoogle!;

  Future<void> googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _userGoogle = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> googleLogout() async {
    try {
      await googleSignIn.signOut();
      // await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }
}
