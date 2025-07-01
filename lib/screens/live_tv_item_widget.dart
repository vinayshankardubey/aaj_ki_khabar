import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors.dart';
import '../utils/Common.dart' as HtmlConversion;

class LiveTvItemWidget extends StatelessWidget {
  final List<dynamic> liveTvData;
  final int index;
  const LiveTvItemWidget({
    super.key, required this.liveTvData,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    final post = liveTvData[index];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height:100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: post["_embedded"]["wp:featuredmedia"][0]["source_url"],
                  width: 100,
                  height: 100,
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
                          width: 100,
                        ),
                      ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              )
          ),

          SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Text(
                  HtmlConversion.parseHtmlString(post["title"]["rendered"]),
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Center(
                        child:Text(
                          post["_embedded"]["wp:term"][0][0]["name"]?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(post['date'])) ?? "", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                    SizedBox(width: 10.0),

                  ],
                ),
              ],
            ),
          ),
          InkWell(
             onTap: (){
               final videoUrl = post["link"];
               try{
                   Share.share(videoUrl);
                } catch (ex){
                 debugPrint("Exception occurred while sharing $ex");
               }
             },
              child: Icon(Icons.more_vert)
            ),

        ],
      ),
    );
  }
}
