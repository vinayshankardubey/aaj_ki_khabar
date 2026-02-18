import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../network/api/api_servies.dart';

class LiveTvProvider extends ChangeNotifier {
  YoutubePlayerController? _youtubePlayerController;
  final String youtubeVideoUrl = "https://www.youtube.com/watch?v=EUA8ynGRyEs&t=65s";
  String _youtubeVideoId = "";
  bool isVideoReady = false;

  // Pagination for News Reels
  List<dynamic> reelsData = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;

  YoutubePlayerController get youtubePlayerController => _youtubePlayerController!;
  String get youtubeVideoId => _youtubeVideoId;

  Future<void> initVideoController() async {
    try {
      _youtubeVideoId = YoutubePlayer.convertUrlToId(youtubeVideoUrl)!;
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: _youtubeVideoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          isLive: true,
          disableDragSeek: true,
        ),
      );
      notifyListeners();
    } catch (ex) {
      debugPrint("Exception occurred while assign controller to video $ex");
    }
  }

  Future<void> fetchReelsData({bool isRefresh = false}) async {
    if (isLoading) return;
    if (!hasMore && !isRefresh) return;

    if (isRefresh) {
      currentPage = 1;
      reelsData.clear();
      hasMore = true;
    }

    isLoading = true;
    notifyListeners();

    try {
      final newData = await ApiServices.fetchPostData(page: currentPage, perPage: 10);
      if (newData.isNotEmpty) {
        reelsData.addAll(newData);
        currentPage++;
        if (newData.length < 10) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      debugPrint("Error fetching reels: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
