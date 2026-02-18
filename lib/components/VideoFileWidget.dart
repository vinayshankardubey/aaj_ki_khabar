import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';
import '../utils/app_colors.dart';
import '../utils/Constants.dart';

class VideoFileWidget extends StatefulWidget {
  static String tag = '/VideoFileWidget';
  final String url;

  VideoFileWidget(this.url);

  @override
  VideoFileWidgetState createState() => VideoFileWidgetState();
}

class VideoFileWidgetState extends State<VideoFileWidget> {
  VideoPlayerController? controller;

  bool showOverLay = false;
  bool isFullScreen = false;
  bool isBuffering = true;
  int currentPosition = 0;
  int duration = 0;
  bool isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url);

    init();
  }

  Future<void> init() async {
    // ignore: invalid_use_of_protected_member
    if (controller!.hasListeners) {
      controller!.removeListener(() {});
    }
    controller!.addListener(() {
      if (mounted && controller!.value.isInitialized) {
        currentPosition = controller!.value.duration.inMilliseconds == 0 ? 0 : controller!.value.position.inMilliseconds;
        duration = controller!.value.duration.inMilliseconds;
      }

      isBuffering = controller!.value.isBuffering;
      if (!controller!.value.isPlaying && !controller!.value.isBuffering) {
        if (controller!.value.duration == Duration(seconds: 0) || controller!.value.position == Duration(seconds: 0)) {
          return;
        }
      }

      if (controller!.value.isInitialized && !isVideoCompleted && controller!.value.duration.inMilliseconds == currentPosition) {
        isVideoCompleted = true;
      } else {
        isVideoCompleted = false;
      }

      this.setState(() {});
    });
    controller!.setLooping(false);

    controller!.initialize().then((_) {
      controller!.play();

      setState(() {});
    });

    LiveStream().on(playPauseLiveTv, (v) {
      if (v is bool) {
        if (v) {
          controller?.play();
        } else {
          controller?.pause();
        }
        setState(() {});
      }
    });
  }

  void handlePlayPauseVideo() {
    if (isVideoCompleted) {
      isVideoCompleted = false;

      init();
      //controller.play();
    } else {
      controller!.value.isPlaying ? controller!.pause() : controller!.play();
    }

    showOverLay = !showOverLay;
    setState(() {});
  }

  @override
  void dispose() {
    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      LiveStream().emit(isFullScreenApp, false);
    }
    LiveStream().dispose(playPauseLiveTv);
    super.dispose();
    controller?.removeListener(() {});
    controller?.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller!.value.isInitialized ? controller!.value.aspectRatio : 16 / 10,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(controller!),
          GestureDetector(
            onTap: () {
              showOverLay = !showOverLay;

              setState(() {});
            },
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: showOverLay
                ? Container(
                    color: Colors.black45,
                    child: Stack(
                      children: <Widget>[
                        // Top-right Full Screen Icon
                        Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: () {
                              if (!isFullScreen) {
                                SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                              } else {
                                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                              }
                              isFullScreen = !isFullScreen;
                              LiveStream().emit(isFullScreenApp, isFullScreen);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: Icon(
                                isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        // Middle segment for Controls
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.replay_10, color: Colors.white, size: 40),
                                onPressed: () {
                                  final currentPos = controller!.value.position;
                                  controller!.seekTo(currentPos - Duration(seconds: 10));
                                },
                              ).visible(!widget.url.contains("m3u8")),
                              GestureDetector(
                                onTap: handlePlayPauseVideo,
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                                  child: Icon(
                                    controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.forward_10, color: Colors.white, size: 40),
                                onPressed: () {
                                  final currentPos = controller!.value.position;
                                  controller!.seekTo(currentPos + Duration(seconds: 10));
                                },
                              ).visible(!widget.url.contains("m3u8")),
                            ],
                          ),
                        ),
                        // Bottom segment for Progress
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!widget.url.contains("m3u8"))
                                VideoProgressIndicator(
                                  controller!,
                                  allowScrubbing: true,
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  colors: VideoProgressColors(playedColor: AppColors.primaryColor, bufferedColor: Colors.white24, backgroundColor: Colors.white12),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller!.value.position.toString().split('.').first.padLeft(8, "0"),
                                      style: secondaryTextStyle(color: Colors.white),
                                    ),
                                    if (!widget.url.contains("m3u8"))
                                      Text(
                                        controller!.value.duration.toString().split('.').first.padLeft(8, "0"),
                                        style: secondaryTextStyle(color: Colors.white),
                                      ),
                                    if (widget.url.contains("m3u8"))
                                      Row(
                                        children: [
                                          Container(height: 8, width: 8, decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                                          4.width,
                                          Text("LIVE", style: boldTextStyle(color: Colors.white, size: 12)),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    showOverLay = !showOverLay;
                    setState(() {});
                  })
                : SizedBox.shrink(),
          ),
          Loader().visible(isBuffering)
        ],
      ),
    );
  }
}

