import 'package:flutter/material.dart';
import 'package:live_uttarpradesh/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../provider/live_tv_provider.dart';
import '../utils/Common.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../widget/news_item_details_widget.dart';
import 'live_tv_item_widget.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  late LiveTvProvider liveTvProvider;


  @override
  void initState() {
    super.initState();
    liveTvProvider = Provider.of<LiveTvProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_){
      liveTvProvider.initVideoController();
    });

  }

  @override
  void dispose() {
    liveTvProvider.youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setDynamicStatusBarColor(color: AppColors.redColor);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.fitHeight,
            width: 180,
          ),
        ),
        body: Consumer2<LiveTvProvider,HomeProvider>(builder: (context, liveTvProvider,homeProvider, child) {
          return Column(
            children: [
              _buildYoutubePlayer(liveTvProvider: liveTvProvider),
              Divider(color: AppColors.lightGreyColor,height: 5,),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(10),
                  children: [

                    Text("Trending News",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 2,
                      width: 100,
                      color: AppColors.grayColor,
                    ),
                    SizedBox(height: 10,),
                    homeProvider.topOfTheWeekData.isNotEmpty &&
                        homeProvider.isLoading == false
                        ?  ListView.builder(
                      itemCount: homeProvider.topOfTheWeekData
                          .length > 5 ? 5 : homeProvider
                          .topOfTheWeekData.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewsItemDetailsWidget(
                                            postData: homeProvider
                                                .topOfTheWeekData,
                                            index: index,
                                          ))
                              );
                            },
                            child: LiveTvItemWidget(
                              liveTvData: homeProvider
                                  .topOfTheWeekData,
                              index: index,
                            ),
                          ),
                        );
                      },
                    )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          );
        }),
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
