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

class _DetailPageVariant1WidgetState extends State<DetailPageVariant1Widget> {
  bool? isLike;

  int? count;

  @override
  void initState() {
    super.initState();

    print("This Is Detail page Varient Widget");
    isLike = widget.newsData!.is_like.validate();
    count = widget.newsData!.like_count;
    setDynamicStatusBarColorDetail(milliseconds: 400);
  }

  Future<void> likeDislike(int id) async {
    Map req = {'post_id': id};
    blogLikeDisLike(req: req).then((res) {
      if (res.isLike == true) {
        count = count! + 1;
      } else {
        count = count! - 1;
      }
      isLike = res.isLike!;
      toast(res.message);
      setState(() {});
    }).catchError((error) {
      appStore.isLoading = false;
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIOS,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 32, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.newsData!.category.validate().isNotEmpty)
              Text(
                widget.newsData!.category!.first.name.validate().toUpperCase(),
                style: boldTextStyle(size: 12, color: colorPrimary, letterSpacing: 1.2),
              ).paddingSymmetric(horizontal: 16),
            16.height,
            Text(
              parseHtmlString(widget.newsData!.post_title.validate()),
              style: boldTextStyle(size: 32, fontFamily: titleFont(), letterSpacing: 0.5),
            ).paddingSymmetric(horizontal: 16),
            16.height,
            Row(
              children: [
                Text(widget.newsData!.human_time_diff.validate().toUpperCase(), style: secondaryTextStyle(size: 12)),
                4.width,
                Text('- ', style: secondaryTextStyle()),
                Text(getArticleReadTime(context, widget.newsData!.post_content.validate()), style: secondaryTextStyle(size: 12)).expand(),
                IconButton(
                  onPressed: () {
                    //
                    likeDislike(widget.newsData!.iD.validate());
                    setState(() {});
                  },
                  icon: Icon(isLike == true ? Icons.thumb_up : Icons.thumb_up_alt_outlined),
                ),
                Text('${count.validate()}', style: primaryTextStyle(size: 18))
              ],
            ).paddingSymmetric(horizontal: 16),
            24.height,
            Container(
              decoration: boxDecorationRoundedWithShadow(
                8,
                backgroundColor: context.cardColor,
                shadowColor: appStore.isDarkMode ? Colors.grey.shade700 : Colors.black.withOpacity(0.6),
                offset: Offset(0.5, 0.5),
                blurRadius: defaultBlurRadius,
              ),
              child: cachedImage(
                widget.newsData!.full_image.validate(),
                height: 180,
                fit: BoxFit.cover,
                width: context.width(),
                alignment: Alignment.topCenter,
              ).cornerRadiusWithClipRRect(8),
            ).paddingSymmetric(horizontal: 16),
            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextIcon(
                  onTap: () async {
                    print("Detail Page Varien tTime 1");

                    await CommentListScreen(widget.newsData!.iD).launch(context);
                    setDynamicStatusBarColorDetail(milliseconds: 400);

                    setState(() {

                    });

                    print("==========================");
                    print("After Refresh Is Comming Back");
                  },
                  prefix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesome.commenting_o, size: 16, color: textSecondaryColor),
                      4.width,
                      if (widget.newsData!.no_of_comments_text.validate(value: '0').splitBefore(' ') == 'No')
                        CommentTextWidget(text: "Add Comments")
                      else
                        CommentTextWidget(text: widget.newsData!.no_of_comments_text.validate(value: '0').splitBefore(' ')),
                    ],
                  ),
                  text: '',
                ),
                TextIcon(
                  prefix: Icon(FontAwesome.eye, size: 16, color: textSecondaryColor),
                  text: widget.postView.validate().toString(),
                  textStyle: secondaryTextStyle(),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            8.height,
            // HtmlWidget(postContent: widget.postContent).paddingSymmetric(horizontal: 8),
            30.height,
            Text('Authored by', style: secondaryTextStyle(letterSpacing: 1.2)).visible(widget.newsData!.post_author_name.validate().isNotEmpty).paddingSymmetric(horizontal: 16),
            Container(
              decoration: boxDecorationRoundedWithShadow(8, blurRadius: 0, backgroundColor: context.cardColor),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.newsData!.post_author_image.validate().isNotEmpty
                      ? cachedImage(widget.newsData!.post_author_image.validate(), height: 76, width: 76, fit: BoxFit.cover).cornerRadiusWithClipRRect(35)
                      : Image.asset('assets/profile.png', height: 76, width: 76, fit: BoxFit.cover).cornerRadiusWithClipRRect(38),
                  8.height,
                  Text('${widget.newsData!.post_author_name.validate()}', style: boldTextStyle(letterSpacing: 1.2)).visible(widget.newsData!.post_author_name.validate().isNotEmpty),
                ],
              ),
            ).visible(widget.newsData!.post_author_name.validate().isNotEmpty).paddingSymmetric(horizontal: 16),
            AppButton(
              text: appLocalization.translate('view_Comments'),
              color: colorPrimary,
              textStyle: boldTextStyle(color: white),
              onTap: () async {
                print("Detail Page Varien tTime view Comments");


              await CommentListScreen(widget.newsData!.iD).launch(context);

                setDynamicStatusBarColorDetail(milliseconds: 400);
              },
              width: context.width(),
            ).paddingSymmetric(horizontal: 16).visible(widget.newsData!.comment_count.validate().isNotEmpty),
            8.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  margin: EdgeInsets.only(left: 16, top: 32, bottom: 8),
                  decoration: BoxDecoration(color: colorPrimary, borderRadius: radius(defaultRadius)),
                  child: Text(appLocalization.translate('related_news'), style: boldTextStyle(size: 12, color: Colors.white, letterSpacing: 1.5)),
                ),
                BreakingNewsListWidget(widget.relatedNews.validate()),
              ],
            ).visible(widget.relatedNews.validate().isNotEmpty),
          ],
        ),
      ),
    );
  }
}
