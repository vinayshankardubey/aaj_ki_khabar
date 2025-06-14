import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';
import '../utils/Colors.dart';
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
        appBar: AppBar(
          backgroundColor: colorPrimary,
          toolbarHeight: 64,
          title: Image.asset("assets/images/app_image.png",
            fit: BoxFit.fitHeight,
            height: 50,
          ),
          centerTitle: true,
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
                          color: colorPrimary,
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
                                        Icons.search, color: colorPrimary,),
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
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.5,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {

                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryDetailsViewScreen(categoryId: homeProvider.filterList[index]["id"],)));
                                  },
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            16)),
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.blueGrey.shade50,
                                      ),
                                      child: Center(
                                        child: Text(
                                          homeProvider
                                              .filterList[index]["name"],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: colorPrimary),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
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
