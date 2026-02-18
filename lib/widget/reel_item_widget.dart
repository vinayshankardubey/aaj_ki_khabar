import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'news_item_details_widget.dart';
import '../utils/app_colors.dart';
import '../utils/Common.dart' as HtmlConversion;

class ReelItemWidget extends StatelessWidget {
  final dynamic post;

  const ReelItemWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    String imageUrl = "";
    try {
      imageUrl = post["_embedded"]["wp:featuredmedia"][0]["source_url"] ?? "";
    } catch (e) {
      imageUrl = "";
    }

    return GestureDetector(
      onTap: () {
        // Handle tap if needed
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Caching Background Image
            if (imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                memCacheHeight: 1200, // For performance
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white24)),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: Colors.white24)),
              ),

            // Bottom-up Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0, 0.4, 0.7, 1],
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),

            // Info Section (Left)
            Positioned(
              left: 15,
              right: 80,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category with glassmorphism feel
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      post["_embedded"]?["wp:term"]?[0]?[0]?["name"] ?? "NEWS",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    HtmlConversion.parseHtmlString(post["title"]["rendered"]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Metadata
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM yyyy').format(DateTime.parse(post['date'])),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.alternate_email, color: Colors.white70, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        post["_embedded"]?['author']?[0]?["name"] ?? "Admin",
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Interaction Bar (Right)
            Positioned(
              right: 15,
              bottom: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: "Share",
                    onTap: () => Share.share(post["link"]),
                  ),
                  const SizedBox(height: 25),
                  _buildActionButton(
                    icon: Icons.remove_red_eye_outlined,
                    label: "Read",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsItemDetailsWidget(
                            postData: [post],
                            index: 0,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
