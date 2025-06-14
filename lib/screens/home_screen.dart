import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mighty_news/network/api/api_servies.dart';
import 'package:mighty_news/provider/home_provider.dart';
import 'package:mighty_news/widget/custom_shimmer_container.dart';
import 'package:mighty_news/widget/news_item_details_widget.dart';
import 'package:mighty_news/widget/trending_news_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/Colors.dart';
import '../widget/news_item_widget.dart';
import '../widget/week_news_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_)async{
     await Provider.of<HomeProvider>(context,listen: false).fetchPostsData().then((value){
        Provider.of<HomeProvider>(context,listen: false).fetchAllCategoryData();
        Provider.of<HomeProvider>(context,listen: false).fetchTopOfTheWeekData();
        Provider.of<HomeProvider>(context,listen: false).fetchOtherStateData();
        Provider.of<HomeProvider>(context,listen: false).fetchInternationalData();
      });
    });
  }
 final PageController pageController = PageController();
 int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        toolbarHeight: 64,
        title: Image.asset("assets/images/app_image.png",
          fit: BoxFit.fitHeight,
          height: 50,
        ),
        centerTitle: true,
      ),
      
      body: RefreshIndicator(
        color: colorPrimary,
        onRefresh: ()async{
          await Provider.of<HomeProvider>(context,listen: false).fetchPostsData();
        },
        child: SingleChildScrollView(
             child: Consumer<HomeProvider>(
               builder: (context,homeProvider,child) {
                 return Padding(
                         padding: const EdgeInsets.all(15.0),
                         child:Column(
                          children: [
                                 SizedBox(height: 10,),
                                 homeProvider.postLoading == false && homeProvider.postsData.isNotEmpty ?
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [

                                     // All News Section
                                   ListView.builder(
                                   shrinkWrap: true,
                                   itemCount: homeProvider.postsData.length>5 ? 5 : homeProvider.postsData.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:(context,index){

                                    print("length is ${homeProvider.postsData.length}");
                                      return InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                            postData: homeProvider.postsData,
                                            index: index,
                                          )));
                                        },
                                        child: NewsItemWidget(
                                          postData: homeProvider.postsData,
                                          index: index,
                                        ),
                                      );
                                    } ),

                                   Image.asset("assets/images/banner_img.png",
                                     fit: BoxFit.fitWidth,
                                   ),


                                   Text("Advertisement",style: TextStyle(fontSize: 12),),
                                   Divider(
                                     thickness: 1,
                                     color: Colors.grey,
                                   ),
                                   SizedBox(height: 10,),

                                    //Top of the Week
                                    Text("Top of The Week",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    homeProvider.topOfTheWeekData.isNotEmpty && homeProvider.isLoading==false ?
                                    ListView.builder(
                                         itemCount: homeProvider.topOfTheWeekData.length>5 ? 5 : homeProvider.topOfTheWeekData.length,
                                         shrinkWrap: true,
                                         physics: NeverScrollableScrollPhysics(),
                                         padding: EdgeInsets.zero,
                                         itemBuilder: (context, index) {
                                           return Padding(
                                             padding: const EdgeInsets.only(bottom: 10),
                                             child: InkWell(
                                               onTap: (){
                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                                   postData: homeProvider.topOfTheWeekData,
                                                   index: index,
                                                 )));
                                               },
                                               child: WeekNewsItemWidget(
                                                  weekData: homeProvider.topOfTheWeekData,
                                                 index: index,
                                               ),
                                             ),
                                           );
                                         },
                                       ):SizedBox(),


                                    //Trending Section
                                    Text("Trending Now",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 10,),
                                    ListView.builder(
                                     itemCount: homeProvider.postsData.length> 5 ? 4 : homeProvider.postsData.length,
                                     shrinkWrap: true,
                                     physics: NeverScrollableScrollPhysics(),
                                     padding: EdgeInsets.zero,
                                     itemBuilder: (context, index1) {
                                       int index = index1;
                                       if(homeProvider.postsData.length>5){
                                          index =  index1 +5;
                                       }else{
                                         index = index1;
                                       }
                                       return Padding(
                                         padding: const EdgeInsets.only(bottom: 25),
                                         child: InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                               postData: homeProvider.postsData,
                                               index: index,
                                             )));
                                           },
                                           child: TrendingNewsWidget(index: index, postData:  homeProvider.postsData),
                                         ),
                                       );
                                     },
                                   ),


                                    SizedBox(height: 10,),
                                    homeProvider.topOfTheWeekData.isNotEmpty && homeProvider.isLoading==false ?
                                    ListView.builder(
                                     itemCount: homeProvider.topOfTheWeekData.length> 5 ? 4 : homeProvider.topOfTheWeekData.length,
                                     shrinkWrap: true,
                                     physics: NeverScrollableScrollPhysics(),
                                     padding: EdgeInsets.zero,
                                     itemBuilder: (context, index1) {
                                       int index = index1;
                                       if(homeProvider.postsData.length>5){
                                         index =  index1 +4;
                                       }else{
                                         index = index1;
                                       }
                                       return Padding(
                                         padding: const EdgeInsets.only(bottom: 10),
                                         child: InkWell(
                                           onTap: (){
                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                               postData: homeProvider.topOfTheWeekData,
                                               index: index,
                                             )));
                                           },
                                           child: WeekNewsItemWidget(
                                             weekData: homeProvider.topOfTheWeekData,
                                             index: index,
                                           ),
                                         ),
                                       );
                                     },
                                   ):SizedBox(),

                                     //Most Popular Section
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text("Most Popular",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                         Icon(Icons.keyboard_double_arrow_right,)
                                       ],
                                     ),
                                     SizedBox(height: 10,),
                                     SizedBox(
                                       height: 250,
                                       child: PageView.builder(
                                          controller: pageController,
                                          itemCount: homeProvider.otherStateData.length > 5 ? 5 : homeProvider.otherStateData.length,
                                           onPageChanged: (index) {
                                             setState(() {
                                               currentIndex = index;
                                             });
                                           },
                                           itemBuilder:(context,index){
                                             return InkWell(
                                               onTap: (){
                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                                   postData: homeProvider.otherStateData,
                                                   index: index,
                                                 )));
                                               },
                                               child: Padding(
                                                 padding: EdgeInsets.only(right: 10),
                                                 child: TrendingNewsWidget(index: index, postData:  homeProvider.otherStateData),
                                               ),
                                             );
                                           }
                                       ),
                                     ),
                                     SizedBox(height: 5,),
                                     Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: List.generate(homeProvider.otherStateData.length > 5 ? 5 : homeProvider.otherStateData.length, (index) {
                                       return AnimatedContainer(
                                         duration: const Duration(milliseconds: 300),
                                         margin: const EdgeInsets.symmetric(horizontal: 4),
                                         width: currentIndex == index ? 20 : 12,
                                         height: currentIndex == index ? 10 : 8,
                                         decoration: BoxDecoration(
                                           color: currentIndex == index ? colorPrimary : Colors.grey,
                                           borderRadius: BorderRadius.circular(20),
                                           shape: BoxShape.rectangle,
                                         ),
                                       );
                                     }),
                                   ),

                                     // Other State Section
                                     Text("Other State",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                     SizedBox(height: 10,),
                                     ListView.builder(
                                         shrinkWrap: true,
                                         itemCount: homeProvider.otherStateData.length > 5 ? 4 : homeProvider.otherStateData.length,
                                         physics: NeverScrollableScrollPhysics(),
                                         itemBuilder:(context,index1){
                                           int index = index1;
                                           if(homeProvider.postsData.length>5){
                                             index =  index1 +5;
                                           }else{
                                             index = index1;
                                           }
                                           print("length is ${homeProvider.otherStateData.length}");
                                           return InkWell(
                                             onTap: (){
                                               Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                                 postData: homeProvider.otherStateData,
                                                 index: index,
                                               )));
                                             },
                                             child: NewsItemWidget(
                                               postData: homeProvider.otherStateData,
                                               index: index,
                                             ),
                                           );
                                         } ),


                                     // International  Section
                                     Text("International",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                                     SizedBox(height: 10,),
                                     ListView.builder(
                                         shrinkWrap: true,
                                         itemCount: homeProvider.internationalData.length > 5 ? 5 : homeProvider.internationalData.length,
                                         physics: NeverScrollableScrollPhysics(),
                                         itemBuilder:(context,index){
                                           print("length is ${homeProvider.internationalData.length}");
                                           return InkWell(
                                             onTap: (){
                                               Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                                 postData: homeProvider.internationalData,
                                                 index: index,
                                               )));
                                             },
                                             child: NewsItemWidget(
                                               postData: homeProvider.internationalData,
                                               index: index,
                                             ),
                                           );
                                         } ),

                                     // Section
                                     SizedBox(height: 10,),
                                     ListView.builder(
                                       itemCount: homeProvider.internationalData.length> 5 ? 4 : homeProvider.internationalData.length,
                                       shrinkWrap: true,
                                       physics: NeverScrollableScrollPhysics(),
                                       padding: EdgeInsets.zero,
                                       itemBuilder: (context, index1) {
                                         int index = index1;
                                         if(homeProvider.internationalData.length>5){
                                           index =  index1 + 5;
                                         }else{
                                           index = index1;
                                         }
                                         return Padding(
                                           padding: const EdgeInsets.only(bottom: 25),
                                           child: InkWell(
                                             onTap: (){
                                               Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                                 postData: homeProvider.internationalData,
                                                 index: index,
                                               )));
                                             },
                                             child: TrendingNewsWidget(index: index, postData:  homeProvider.internationalData),
                                           ),
                                         );
                                       },
                                     ),

                                   ],
                                  )
                                   :
                                   homeProvider.postsData.isEmpty && homeProvider.postLoading == false
                                   ? SizedBox(
                                       height: MediaQuery.of(context).size.height/1.3,
                                       child: Center(child: Text("No News Found",textAlign: TextAlign.center,)))
                                   : ListView.builder(
                                    itemCount: 3,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context,index){
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
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             CustomShimmerContainer(height: 20,width: 50,),
                                             const SizedBox(width: 10),
                                             CustomShimmerContainer(height: 20,width: 50,),
                                             const Spacer(),
                                             CustomShimmerContainer(height: 20,width: 50,),
                                           ],
                                         ),
                                         SizedBox(height: 10,),
                                       ],
                                     );
                                  },
                                )
                            ],)
                 );
               }
             ),
           ),
      )
    );
  }
}
