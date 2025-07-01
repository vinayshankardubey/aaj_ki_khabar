import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveTvProvider extends ChangeNotifier{
   YoutubePlayerController? _youtubePlayerController;
   final String youtubeVideoUrl = "https://www.youtube.com/watch?v=EUA8ynGRyEs&t=65s";
   String _youtubeVideoId = "";
   bool isVideoReady = false;

   YoutubePlayerController get youtubePlayerController => _youtubePlayerController!;
   String get youtubeVideoId => _youtubeVideoId;



   Future<void> initVideoController() async{
     try {
       print("Controller befor: ");
       _youtubeVideoId = YoutubePlayer.convertUrlToId(youtubeVideoUrl)!;
       _youtubePlayerController = YoutubePlayerController(
         initialVideoId: _youtubeVideoId,
         flags:  YoutubePlayerFlags(
           autoPlay: false,
           mute: false,
           isLive: true,
           disableDragSeek: true,
         ),
        );
       notifyListeners();
       }
     catch (ex){
       debugPrint("Exception occurred while assign controller to video $ex");
     }
   }



}
