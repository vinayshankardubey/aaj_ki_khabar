import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/home_provider.dart';
import '../utils/Common.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'category_details_view_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setDynamicStatusBarColor(color: AppColors.redColor);
        return true;
      },
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            title: Image.asset(
              AppImages.appLogo,
              fit: BoxFit.fitHeight,
              width: 80,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  LiveStream().emit(switchLiveTvTab, true);
                },
                icon: Icon(Icons.live_tv, color: Colors.white, size: 26),
                tooltip: "Live TV",
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  return Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: homeProvider.filterList.isNotEmpty
                                ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: homeProvider.filterList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.2,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    homeProvider.singleCategoryData = [];
                                    homeProvider.update();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryDetailsViewScreen(
                                          categoryId: homeProvider.filterList[index]["id"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Background Image
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              imageUrl: homeProvider.filterList[index]["category_image"] ?? "",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor: Colors.grey.shade100,
                                                child: Container(color: Colors.white),
                                              ),
                                              errorWidget: (context, url, error) => Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: Image.asset(
                                                  AppImages.appLogo,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Dark overlay
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.black.withOpacity(0.25),
                                            ),
                                          ),
                                        ),

                                        // Centered Title Text
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              homeProvider.filterList[index]["name"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black45,
                                                    offset: Offset(0, 1),
                                                    blurRadius: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )

                                : Text("Category not found", style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            )
                        )
                      ]
                  );
                }
            ),
          )),
    );
  }
}
