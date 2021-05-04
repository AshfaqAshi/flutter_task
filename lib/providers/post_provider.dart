
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_technical_task/helpers/helper.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PostProvider extends ChangeNotifier{

  List<Post> _posts=[];
  int _status= PostStatus.IDLE;
  int _currentPage= 1;
  IO.Socket _socket = IO.io(Api.SOCKET_API);

  List<Post> get posts=>_posts;
  int get status=>_status;
  int get currentPage=>_currentPage;
  IO.Socket get socket=>_socket;

  PostProvider(){


    //socket.onConnectError((data) => print('conn err $data'));
    //socket.onConnectTimeout((data) => print('connection timed out $data'));
    //socket.onConnectError((data) => print('connection error $data'));
    //_socketChannel = IOWebSocketChannel.connect(Uri.parse(Api.SOCKET_API));
  }

  void recordReact(BuildContext context, Post post, String react)async{
    if(_socket.disconnected){
      print('conecting');
       _socket.connect();
    }

    _socket.onConnectError((data){
      print('error');
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to Web Socket. $data'))
      );
      _socket.disconnect();
    });

    _socket.onConnect((_){
      print('emitting data');
      ///emit the react
      var data  = jsonEncode({
        'authorization': '12345',
        'user_token': context.read<AuthProvider>().user.token,
        'sender': {
          'id':post.userId,
          'image': post.userImage,

        },
        'ref_id': post.id.toString(), 'react': react, 'request': 'post', 'type': 'react'
      });
      _socket.emit('react',data);
    });
  }
  void loadPosts(BuildContext context)async{
    if(_status!=PostStatus.LOADING){
      _status=PostStatus.LOADING;
      notifyListeners();
      _posts.clear();
      ///get the user from auth provider
      AuthProvider authProvider = context.read<AuthProvider>();
      Map<String,String> data={
        'user_token':authProvider.user.token,
        'page':_currentPage.toString(),
        'user_only':'4'
      };
      //print('url is ${Uri.http(Api.POST_API, '/postslist',data)}');
      var response = await http.get(Uri.http(Api.POST_API, '/postslist',data));
      //print('postst received ${jsonDecode(response.body)}');
      var result = jsonDecode(response.body);
      result['data'].forEach((data){
        _posts.add(Post.fromJson(data));
      });
      _status=PostStatus.LOADED;
      notifyListeners();
      _socket.on('react', (data) => print(data));

    }
  }

  void changePage(int page){
    _currentPage=page;
  }
}

class PostStatus{
  static const int LOADING=0;
  static const int LOADED=1;
  static const int LOAD_ERROR=2;
  static const int IDLE=3;
}