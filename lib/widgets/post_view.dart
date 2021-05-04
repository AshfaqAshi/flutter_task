
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_technical_task/helpers/helper.dart';
import 'package:flutter_technical_task/providers/download_provider.dart';
import 'package:flutter_technical_task/screens/video_screen.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class PostView extends StatelessWidget{
  Post post;
  PostProvider postProvider;

  PostView(this.post);

  Widget build(BuildContext context){
    postProvider = context.read<PostProvider>();

    return Padding(padding: EdgeInsets.all(Paddings.POST_VIEW_PADDING),
    child: Card(
      elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.CARD_RADIUS)
        ),
      child: Padding(
        padding: EdgeInsets.all(Paddings.CONTENT_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: Dimens.AVATAR_RADIUS,
                  backgroundImage: CachedNetworkImageProvider(post.userImage),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(post.userName,
                        style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 17),),
                        Text(_getFormattedDate(), style: Theme.of(context).textTheme.caption,)
                      ],
                    ),
                  ),
                ),
                if(post.postType!=PostType.TEXT)
                PopupMenuButton<int>(
                  onSelected: (i){
                    if(i==0){
                      ///Open Download Box and start provider
                      String filename;
                      if(post.postType==PostType.PHOTO)
                        filename=basename(post.imageUrl);
                      else if(post.postType==PostType.VIDEO)
                        filename = '${basename(post.videoUrl)}';

                      showDialog(
                        context: context,
                          builder: (_)=>DownloadBox());
                      context.read<DownloadProvider>().downloadFile(context, filename,
                          post.postType==PostType.VIDEO?post.videoUrl:post.imageUrl);
                    }
                  },
                  child: Icon(Icons.more_horiz,size: 35,),
                  itemBuilder: (context){
                    return List.generate(1, (index){
                      return PopupMenuItem(
                        value: index,
                        child:Text('Download'),
                      );
                    });
                  },
                )
              ],
            ),
            Utilities.verticalSpace(),
            if(post.content.isNotEmpty && post.postType!=PostType.TEXT)
              Text(post.content),

            if(post.content.isNotEmpty && post.postType!=PostType.TEXT)
              Utilities.verticalSpace(),

            ///POST
            _getPost(context),
            Utilities.verticalSpace(),

            ///LIKE, SHARE, COMMENT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getReacts(context),
                _getCommentShare(context)
              ],
            ),
            Utilities.verticalSpace(height: 17),
            if(post.comments>1)
              Text('view all ${post.comments} comments', style: Theme.of(context).textTheme.caption,),
            if(post.comments>1)
              Utilities.verticalSpace(),

            ///COMMENT BOX
            TextField(
              decoration: InputDecoration(
                  hintText: 'Write a comment',
                  contentPadding: EdgeInsets.symmetric(horizontal: Paddings.TEXT_BOX_H_PADDING,vertical: Paddings.TEXT_BOX_V_PADDING),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimens.COMMENT_BOX_RADIUS),

                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimens.COMMENT_BOX_RADIUS),
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      )
                  ),

                  filled: true,
                  fillColor: Colors.grey[200]
              ),
            )
            /*FlatButton(
              child: Text('Add to stream'),
              onPressed: (){

              },
            )*/
          ],
        ),
      ),
    ),);
  }

  _getCommentShare(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(post.comments>0?'${post.comments}':'',style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15),),

            SizedBox(
              width: 20,
                height: 20,
              child: Icon(Icons.comment),
            )
          ],
        ),
        Utilities.horizontalSpace(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(post.shares!=null?'${post.shares}':'',style: Theme.of(context).textTheme.caption.copyWith(fontSize: 15)),
            SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.share),
            )
          ],
        ),

      ],
    );
  }

  _getReacts(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ///First display the reacts
        for(React react in post.reacts)
          IconButton(
            onPressed: (){
              postProvider.recordReact(context, post,react.rc);
            },
           iconSize: 30,
            icon: Image.asset(_getReactIcon(react),),
          ),
        Utilities.horizontalSpace(width: 5),
        ///Now get the react images
        SizedBox(
          width: 50,
          child: Stack(
            children: [
              Positioned(
                child: _getReactDetails(0),
              ),
              Positioned(
                left: 15,
                child: _getReactDetails(1),
              ),
              Positioned(
                left: 25,
                child: _getReactDetails(2),
              ),
            ],
          ),
        ),

        Utilities.horizontalSpace(width: 5),
        ///Finally get the no of people
        Text(_getReactCount(),style: Theme.of(context).textTheme.caption,)

      ],
    );
  }

  _getReactDetails(int index){
    if(index<post.reactDetails.length){
      return  SizedBox(
          width: 25,
          height: 25,
          child: CircleAvatar(
            radius: Dimens.AVATAR_RADIUS,
            backgroundImage: CachedNetworkImageProvider(post.reactDetails[index]),
          ),
        );
    }else{
      return Container();
    }
  }

  _getReactCount(){
    if(post.reactDetails.length<=3){
      return '';
    }else{
      return '${post.reactDetails.length-3} others';
    }
  }

  _getReactIcon(React react){
    if(react.rc=='😍'){
      return 'assets/images/love.png';
    }else{
      return 'assets/images/like.png';
    }
  }

  _getPost(BuildContext context){
    if(post.postType==PostType.PHOTO){
      ///Display the photo
      return AspectRatio(
        aspectRatio: 4/3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.CARD_RADIUS),
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context,url,error){
              print('error loading image $error');
              return Center(
                child: SizedBox(
                  width: 10,
                    height: 10,
                  child: Icon(Icons.error,color: Colors.red,),
                ),
              );
            },
            placeholder:(context,url){
              return Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      );
    }else if(post.postType==PostType.VIDEO){
      ///Display Video Player
      return AspectRatio(
            aspectRatio: 4/3,
            child: ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.CARD_RADIUS)
              ),
              child: RaisedButton(
                color: CustomColors.VIDEO_THUMBNAIL,
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_)=>VideoScreen(post.videoUrl)
                  ));
                },
                child: Center(
                  child: Icon(Icons.play_circle_fill_outlined,size: 75,),
                ),
              ),
            ),
          );
    }else if(post.postType==PostType.TEXT){
      ///Display the content
      return FractionallySizedBox(
        widthFactor: 1,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.CARD_RADIUS)
          ),
          color: CustomColors.POST_TEXT_BACKGROUND,
          child: Padding(
            padding: EdgeInsets.all(Paddings.CONTENT_PADDING),
            child:post.content.isNotEmpty? Text(post.content,style: Theme.of(context).textTheme.bodyText2.copyWith(color: CustomColors.POST_TEXT_FORE_COLOR),):
            Center(child: Text('No post',style: Theme.of(context).textTheme.caption.copyWith(fontStyle: FontStyle.italic),),),
          ),
        ),
      );
    }
  }
  _getFormattedDate(){
    DateFormat dateFormat = DateFormat("MMMEd");
    DateTime today = DateTime.now();
    Duration diff = today.difference(post.date);
    String date= dateFormat.format(post.date);

    if(diff.inSeconds<10)
      date='Just now';
    else if(diff.inDays==0)
      date = 'today';
    else if(diff.inDays==1)
      date='yesterday';

    return date;
  }
}