
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DownloadProvider extends ChangeNotifier{
  int _status;
  String _downloadPath;
  double _downloadProgress;

  int get status=>_status;

  double get downloadProgress=>_downloadProgress;
  String get downloadPath=>_downloadPath;

  void downloadFile(BuildContext context, String fileName, String url)async{
    if(_status!=DownloadStatus.DOWNLOADING){
      _status=DownloadStatus.DOWNLOADING;
      notifyListeners();
      String _folderPath;
      if(Platform.isIOS){
        _folderPath =  (await getApplicationSupportDirectory()).path;
      }else{
        _folderPath = (await getExternalStorageDirectory()).path;
      }
      String path = '$_folderPath/$fileName';
      //print('path is $path');
      File file = File(path);
      ///Delete the file if already exists
      if(file.existsSync()){
        file.deleteSync();
      }

      file.createSync(recursive: true);
      Dio dio = Dio();
      _downloadProgress=null;
      _downloadPath=path;
      await dio.download(url, path, onReceiveProgress: (rec,total){
        _downloadProgress= (rec.toDouble()/total.toDouble())*1.0;
        notifyListeners();
      });

      _status=DownloadStatus.DOWNLOADED;

      notifyListeners();
    }
  }

}

class DownloadStatus{
  static const int DOWNLOADING=0;
  static const int DOWNLOADED=1;
  static const int ERROR=2;
}