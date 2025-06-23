import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors.dart';
import '../utils/Common.dart' as HtmlConversion;
import '../utils/app_images.dart';

class TrendingNewsWidget extends StatefulWidget {
  final int index;
  final List<dynamic> postData;
  const TrendingNewsWidget({
    super.key,
    required this.index,
    required this.postData
  });

  @override
  State<TrendingNewsWidget> createState() => _TrendingNewsWidgetState();
}

class _TrendingNewsWidgetState extends State<TrendingNewsWidget> {
  @override
  Widget build(BuildContext context) {
    final post = widget.postData[widget.index];
    return Stack(
      children: [

        Container(
            height: 250,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child:  post["_embedded"]["wp:featuredmedia"]!=null && post["_embedded"]["wp:featuredmedia"][0]["source_url"]!=null
            ? CachedNetworkImage(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(AppImages.appLogo),
                  ),
            )
            : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(AppImages.appLogo),
            ),
            )
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.blackColor.withOpacity(.3)
            )
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          left:20,
          bottom: 0,
          child: Text(
            HtmlConversion.parseHtmlString(post["title"]["rendered"]),
            maxLines: 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   left: 10,
        //   right: 10,
        //   child: Row(
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           color: Colors.blue.shade50,
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        //         child: Center(
        //           child: Text(
        //             post["_embedded"]["wp:term"][0][0]["name"]?? "",
        //             textAlign: TextAlign.center,
        //             style: TextStyle(fontWeight: FontWeight.w500),
        //           ),
        //         ),
        //       ),
        //       SizedBox(width: 10.0,),
        //       Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(post['date'])) ?? "",style: TextStyle(color: Colors.white)),
        //       SizedBox(width: 10.0,),
        //       Text("by ${post["_embedded"]["author"][0]["name"]}",
        //           style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
        //       Spacer(),
        //       Icon(Icons.messenger_outline, color: Colors.white, size: 20),
        //       SizedBox(width: 5.0,),
        //       Padding(
        //         padding: const EdgeInsets.only(bottom: 4.0),
        //         child: Text("",
        //           // post["yoast_head_json"]['schema']["@graph"][0]["commentCount"]?? "0",
        //           style: TextStyle(
        //             fontWeight: FontWeight.w500,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

      ],
    );
  }
}
