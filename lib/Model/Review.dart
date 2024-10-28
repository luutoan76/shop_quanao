
class Review{
  final String? id;
  final String? nameUser;
  final String? review;
  final String? idPro;
  final String? like;
  final String? avatar;
  Review({required this.id, required this.nameUser , required this.review, required this.idPro, required this.like, required this.avatar});
  factory Review.fromJson(Map<String, dynamic> json){
    return Review(id: json["id"], nameUser: json["nameUser"], review: json["review"], idPro: json["idPro"], like: json["like"], avatar: json["avatar"]);
  }
}