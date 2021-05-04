import 'package:flutter/material.dart';
import 'package:flutter_technical_task/helpers/helper.dart';
import 'package:flutter_technical_task/providers/download_provider.dart';

class DownloadBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.CARD_RADIUS)
      ),
      elevation: 12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child:
             Text('File Download', style: Theme.of(context).textTheme.headline6,),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 50
              ),
              child: Consumer<DownloadProvider>(
                builder: (context,provider,child){
                  if(provider.status==DownloadStatus.DOWNLOADING){
                    return Center(
                      child: CircularProgressIndicator(
                        value: provider.downloadProgress,
                      ),
                    );
                  }

                  if(provider.status==DownloadStatus.DOWNLOADED){
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.done, size: 50,),
                          Utilities.verticalSpace(),
                          Text('File downloaded to ${provider.downloadPath}')
                        ],
                      ),
                    );
                  }

                  if(provider.status==DownloadStatus.ERROR){
                    return Center(
                      child: Text('An error occurred while downloading', style:
                      Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.red),),
                    );
                  }
                  return Container();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
