import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../provider/live_tv_provider.dart';
import '../utils/Common.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../widget/reel_item_widget.dart';
import '../components/VideoFileWidget.dart';
import '../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  late LiveTvProvider liveTvProvider;
  int _selectedView = 0; // 0 for News Reels, 1 for Live TV


  @override
  void initState() {
    super.initState();
    liveTvProvider = Provider.of<LiveTvProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      liveTvProvider.initVideoController();
      liveTvProvider.fetchReelsData();
    });

    LiveStream().on(switchLiveTvTab, (v) {
      _selectedView = 1;
      setState(() {});
    });
  }

  @override
  void dispose() {
    liveTvProvider.youtubePlayerController.dispose();
    LiveStream().dispose(switchLiveTvTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setDynamicStatusBarColor(color: Colors.transparent);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<LiveTvProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.reelsData.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                // Main Content dependent on selected view
                _selectedView == 0
                    ? (provider.reelsData.isEmpty
                        ? const Center(child: Text("No news found", style: TextStyle(color: Colors.white)))
                        : PageView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: provider.reelsData.length,
                            onPageChanged: (index) {
                              if (index == provider.reelsData.length - 2) {
                                provider.fetchReelsData();
                              }
                            },
                            itemBuilder: (context, index) {
                              return ReelItemWidget(post: provider.reelsData[index]);
                            },
                          ))
                    : Center(
                        child: mLiveTvStreamUrl.endsWith('.m3u8')
                            ? VideoFileWidget(mLiveTvStreamUrl)
                            : _buildYoutubePlayer(liveTvProvider: provider),
                      ),

                // Custom Toggle UI at the top
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildToggleButton(
                            label: "News Reels",
                            isSelected: _selectedView == 0,
                            onTap: () {
                              _selectedView = 0;
                              LiveStream().emit(playPauseLiveTv, false);
                              setState(() {});
                            },
                          ),
                          _buildToggleButton(
                            label: "Live TV",
                            isSelected: _selectedView == 1,
                            onTap: () {
                              _selectedView = 1;
                              LiveStream().emit(playPauseLiveTv, true);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildToggleButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildYoutubePlayer({required LiveTvProvider liveTvProvider}) {
    return YoutubePlayerBuilder(
        player:
            YoutubePlayer(controller:  liveTvProvider.youtubePlayerController),
        builder: (context, player) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: player,
          );
        });
  }
}
