class LikeResponse {
  bool? isLike;
  String? message;

  LikeResponse({this.isLike, this.message});

  LikeResponse.fromJson(Map<String, dynamic> json) {
    isLike = json['is_like'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_like'] = this.isLike;
    data['message'] = this.message;
    return data;
  }
}
