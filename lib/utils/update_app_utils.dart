import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_wallet/constants/app_details.dart';
import 'package:smart_wallet/constants/update_app_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';

//? getting the latest app version from firesotore like 1.0.0
Future<String?> _getLatestVersion() async {
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
Future<bool> _needUpdate() async {
  try {
    String? latestVersion = await _getLatestVersion();
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
    if (!await _needUpdate()) {
      return null;
    }
    String latestVersion = (await _getLatestVersion()).toString();

    Reference downloadRef =
        FirebaseStorage.instance.ref('/versions').child('$latestVersion.apk');

    return downloadRef;
  } catch (error) {
    CustomError.log(error: error);
  }
  return null;
}

Future<void> handleDownloadApp(
  BuildContext context, [
  bool showDialog = true,
]) async {
  Reference? downloadRef = await getDownloadRef();
  if (downloadRef == null) {
    return;
  }
  if (showDialog) {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'App Needs Update?',
      btnOkText: 'Update',
      btnCancelText: 'Cancel',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await downloadAPK(downloadRef, context);
      },
    ).show();
  } else {
    await downloadAPK(downloadRef, context);
  }
}

Future<File> getUpdatedAPKFile() async {
  final dir = await getExternalStorageDirectory();
  File apkFile = File('${dir!.path}/updatedFile.apk');
  return apkFile;
}

Future<File?> createFolder() async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    try {
      File apkFile = await getUpdatedAPKFile();
      return apkFile;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  } else {
    if (kDebugMode) {
      print('Premission not granted');
    }
    return null;
  }
}

Future<void> downloadAPK(Reference ref, BuildContext context) async {
  File? file = await createFolder();

  if (file == null) {
    if (kDebugMode) {
      print('Error updating the app');
    }

    return;
  }
  bool exist = file.existsSync();
  if (exist) {
    await file.delete();
  }

  await ref.writeToFile(file);
}
