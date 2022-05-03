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
    downloadProgress = p;
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

    await dio.download(
        'https://dw.uptodown.com/dwn/73JX1WRnu1UL5aYS5kLqLlC3tMw5WxJxzc3o27-00BULtyVsKFzsj4Ie8zgGcAILePryXRJ6AHi6zZsmEcuQ1tbcTvyMETDNKgGR2p1_IDNBgNSZszOt_4ltsvkom9vU/VVEPyjTx3LSG2MBqjtRFf2Y9ICY-c6FHE-H7GJYlUGLp3KffVWWAEuUA2IIKp5_k3NJs0BF0O3FecDCCrHlZbbLGAn5D9esXd18qSgSBlCSI7t-5UmOeGY-ThlCrlKSx/pu5I1gETCmHuz-dzVfo9sdF5wN540FIwDNMmRiCUUCm13TteUbwof9MFOOH7-grg/',
        getUpdatedAPKFile.path, onReceiveProgress: ((count, total) {
      downloadProgress = count / total;
      notifyListeners();
    }));
    downloading = false;
    downloaded = true;
    downloadProgress = 0;
    notifyListeners();
  }
}
