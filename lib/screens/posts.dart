import 'package:flutter/material.dart';
import 'package:flutter_technical_task/helpers/helper.dart';
import 'package:flutter_technical_task/providers/post_provider.dart';
import 'package:flutter_technical_task/widgets/post_view.dart';
import 'package:provider/provider.dart';

class Posts extends StatefulWidget{

  _postState createState()=>_postState();
}

class _postState extends State<Posts>{

  void initState(){
    super.initState();

  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),

      body:
           Consumer<PostProvider>(
              builder: (context,provider,child){
                if(provider.status==PostStatus.LOADING){
                  return Center(child: CircularProgressIndicator(),);
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: provider.posts.map((post){
                          return PostView(post);
                        }).toList(),
                      ),

                      Utilities.verticalSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            onPressed: (provider.currentPage>1)?(){
                              provider.changePage(provider.currentPage-1);
                              provider.loadPosts(context);
                            }:null,
                            child: Text('Previous Page'),
                          ),
                          FlatButton(
                            onPressed:(){
                              provider.changePage(provider.currentPage+1);
                              provider.loadPosts(context);
                            },
                            child: Text('Next Page'),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),


    );
  }
}