
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_technical_task/helpers/helper.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier{
  int _status = -1;
  User _user;

  int get status=>_status;
  User get user => _user;

  void loginUser(String phone, String password,BuildContext context)async{
    _status=AuthStatus.LOADING;
    notifyListeners();

    Map<String,String> data={
      'phone':phone,
      'password': password,
      'device_token': '123456',
      'device_id':'123456',
      'device_os':'android'
    };
    Uri url = Uri.parse(Api.LOGIN_API);
    var response = await http.post(url, body: jsonEncode(data));
    //print('response received ${jsonDecode(response.body)}');
    _user=User.fromJson(jsonDecode(response.body));
    _status= AuthStatus.SUCCESS;
    ///load posts
    context.read<PostProvider>().loadPosts(context);
    Navigator.pushNamed(context, '/posts');
    notifyListeners();
  }



}

class AuthStatus{
  static const int LOADING=0;
  static const int SUCCESS=1;
  static const int FAIL=2;
  static const int IDLE=-1;
}