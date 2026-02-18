import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nb_utils/nb_utils.dart';

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
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "Trending".toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  HtmlConversion.parseHtmlString(post["title"]["rendered"]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "${post["_embedded"]["wp:term"]?[0]?[0]?["name"] ?? "News"}",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.circle, size: 4, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('dd MMM yyyy').format(DateTime.parse(post['date'])),
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
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
