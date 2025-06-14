import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../components/AppWidgets.dart';
import '../components/PaginatedNewsWidget.dart';
import '../main.dart';
import '../models/CategoryData.dart';
import '../network/RestApis.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

class SubCategoryScreen extends StatefulWidget {
  static String tag = '/CategoryScreen';
  final CategoryData categoryData;
  final hasError;

  SubCategoryScreen(this.categoryData, this.hasError);

  @override
  SubCategoryScreenState createState() => SubCategoryScreenState();
}

class SubCategoryScreenState extends State<SubCategoryScreen> {
  int? categoryId = 0;
  int page = 1;

  List<CategoryData> categories = [];

  @override
  void initState() {
    super.initState();
    init();

    setDynamicStatusBarColor();
  }

  Future<void> init() async {
    afterBuildCreated((){
      appStore.setLoading(true);
    });

    getCategories(parent: widget.categoryData.catId).then((value) {
      appStore.setLoading(false);
      categories.addAll(value);

      categoryId = widget.categoryData.catId;

      setState(() {});
    }).catchError((e) {
      categoryId = -1;

      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !isIOS ? true : false,
      child: Scaffold(
        appBar: appBarWidget(widget.categoryData.name!, showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Container(
          height: context.height(),
          width: context.width(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              categoryId.validate() != 0
                  ? PaginatedNewsWidget(
                      {
                        if (categoryId == widget.categoryData.catId) 'category': categoryId,
                        if (categoryId != widget.categoryData.catId) 'subcategory': categoryId,
                        'filter': 'by_category',
                        'posts_per_page': postsPerPage,
                      },
                      topPadding: categories.isEmpty ? 0 : 70,
                      usePreFetch: false,
                    )
                  : SizedBox(),
              categories.isNotEmpty ?
              Container(
                height: categories.isEmpty ? 0 : 70,
                width: context.width(),
                color: context.scaffoldBackgroundColor,
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  padding: EdgeInsets.all(8),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    CategoryData data = categories[index];

                    return Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      margin: EdgeInsets.only(left: 12, right: 12, bottom: 8),
                      decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: data.catId == categoryId ? colorPrimary : context.cardColor,blurRadius: 1),
                      alignment: Alignment.center,
                      child: Text(data.name.validate(), style: boldTextStyle(color: data.catId == categoryId ? Colors.white : colorPrimary)),
                    ).onTap(() {
                      categoryId = data.catId;
                      appStore.setLoading(true);

                      setState(() {});
                    });
                  },
                ),
              ) :

              categories.isEmpty
                  ?  Observer(builder: (_) => Loader().visible(appStore.isLoading)): noDataWidget(context).visible(categories.isEmpty && !appStore.isLoading && categoryId == 0),
            ],
          ),
        ),
      ),
    );
  }
}
