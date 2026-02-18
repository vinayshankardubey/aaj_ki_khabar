import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../components/HtmlWidget.dart';
import '../utils/Common.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/html_coversion.dart';

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
  late PageController pageController;
  late int currentIndex;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    pageController = PageController(initialPage: widget.index);
    _currentPage = widget.index.toDouble();

    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          AppImages.appLogo,
          fit: BoxFit.fitHeight,
          width: 80,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.postData.length,
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final post = widget.postData[index];
          
          // Animation calculations
          double value = (index - _currentPage).abs();
          double opacity = (1 - value).clamp(0.0, 1.0);
          double scale = (1 - (value * 0.1)).clamp(0.8, 1.0);

          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: _buildNewsContent(post),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildNewsContent(dynamic post) {
    String imageUrl = "";
    try {
      imageUrl = post["_embedded"]["wp:featuredmedia"][0]["source_url"] ?? "";
    } catch (e) {}

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Tag
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "${post["_embedded"]["wp:term"]?[0]?[0]?["name"] ?? "News"}".toUpperCase(),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Title
          Text(
            HtmlConversion.parseHtmlString(post["title"]["rendered"]),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 15),
          // Author & Date
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 14, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Text(
                "By ${post["_embedded"]?['author']?[0]?["name"] ?? "Admin"}",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 15),
              const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.parse(post['date'])),
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: "news_image_${post['id']}",
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(color: Colors.white, height: 250),
                      ),
                      errorWidget: (context, url, error) => Image.asset(AppImages.appLogo),
                    )
                  : Image.asset(AppImages.appLogo, height: 250, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 25),
          // Content Label
          const Divider(),
          const SizedBox(height: 10),
          // Detailed Description
          HtmlWidget(postContent: post["content"]["rendered"]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(
              label: "Previous",
              icon: Icons.arrow_back_ios_new,
              isEnabled: currentIndex > 0,
              onTap: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
            // Page Indicator
            Text(
              "${currentIndex + 1} / ${widget.postData.length}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            _navButton(
              label: "Next",
              icon: Icons.arrow_forward_ios,
              isEnabled: currentIndex < widget.postData.length - 1,
              isRight: true,
              onTap: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
    bool isRight = false,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.3,
        child: Row(
          children: [
            if (!isRight) Icon(icon, size: 16),
            if (!isRight) const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (isRight) const SizedBox(width: 8),
            if (isRight) Icon(icon, size: 16),
          ],
        ),
      ),
    );
  }
}
