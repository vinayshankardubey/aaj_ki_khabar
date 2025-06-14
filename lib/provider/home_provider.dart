import 'package:flutter/cupertino.dart';

import '../network/api/api_servies.dart';

class HomeProvider extends ChangeNotifier{
  bool _isLoading  = false;
  bool _postLoading  = false;
  String selectedCategory = 'All';
  List<dynamic> filterList = [];

  List<dynamic> _postsData = [];
  List<dynamic> _otherStateData = [];
  List<dynamic> _allCategoryData = [];
  List<dynamic> _singleCategoryData = [];
  List<dynamic> _internationalData = [];
  List<dynamic> _topOfTheWeekData = [];

  List<dynamic> get postsData => _postsData;
  List<dynamic> get categoryData => _allCategoryData;
  List<dynamic> get singleCategoryData => _singleCategoryData;
  List<dynamic> get otherStateData => _otherStateData;
  List<dynamic> get internationalData => _internationalData;
  List<dynamic> get topOfTheWeekData => _topOfTheWeekData;

  bool get isLoading => _isLoading;
  bool get postLoading => _postLoading;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }



  Future<void> fetchPostsData({
    int page = 1, int perPage =10,
    int? categoryId,
   })async{
    _postLoading = true;
     notifyListeners();
     if(categoryId == null){
       _postsData = await ApiServices.fetchPostData(page: page, perPage: perPage);
     }else{
       _singleCategoryData = await ApiServices.fetchPostData(page: 1, perPage: 10,categoryId: categoryId);
     }
    _postLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllCategoryData()async{
    _isLoading = true;
     notifyListeners();
    _allCategoryData = await ApiServices.fetchAllCategoryData();
     filterList = _allCategoryData;
    _isLoading = false;
    notifyListeners();
  }
  Future<void> fetchOtherStateData()async{
    _isLoading = true;
     notifyListeners();
    _otherStateData = await ApiServices.fetchCategoryData(page: 1, perPage: 10,categoryId: _allCategoryData[_allCategoryData.length - 1]["id"]);
    _isLoading = false;
    notifyListeners();
  }
  Future<void> fetchTopOfTheWeekData()async{
    _isLoading = true;
    notifyListeners();
    _topOfTheWeekData = await ApiServices.fetchTopOfTheWeek();
    _isLoading = false;
    notifyListeners();
  }
  Future<void> fetchInternationalData()async{
    _isLoading = true;
    notifyListeners();
    _internationalData = await ApiServices.fetchCategoryData(page: 1, perPage: 10,categoryId: _allCategoryData[_allCategoryData.length - 2]["id"]);
    _isLoading = false;
    notifyListeners();
  }


}