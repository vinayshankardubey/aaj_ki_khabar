import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/CategoryItemWidget.dart';
import '../models/CategoryData.dart';
import '../network/RestApis.dart';
import '../screens/SubCategoryScreen.dart';
import '../shimmer/TopicShimmer.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class CategoryFragment extends StatefulWidget {
  static String tag = '/CategoryScreen';

  @override
  CategoryFragmentState createState() => CategoryFragmentState();
}

class CategoryFragmentState extends State<CategoryFragment> {
  List<CategoryData> getInitialData() {
    List<CategoryData> list = [];
    String s = getStringAsync(CATEGORY_DATA);

    if (s.isNotEmpty) {
      Iterable it = jsonDecode(s);
      list.addAll(it.map((e) => CategoryData.fromJson(e)).toList());
    }

    return list;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalization.translate('category'), style: boldTextStyle()),
          ],
        ).paddingSymmetric(vertical: 20, horizontal: 16),
        SingleChildScrollView(
          child: FutureBuilder<List<CategoryData>>(
            initialData: getStringAsync(CATEGORY_DATA).isEmpty ? null : getInitialData(),
            future: getCategories(),
            builder: (_, snap) {
              if (snap.hasData) {
                setValue(CATEGORY_DATA, jsonEncode(snap.data));

                return Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceEvenly,
                  children: snap.data!.map((data) {
                    return CategoryItemWidget(data, onTap: () {
                      SubCategoryScreen(data, snap.hasError).launch(context);
                    });
                  }).toList(),
                );
              }
              return snapWidgetHelper(snap, loadingWidget: TopicShimmer());
            },
          ),
        ).expand(),
      ],
    );
  }
}
