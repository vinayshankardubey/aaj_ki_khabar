import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/home_provider.dart';
import '../utils/Colors.dart';
import '../widget/custom_shimmer_container.dart';
import '../widget/news_item_details_widget.dart';
import '../widget/news_item_widget.dart';
import '../widget/trending_news_widget.dart';
import '../widget/week_news_item_widget.dart';

class CategoryDetailsViewScreen extends StatefulWidget {
  final int categoryId;

  const CategoryDetailsViewScreen({
    super.key,
    required this.categoryId
  });

  @override
  State<CategoryDetailsViewScreen> createState() => _CategoryDetailsViewScreenState();
}

class _CategoryDetailsViewScreenState extends State<CategoryDetailsViewScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context,listen: false).fetchPostsData(categoryId: widget.categoryId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          toolbarHeight: 64,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: Image.asset("assets/images/app_image.png",
            fit: BoxFit.fitHeight,
            height: 50,
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Consumer<HomeProvider>(
              builder: (context,homeProvider,child) {
                return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child:
                    homeProvider.singleCategoryData.isNotEmpty && homeProvider.isLoading == false
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                                shrinkWrap: true,
                                itemCount: homeProvider.singleCategoryData.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:(context,index){
                                  print("length is ${homeProvider.singleCategoryData.length}");
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                        postData: homeProvider.singleCategoryData,
                                        index: index,

                                      )));
                                    },
                                    child: NewsItemWidget(
                                     index: index,
                                      postData: homeProvider.singleCategoryData,
                                    ),
                                  );
                                } ),


                        //Top of the Week
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
                        Text("Trending Now",style:TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        ListView.builder(
                          itemCount: homeProvider.topOfTheWeekData.length> 5 ? 4 : homeProvider.topOfTheWeekData.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index1) {
                            int index = index1;
                            if(homeProvider.topOfTheWeekData.length>5){
                              index =  index1 +5;
                            }else{
                              index = index1;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsItemDetailsWidget(
                                    postData: homeProvider.topOfTheWeekData,
                                    index: index,
                                  )));
                                },
                                child: TrendingNewsWidget(index: index, postData:  homeProvider.topOfTheWeekData),
                              ),
                            );
                          },
                        ),

                      ],)
                   :
                    homeProvider.singleCategoryData.isEmpty && homeProvider.postLoading == false
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
                      );},
                    )
                );
              }
          ),
        )
    );
  }
}
