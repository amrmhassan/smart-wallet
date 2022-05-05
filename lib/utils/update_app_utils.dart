// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/app_details.dart';
import 'package:smart_wallet/constants/update_app_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/providers/update_app_provider.dart';

//? getting the latest app version from firesotore like 1.0.0
Future<String?> getLatestVersion() async {
  var dbRef = FirebaseFirestore.instance;
  try {
    var result = await dbRef
        .collection(appDetailsCollectionName)
        .doc(lastAppVersionDocumentName)
        .get();
    String latestAppVersion = result['version'];
    return latestAppVersion;
  } catch (error) {
    CustomError.log(error: error);
  }
  return null;
}

//? checking if the app need update or not by comparing the currentVersion and the latest version
Future<bool> needUpdate() async {
  try {
    String? latestVersion = await getLatestVersion();
    if (latestVersion == null) {
      return false;
    } else if (latestVersion == currentAppVersion) {
      return false;
    } else {
      return true;
    }
  } catch (error) {
    CustomError.log(error: error);
    return false;
  }
}

//? getting the download url from the firesotore
Future<Reference?> getDownloadRef() async {
  try {
    String latestVersion = (await getLatestVersion()).toString();

    Reference downloadRef =
        FirebaseStorage.instance.ref('/versions').child('$latestVersion.apk');

    return downloadRef;
  } catch (error) {
    CustomError.log(error: error);
  }
  return null;
}

//? for deleting the app and it's directory
Future<void> deleteApk() async {
  try {
    if (getDownloadDirectory.existsSync()) {
      await getDownloadDirectory.delete(recursive: true);
    }
  } catch (error) {
    CustomError.log(error: error);
  }
}

//? getting the apk file for the path
File get getUpdatedAPKFile {
  File apkFile = File('sdcard/$downloadFolderName/$updatedAppName');
  return apkFile;
}

//? getting the downloading directory
Directory get getDownloadDirectory {
  Directory dir = Directory('sdcard/$downloadFolderName');
  return dir;
}

//? handling permissions and create the downloading folder
Future<bool> createFolder() async {
  var status = await Permission.storage.request();
  var status2 = await Permission.manageExternalStorage.request();

  if (status.isGranted && status2.isGranted) {
    try {
      if (!getDownloadDirectory.existsSync()) {
        await getDownloadDirectory.create();
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  } else {
    if (kDebugMode) {
      print('Premission not granted');
    }
    return false;
  }
}

//? installing the update
Future<void> installApp() async {
  try {
    await OpenFile.open(getUpdatedAPKFile.path);
  } catch (error) {
    CustomError.log(error: error, rethrowError: true);
  }
}

//? handling the updating and installing the update
Future<void> updateAndInstall(BuildContext context,
    [bool showDialog = false]) async {
  if (showDialog) {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'App Need Update.',
      btnOkText: 'Update',
      btnCancelText: 'Cancel',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await Provider.of<UpdateAppProvider>(context, listen: false)
            .initializeDownloading();
        await installApp();
      },
    ).show();
  } else {
    await Provider.of<UpdateAppProvider>(context, listen: false)
        .initializeDownloading();
    await installApp();
  }
}
