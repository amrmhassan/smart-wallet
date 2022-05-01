import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_wallet/constants/app_details.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/constants/update_app_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/utils/general_utils.dart';

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

Future<String?> getDownloadUrl() async {
  try {
    if (!await _needUpdate()) {
      return null;
    }
    String latestVersion = (await _getLatestVersion()).toString();

    String downloadUrl = await FirebaseStorage.instance
        .ref('/versions')
        .child('$latestVersion.apk')
        .getDownloadURL();

    return downloadUrl;
  } catch (error) {
    CustomError.log(error: error);
  }
  return null;
}

Future<void> handleUpdateApp(
  BuildContext context, [
  bool showDialog = true,
]) async {
  String? link = await getDownloadUrl();
  if (link == null) {
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
      btnCancelOnPress: () {
        showSnackBar(context, 'Cancelling updating', SnackBarType.info);
      },
      btnOkOnPress: () async {
        showSnackBar(context, 'start updating', SnackBarType.info);
        await downloadAPK(link);
        showSnackBar(context, 'finished downloading', SnackBarType.info);
      },
    ).show();
  } else {
    showSnackBar(context, 'start updating', SnackBarType.info);
    await downloadAPK(link);
    showSnackBar(context, 'finished downloading', SnackBarType.info);
  }
}

String get downloadDir {
  return 'sdcard/SmartWallet';
}

Future<String> createFolder() async {
  final path = Directory(downloadDir);
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await path.exists())) {
    return path.path;
  } else {
    await path.create();
    return path.path;
  }
}

// Future<bool> _handleCreateDownloadDirAndPermissions() async {
//   try {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       Directory dir = Directory(downloadDir);

//       if (!dir.existsSync()) {
//         await dir.create(recursive: true);
//         print('File created');
//       } else {
//         print('File already exist');
//       }
//       return true;
//     } else {
//       print('Permission denied');
//       return false;
//     }
//   } catch (error) {
//     if (kDebugMode) {
//       print(error);
//     }
//     CustomError.log(error: error);
//     return false;
//   }
// }

Future<void> downloadAPK(String link) async {
  await createFolder();

  // final taskId = await FlutterDownloader.enqueue(
  //   url: link,
  //   savedDir: downloadDir,
  //   showNotification: true,
  //   openFileFromNotification: true,
  // );
  // var res = await FlutterDownloader.loadTasks();
  // print(res);
}
