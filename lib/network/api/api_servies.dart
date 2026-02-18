import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utils/Constants.dart';

class ApiServices{

  static Future<List<dynamic>> fetchPostData({
     required int page ,
     required int perPage ,
     int? categoryId ,
   }) async{
    try{
      final response = await http.get(
          Uri.parse('${mBaseUrl}posts?_embed&per_page=$perPage${categoryId!=null?'&categories=$categoryId':''}'));
      if (response.statusCode == 200) {
        print("post response is ${response.body}");
        return json.decode(response.body);
      } else {
        return [];
      }
    }catch (ex){
       print("Exception occured$ex");
       return [];
    }
  }

  static Future<List<dynamic>> fetchAllCategoryData()async{
    try{
      final response = await http.get(Uri.parse('${mBaseUrl}categories?per_page=100'));
      if (response.statusCode == 200) {
        // Decode and return the list of posts
        print(" category response is ${response.body}");
        return json.decode(response.body);
      } else {
        return [];
      }
    }catch (ex){
      print("Exception occured$ex");
      return [];
    }
  }

  static Future<List<dynamic>> fetchTopOfTheWeek({int perPage=10 ,})async{
    try{
      DateTime now = DateTime.now();
      String before = DateTime(now.year, now.month, now.day).toIso8601String();
      DateTime sevenDaysAgo = DateTime(now.year, now.month, now.day).subtract(Duration(days: 7));
      String after = sevenDaysAgo.toIso8601String();
      final response = await http.get(Uri.parse('${mBaseUrl}posts?_embed&per_page=$perPage&after=$after&before=$before'));
      if (response.statusCode == 200) {
        print("top of week News ${response.body}");
        return json.decode(response.body);
      } else {
        return [];
      }
    }catch (ex){
      print("Exception occured$ex");
      return [];
    }
  }

  static Future<List<dynamic>> fetchCategoryData({
    required int page ,
    required int perPage ,
    int? categoryId ,
  }) async{
    try{

      print(" other state data ${mBaseUrl}posts?_embed&per_page=$perPage${categoryId!=null?'&categories=$categoryId':''}");
      final response = await http.get(
          Uri.parse('${mBaseUrl}posts?_embed&per_page=$perPage${categoryId!=null?'&categories=$categoryId':''}'));
      if (response.statusCode == 200) {
        print("Other state data response is ${response.body}");
        return json.decode(response.body);
      } else {
        return [];
      }
    }catch (ex){
      print("Exception occured$ex");
      return [];
    }
  }

  static Future<List<dynamic>> searchPosts({required String query}) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await http.get(
        Uri.parse('${mBaseUrl}posts?_embed&search=$encodedQuery&per_page=20'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (ex) {
      print("Search exception: $ex");
      return [];
    }
  }
}