import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/Colors.dart';
import '../utils/html_coversion.dart';

class NewsItemWidget extends StatefulWidget {
  final int index;
  final List<dynamic> postData;

  const NewsItemWidget({
    Key? key,
    required this.postData,
    required this.index,
  }) : super(key: key);

  @override
  State<NewsItemWidget> createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {

  @override
  Widget build(BuildContext context) {
    final post = widget.postData[widget.index];
    print("total length ${post["_embedded"]["wp:term"][0]}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured Image with shimmer
        SizedBox(
          height: 200,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: post["_embedded"]["wp:featuredmedia"][0]["source_url"],
            width: double.infinity,
            height: 250,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                width: double.infinity,
              ),
            ),
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/app_image.png"),
          )
        ),

        const SizedBox(height: 20),

        // Title
        Text(
          HtmlConversion.parseHtmlString(post["title"]["rendered"]),
          maxLines: 3,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),

        const SizedBox(height: 15),

        // Description
        Text(
          HtmlConversion.parseHtmlString(post["content"]["rendered"]),
          maxLines: 5,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15.5,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 15),

        const Divider(height: 1, color: Colors.grey, thickness: 1),
        const SizedBox(height: 15),

        // Bottom info row
        Row(

          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Center(
                child: Text(
                  post["_embedded"]["wp:term"][0][0]["name"]?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(width: 10.0,),
            Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(post['date'])) ?? ""),
            SizedBox(width: 10.0,),
            Text("by ${post["yoast_head_json"]['author']}", style: TextStyle(fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.messenger_outline, color: colorPrimary, size: 20),
            SizedBox(width: 5.0,),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                post["yoast_head_json"]['schema']["@graph"][0]["commentCount"]?? "0",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
