import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/providers/authentication_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/synced_data_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/utils/general_utils.dart';

//? 1] google login
Future googleLogin(BuildContext context) async {
  // if not online throw an error and log it
  bool online = await isOnline();
  if (!online) {
    CustomError.log(
      errorType: ErrorTypes.networkError,
      rethrowError: true,
    );
  }
  bool deleteAfterLoggingIn = false;
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    //! show a dialog here first to warn the user if he wants to sign the current user out or not
    //! showing a message that all the user data will be deleted form this device
    try {
      //* this means there is already a user signed in so sign out first then sign in with another user
      await logOut(context);
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

  try {
    // if there is no user logged in just return from the function
    // if any problem occurs just return
    await Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    ).googleLogin();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // if this error happened just don't show the dialog of deleting data
      return CustomError.log(
        errorType: ErrorTypes.notLoggedInSuccessfully,
        rethrowError: true,
      );
    }
  } catch (error, stackTrace) {
    return CustomError.log(
      error: error,
      stackTrace: stackTrace,
      rethrowError: true,
    );
  }
  await handleDownloadUserPhoto(context);

  var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);

  var transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

  var quickActionsProvider =
      Provider.of<QuickActionsProvider>(context, listen: false);

  //? here asking the user to delete the current existing data or not
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Delete existing data before logging in ?',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      deleteAfterLoggingIn = true;
    },
  ).show();

  await Provider.of<SyncedDataProvider>(context, listen: false).getAllData(
    profileProvider,
    transactionProvider,
    quickActionsProvider,
    deleteAfterLoggingIn,
  );
}

//? 2] google logout
Future<void> logOut(BuildContext context) async {
  bool keepData = false;
  await Provider.of<AuthenticationProvider>(
    context,
    listen: false,
  ).googleLogout();

  //? keeping the data of the logged out user will cause a problem of the syncing flags of his data will be none
  //? so i will delete the data from the local storage after the user is logged out
  //? to implement this
  //? one option is to edit all  the kept data flags to be add
  //? but as i said this will cause another problem of duplicate data if the user logged in with the same user after logging out
  //? ------ Don't implement keeping the logged out user data --------------

  // await AwesomeDialog(
  //   context: context,
  //   dialogType: DialogType.WARNING,
  //   animType: AnimType.BOTTOMSLIDE,
  //   title: 'Keep data of logged out user?',
  //   btnCancelOnPress: () {},
  //   btnOkOnPress: () {
  //     keepData = true;
  //   },
  // ).show();

  var profileProvider = Provider.of<ProfilesProvider>(context, listen: false);

  var transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);

  var quickActionsProvider =
      Provider.of<QuickActionsProvider>(context, listen: false);

  if (!keepData) {
    profileProvider.clearAllProfiles();
    transactionProvider.clearAllTransactions();
    quickActionsProvider.clearAllQuickActions();
    await DBHelper.deleteDatabase(dbName);
    await profileProvider.clearActiveProfileId();
  }
  await handleDeleteUserPhoto(context);

  await profileProvider.fetchAndUpdateProfiles();
  await profileProvider.fetchAndUpdateActivatedProfileId();
  String activeProfileId = profileProvider.activatedProfileId;
  await transactionProvider.fetchAndUpdateProfileTransactions(activeProfileId);
  await quickActionsProvider.fetchAndUpdateProfileQuickActions(activeProfileId);
  await transactionProvider.fetchAndUpdateAllTransactions();
  await quickActionsProvider.fetchAndUpdateAllQuickActions();
}

//? 3] download user photo and return the local path after downloading it
Future<void> handleDownloadUserPhoto(BuildContext context) async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null && currentUser.photoURL != null) {
    String? photoUrl = currentUser.photoURL;
    if (photoUrl != null) {
      try {
        String photoLocalPath = await getUserPhotoPath();
        await handleDeleteUserPhoto(context);

        Dio dio = Dio();
        await dio.download(
          photoUrl,
          photoLocalPath,
        );
        File userPhoto = File(photoLocalPath);
        Provider.of<AuthenticationProvider>(context, listen: false)
            .setUserPhoto(userPhoto);
      } catch (error, stackTrace) {
        CustomError.log(error: error, stackTrace: stackTrace);
      }
    }
  }
}

//? deleting user photo and setting the user photo provider to null
Future<void> handleDeleteUserPhoto(BuildContext context) async {
  try {
    String photoLocalPath = await getUserPhotoPath();
    File userPhoto = File(photoLocalPath);
    if (userPhoto.existsSync()) {
      await userPhoto.delete();
    }
    Provider.of<AuthenticationProvider>(context, listen: false)
        .setUserPhoto(null);
  } catch (error, stackTrace) {
    CustomError.log(error: error, stackTrace: stackTrace);
  }
}

//? getting the user photo local path
Future<String> getUserPhotoPath() async {
  String docDirPath = (await getApplicationDocumentsDirectory()).path;
  String photoLocalPath = '$docDirPath/$userProfilePhotoName';
  return photoLocalPath;
}

//? loading the user photo file and updating it to the returned file
Future<void> handleGetUserPhoto(Function(File? uP) setUserPhoto) async {
  String photoPath = await getUserPhotoPath();
  File file = File(photoPath);
  bool exists = await file.exists();
  if (!exists) {
    CustomError.log(errorType: ErrorTypes.noUserPhoto, rethrowError: true);
  }
  setUserPhoto(file);
}
