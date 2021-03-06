import 'package:aaj_ki_khabar/Controller/post_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PostDetailScreen extends StatelessWidget {
  int postNumber;

  PostDetailScreen({Key key, this.postNumber}) : super(key: key);

  final PostController postController = Get.find(tag: "postController");

  @override
  Widget build(BuildContext context) {


    final sSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),

                child: Container(
                height: sSize.height * 0.5,
                width: sSize.width,
                child: CachedNetworkImage(
                 imageUrl :postController
                      .postList[postNumber].embedded.wpFeaturedmedia[0].link
                      .toString(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: sSize.width * 0.2,
                ),
            ),
              ),
              Container(
                height: sSize.height * 0.5,
                width: sSize.width,
                decoration: BoxDecoration(
                ),
              ),
              AppBar(backgroundColor: Colors.transparent,elevation: 0,),
      ]
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(postController
                    .postList[postNumber].title.rendered
                    .toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text( postController
                    .postList[postNumber].content.rendered
                    .toString(),style: TextStyle(fontSize: 20),),
              )
            ],

          )
        ],
      ),
    );
  }
}
