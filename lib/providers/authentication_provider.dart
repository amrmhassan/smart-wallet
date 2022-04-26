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
      File file = await handleGetUserPhoto();
      setUserPhoto(file);
    } catch (error) {
      setUserPhoto(null);
    }
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
    } catch (error) {
      CustomError.log(error);
    }
  }

  Future<void> googleLogout() async {
    try {
      await googleSignIn.signOut();
      // await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (error) {
      CustomError.log(error);
    }
  }
}
