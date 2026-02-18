import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:nb_utils/nb_utils.dart';

import '../utils/app_colors.dart';
import '../utils/Common.dart' as HtmlConversion;

class WeekNewsItemWidget extends StatelessWidget {
  final List<dynamic> weekData;
  final int index;
  const WeekNewsItemWidget({
    super.key, required this.weekData,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    final post = weekData[index];
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 90,
              width: 90,
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
                        child: Icon(Icons.error, size: 20, color: AppColors.primaryColor),
                      ),
                    )
                  : Container(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      child: Icon(Icons.image, size: 20, color: AppColors.primaryColor),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  HtmlConversion.parseHtmlString(post["title"]["rendered"]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: boldTextStyle(size: 16, height: 1.2),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "${post["_embedded"]["wp:term"]?[0]?[0]?["name"] ?? "News"}".toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.access_time, size: 12, color: context.iconColor.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM').format(DateTime.parse(post['date'])),
                      style: secondaryTextStyle(size: 11),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
