import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../utils/Common.dart' as HtmlConversion;
import '../utils/app_images.dart';

class NewsItemDetailsWidget extends StatefulWidget {
  final int index;
  final List<dynamic> postData;

  const NewsItemDetailsWidget({
    Key? key,
    required this.index,
    required this.postData,
  }) : super(key: key);

  @override
  State<NewsItemDetailsWidget> createState() => _NewsItemDetailsWidgetState();
}

class _NewsItemDetailsWidgetState extends State<NewsItemDetailsWidget> {
 final PageController pageController = PageController();
 late int currentIndex ;
 @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.postData[currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,

        toolbarHeight: 64,
        title:  Image.asset(AppImages.appLogo,
          fit: BoxFit.fitHeight,
          width: 180,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.postData.length,
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                   currentIndex = index;
                  });
                },
               itemBuilder: (context,index){
                 return  SingleChildScrollView(
                   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // Title
                       Text(
                         HtmlConversion.parseHtmlString(post["title"]["rendered"]),
                         style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                       ),
                       SizedBox(height : 10),
                       Row(
                         children: [
                           Container(
                             decoration: BoxDecoration(
                               color: Colors.blue.shade50,
                               borderRadius: BorderRadius.circular(5),
                             ),
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                             child: Center(
                               child: Text(
                                 "${post["_embedded"]["wp:term"][0][0]["name"]}",
                                 textAlign: TextAlign.center,
                                 style: TextStyle(fontWeight: FontWeight.w500),
                               ),
                             ),
                           ),
                           const SizedBox(width: 20),
                           Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(post['date']))),
                           const SizedBox(width: 10),
                           // Text("by ${post["yoast_head_json"]['author']}", style: TextStyle(fontWeight: FontWeight.w500)),

                           const Spacer(),

                           const Padding(
                             padding: EdgeInsets.symmetric(horizontal: 10),
                             child: Icon(Icons.messenger_outline, color: Colors.red, size: 20),
                           ),
                           Text("",
                             // post["yoast_head_json"]['schema']["@graph"][0]["commentCount"]?? "0",
                             style: TextStyle(
                               fontWeight: FontWeight.w500,
                               color: Colors.red,
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 15),

                       // Image with Shimmer
                       SizedBox(
                           height: 200,
                           width: double.infinity,
                           child: CachedNetworkImage(
                             imageUrl: post["_embedded"]["wp:featuredmedia"][0]["source_url"],
                             width: double.infinity,
                             height: 250,
                             imageBuilder: (context, imageProvider) => Container(
                               decoration: BoxDecoration(
                                 image: DecorationImage(
                                   image: imageProvider,
                                   fit: BoxFit.cover,
                                 ),
                               ),
                             ),
                             placeholder: (context, url) =>
                                 Shimmer.fromColors(
                                   baseColor: Colors.grey.shade300,
                                   highlightColor: Colors.grey.shade100,
                                   child: Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(5),
                                       color: Colors.white,
                                     ),
                                     width: double.infinity,
                                   ),
                                 ),
                             errorWidget: (context, url, error) =>
                             const Icon(Icons.error),
                           )
                       ),
                       const SizedBox(height: 10),

                       // Description
                       Text(
                         HtmlConversion.parseHtmlString(post["content"]["rendered"]),
                         style: const TextStyle(fontSize: 16, height: 1.5),
                       ),

                     ],
                   ),
                 );
             }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){
                    if(currentIndex <= widget.postData.length-1 && currentIndex > 0){
                      pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  },
                  icon:  Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Text("Previous",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w600,),)
                    ],
                  ),
                ),
                IconButton(
                  onPressed: (){
                    if(currentIndex < widget.postData.length-1){
                      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    }
                  },
                  icon:  Row(
                    children: [
                       Text("Next",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w600,),),
                       Icon(Icons.arrow_forward_ios),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
