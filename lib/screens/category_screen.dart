import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import 'category_details_view_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isVisible = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchAllCategoryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.redColor,
          toolbarHeight: 64,
          title: Image.asset(AppImages.appLogo,
            fit: BoxFit.fitHeight,
            width: 180,
          ),

          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(Icons.search,
                  color: Colors.white,
                  size: 30,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return Column(
                    children: [
                      Visibility(
                        visible: isVisible,
                        child: Container(
                          color: AppColors.whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("What are You Looking For?",
                                  style: TextStyle(fontSize: 22.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),),
                                SizedBox(height: 10,),
                                TextFormField(
                                  onChanged: (String value) {

                                  },
                                  controller: searchController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Search",
                                      suffixIcon: Icon(
                                        Icons.search, color: AppColors.greenColor,),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      )
                                  ),
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                                          child: Image.asset(
                                            homeProvider.categoryImageList[index],
                                            fit: BoxFit.cover,
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
        ));
  }
}
