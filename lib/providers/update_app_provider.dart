import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/utils/update_app_utils.dart';

class UpdateAppProvider extends ChangeNotifier {
  double downloadProgress = 0;
  bool downloading = false;
  bool downloaded = false;

  void setProgress(double p) {
    if (p < 0) {
      downloadProgress = 0;
    } else {
      downloadProgress = p;
    }
    notifyListeners();
  }

  Future<void> initializeDownloading() async {
    try {
      //* checking if app need update
      if (!await needUpdate()) {
        return;
      }
      //* deleting the app if exist
      await deleteApk();
      //* getting download link if needing update
      Reference? downloadRef = await getDownloadRef();
      if (downloadRef == null) {
        return;
      }
      //* starting downloading the app
      await _startDownloadingUpdatedAPK(downloadRef);
    } catch (error) {
      CustomError.log(
        error: error,
      );
    }
  }

  Future<void> _startDownloadingUpdatedAPK(Reference ref) async {
    late bool fileCreated;
    late Reference? downloadRef;
    late String? downloadLink;
    try {
      fileCreated = await createFolder();
      downloadRef = await getDownloadRef();
      downloadLink = await downloadRef?.getDownloadURL();
    } catch (error) {
      CustomError.log(error: error);
    }

    if (!fileCreated || downloadLink == null) {
      return;
    }

    Dio dio = Dio();
    downloading = true;
    notifyListeners();

    await dio.download(downloadLink, getUpdatedAPKFile.path,
        onReceiveProgress: ((count, total) {
      downloadProgress = count / total;
      notifyListeners();
    }));
    downloading = false;
    downloaded = true;
    downloadProgress = 0;
    notifyListeners();
  }
}
