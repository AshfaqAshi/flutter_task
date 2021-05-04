
import 'package:flutter_technical_task/helpers/helper.dart';

class Post{
  int id;
  String title;
  String postType;
  String imageUrl;
  String videoUrl;
  String content;
  int comments;
  DateTime date;
  List<React> reacts;
  List<String> reactDetails;
  int userId;
  String userName;
  String userImage;
  int shares;

  Post.fromJson(Map data){
    this.id=data['ID'];
    this.postType=data['post_type'];
    this.title=data['title'];
    this.content=data['content'];
    this.imageUrl=data['image'];
    this.videoUrl=data['video'];
    this.date=DateTime.parse(data['post_date']);
    this.comments=data['comments'];
    this.reactDetails=List.from(data['react_details']);
    this.reacts=_loadReacts(data['reacts']);
    this.userId=data['details']['id'];
    this.userName=data['details']['name'];
    this.userImage=data['details']['image'];
  }

  _loadReacts(var reactData){
    List<React> _reacts=[];
    reactData.forEach((react){
      _reacts.add(React.fromJson(react));
    });
    return _reacts;
  }
}

class PostType{
  static const String VIDEO='video';
  static const String PHOTO='photo';
  static const String TEXT='text';
}