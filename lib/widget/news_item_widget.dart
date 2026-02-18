import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_uttarpradesh/utils/app_images.dart';
import 'package:live_uttarpradesh/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/html_coversion.dart';

class NewsItemWidget extends StatefulWidget {
  final int index;
  final List<dynamic> postData;

  const NewsItemWidget({
    Key? key,
    required this.postData,
    required this.index,
  }) : super(key: key);

  @override
  State<NewsItemWidget> createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {

  @override
  Widget build(BuildContext context) {
    final post = widget.postData[widget.index];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: Hero(
                tag: "news_image_${post['id']}",
                child: post["_embedded"]["wp:featuredmedia"] != null && post["_embedded"]["wp:featuredmedia"][0]["source_url"] != null
                    ? CachedNetworkImage(
                        imageUrl: post["_embedded"]["wp:featuredmedia"][0]["source_url"],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primaryColor.withOpacity(0.05),
                          child: Center(child: Image.asset(AppImages.appLogo, width: 100)),
                        ),
                      )
                    : Container(
                        color: AppColors.primaryColor.withOpacity(0.05),
                        child: Center(child: Image.asset(AppImages.appLogo, width: 100)),
                      ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Date Row
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Text(
                        "${post["_embedded"]["wp:term"]?[0]?[0]?["name"] ?? "News"}".toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 14, color: context.iconColor.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(DateTime.parse(post['date'])),
                      style: secondaryTextStyle(size: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  HtmlConversion.parseHtmlString(post["title"]["rendered"]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: boldTextStyle(size: 20, height: 1.2),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  HtmlConversion.extractReadableText(post["content"]["rendered"]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: secondaryTextStyle(size: 14, height: 1.4),
                ),
                const SizedBox(height: 16),


                const SizedBox(height: 12),

                // Author Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                      child: Icon(Icons.person, size: 14, color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "By ${post["_embedded"]["author"]?[0]["name"] ?? "Admin"}",
                        style: boldTextStyle(size: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
