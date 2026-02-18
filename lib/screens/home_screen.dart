import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_uttarpradesh/provider/home_provider.dart';
import 'package:live_uttarpradesh/utils/Constants.dart';
import 'package:live_uttarpradesh/widget/custom_shimmer_container.dart';
import 'package:live_uttarpradesh/widget/news_item_details_widget.dart';
import 'package:live_uttarpradesh/widget/trending_news_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../utils/Common.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../widget/news_item_widget.dart';
import '../widget/week_news_item_widget.dart';
import 'category_details_view_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider
          .of<HomeProvider>(context, listen: false)
          .fetchPostsData()
          .then((value) {
        Provider
            .of<HomeProvider>(context, listen: false)
            .fetchAllCategoryData();
        Provider
            .of<HomeProvider>(context, listen: false)
            .fetchTopOfTheWeekData();
        Provider.of<HomeProvider>(context, listen: false).fetchOtherStateData();
        Provider
            .of<HomeProvider>(context, listen: false)
            .fetchInternationalData();
      });
    });
  }

  final PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Image.asset(
              AppImages.appLogo,
              fit: BoxFit.fitHeight,
              width: 80,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  LiveStream().emit(switchLiveTvTab, true);
                },
                icon: Icon(Icons.live_tv, color: Colors.white),
                tooltip: "Live TV",
              ),
            ],
          ),
          body: RefreshIndicator(
            color: AppColors.grayColor,
            onRefresh: () async {
              await Provider
                  .of<HomeProvider>(context, listen: false)
                  .fetchPostsData();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [

                            homeProvider.postLoading == false && homeProvider
                                .postsData.isNotEmpty ?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //all category

                                if(homeProvider.categoryData != null &&
                                    homeProvider.categoryData.isNotEmpty)
                                  ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text("News category", style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),),
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context,MaterialPageRoute(builder: (context)=> CategoryScreen()));
                                          },
                                          child: Text("See all", style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),

                                    SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          homeProvider.categoryData.length, (
                                            index) {
                                          return InkWell(
                                              onTap: (){
                                                homeProvider.singleCategoryData = [];
                                                homeProvider.update();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CategoryDetailsViewScreen(
                                                      categoryId: homeProvider.filterList[index]["id"],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: _buildCategoryChip(name: homeProvider.categoryData[index]["name"]));
                                        }),
                                      ),
                                    )

                                  ] else
                                  ...[
                                    SizedBox()
                                  ],


                                // All News Section
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: homeProvider.postsData.length > 5
                                        ? 5
                                        : homeProvider.postsData.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {

                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsItemDetailsWidget(
                                                        postData: homeProvider
                                                            .postsData,
                                                        index: index,
                                                      )));
                                        },
                                        child: NewsItemWidget(
                                          postData: homeProvider.postsData,
                                          index: index,
                                        ),
                                      );
                                    }),
                                SizedBox(height: 10,),

                                //Top of the Week
                                Text("Top of The Week", style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                homeProvider.topOfTheWeekData.isNotEmpty &&
                                    homeProvider.isLoading == false ?
                                ListView.builder(
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
                                                      )));
                                        },
                                        child: WeekNewsItemWidget(
                                          weekData: homeProvider
                                              .topOfTheWeekData,
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                ) : SizedBox(),


                                //Trending Section
                                Text("Trending Now", style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                ListView.builder(
                                  itemCount: homeProvider.postsData.length > 5
                                      ? 4
                                      : homeProvider.postsData.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index1) {
                                    int index = index1;
                                    if (homeProvider.postsData.length > 5) {
                                      index = index1 + 5;
                                    } else {
                                      index = index1;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 25),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsItemDetailsWidget(
                                                        postData: homeProvider
                                                            .postsData,
                                                        index: index,
                                                      )));
                                        },
                                        child: TrendingNewsWidget(index: index,
                                            postData: homeProvider.postsData),
                                      ),
                                    );
                                  },
                                ),


                                SizedBox(height: 10,),
                                homeProvider.topOfTheWeekData.isNotEmpty &&
                                    homeProvider.isLoading == false ?
                                ListView.builder(
                                  itemCount: homeProvider.topOfTheWeekData
                                      .length > 5 ? 4 : homeProvider
                                      .topOfTheWeekData.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index1) {
                                    int index = index1;
                                    if (homeProvider.postsData.length > 5) {
                                      index = index1 + 4;
                                    } else {
                                      index = index1;
                                    }
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
                                                      )));
                                        },
                                        child: WeekNewsItemWidget(
                                          weekData: homeProvider
                                              .topOfTheWeekData,
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                ) : SizedBox(),

                            
                             
                                SizedBox(height: 10,),
                                ListView.builder(
                                  itemCount: homeProvider.internationalData
                                      .length > 5 ? 4 : homeProvider
                                      .internationalData.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index1) {
                                    int index = index1;
                                    if (homeProvider.internationalData.length >
                                        5) {
                                      index = index1 + 5;
                                    } else {
                                      index = index1;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 25),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsItemDetailsWidget(
                                                        postData: homeProvider
                                                            .internationalData,
                                                        index: index,
                                                      )));
                                        },
                                        child: TrendingNewsWidget(index: index,
                                            postData: homeProvider
                                                .internationalData),
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(height: 10,),

                                footerWidget()

                              ],
                            )
                                :
                            homeProvider.postsData.isEmpty && homeProvider
                                .postLoading == false
                                ? SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.3,
                                child: Center(child: Text("No News Found",
                                  textAlign: TextAlign.center,)))
                                : ListView.builder(
                              itemCount: 3,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // image
                                    CustomShimmerContainer(height: 200,),
                                    const SizedBox(height: 20),
                                    // Title
                                    CustomShimmerContainer(height: 10,),
                                    const SizedBox(height: 15),
                                    //desc
                                    CustomShimmerContainer(height: 10,),
                                    const SizedBox(height: 15),
                                    // Bottom info row
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        CustomShimmerContainer(
                                          height: 20, width: 50,),
                                        const SizedBox(width: 10),
                                        CustomShimmerContainer(
                                          height: 20, width: 50,),
                                        const Spacer(),
                                        CustomShimmerContainer(
                                          height: 20, width: 50,),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ),
      );
  }

  Widget footerWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Image.asset(AppImages.appLogo,)
        ],
      ),
    );
  }

  Widget _buildCategoryChip({required String name}) {
    return Chip(
      label: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).paddingOnly(right: 8,bottom: 10,top: 10);
  }
}
