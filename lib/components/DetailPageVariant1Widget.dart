import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../models/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../screens/CommentListScreen.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';
import '../main.dart';
import 'AppWidgets.dart';
import 'BreakingNewsListWidget.dart';
import 'CommentTextWidget.dart';
import 'HtmlWidget.dart';

class DetailPageVariant1Widget extends StatefulWidget {
  static String tag = '/DetailPageVariant1Widget';

  final NewsData? newsData;
  final int? postView;
  final String? postContent;
  final List<NewsData>? relatedNews;
  final String? heroTag;

  DetailPageVariant1Widget(this.newsData, {this.postView, this.postContent, this.relatedNews, this.heroTag});

  @override
  _DetailPageVariant1WidgetState createState() => _DetailPageVariant1WidgetState();
}

class _DetailPageVariant1WidgetState extends State<DetailPageVariant1Widget> with SingleTickerProviderStateMixin {
  bool? isLike;
  int? count;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    isLike = widget.newsData!.is_like.validate();
    count = widget.newsData!.like_count;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();

    setDynamicStatusBarColorDetail(milliseconds: 400);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> likeDislike(int id) async {
    Map req = {'post_id': id};
    blogLikeDisLike(req: req).then((res) {
      setState(() {
        if (res.isLike == true) {
          count = count! + 1;
        } else {
          count = count! - 1;
        }
        isLike = res.isLike!;
      });
      toast(res.message);
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image (Edge to Edge)
            Stack(
              children: [
                Hero(
                  tag: widget.heroTag ?? widget.newsData!.iD.toString(),
                  child: cachedImage(
                    widget.newsData!.full_image.validate(),
                    height: 350,
                    fit: BoxFit.cover,
                    width: context.width(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 100,
                    width: context.width(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          context.scaffoldBackgroundColor,
                          context.scaffoldBackgroundColor.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.newsData!.category.validate().isNotEmpty 
                              ? widget.newsData!.category!.first.name.validate().toUpperCase() 
                              : 'NEWS',
                          style: boldTextStyle(size: 11, color: AppColors.primaryColor, letterSpacing: 1),
                        ),
                      ),
                      Text(
                        widget.newsData!.human_time_diff.validate().toUpperCase(),
                        style: secondaryTextStyle(size: 11),
                      ),
                    ],
                  ),
                  16.height,
                  
                  // Title
                  Text(
                    parseHtmlString(widget.newsData!.post_title.validate()),
                    style: boldTextStyle(size: 28, height: 1.2, letterSpacing: -0.5),
                  ),
                  20.height,
                  
                  // Author Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                        child: widget.newsData!.post_author_image.validate().isNotEmpty
                            ? cachedImage(widget.newsData!.post_author_image.validate(), height: 30, width: 30, fit: BoxFit.cover).cornerRadiusWithClipRRect(15)
                            : const Icon(Icons.person, size: 18, color: AppColors.primaryColor),
                      ),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.newsData!.post_author_name.validate(), style: boldTextStyle(size: 14)),
                          Text(getArticleReadTime(context, widget.newsData!.post_content.validate()), style: secondaryTextStyle(size: 11)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => likeDislike(widget.newsData!.iD.validate()),
                        icon: Icon(isLike == true ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      ),
                      Text('${count.validate()}', style: primaryTextStyle(size: 16)),
                    ],
                  ),
                  24.height,
                  const Divider(),
                  16.height,
                  
                  // Detailed Content
                  HtmlWidget(postContent: widget.postContent),
                  
                  32.height,
                  // Interaction Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextIcon(
                        prefix: Icon(FontAwesome.eye, size: 14, color: textSecondaryColor),
                        text: "${widget.postView.validate()} Views",
                        textStyle: secondaryTextStyle(),
                      ),
                    ],
                  ),
                  
                  // Related News Section
                  if (widget.relatedNews.validate().isNotEmpty) ...[
                    40.height,
                    Text(
                      appLocalization.translate('related_news'),
                      style: boldTextStyle(size: 20),
                    ),
                    16.height,
                    BreakingNewsListWidget(widget.relatedNews.validate()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
