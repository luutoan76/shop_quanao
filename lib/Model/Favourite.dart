class Favourite {
  final String? id;
  final String? idPro;
  final String? name;
  final String? price;
  final String img;
  final String? isLiked;
  final String? username;

  Favourite({required this.id, required this.idPro, required this.name, required this.price, required this.img, required this.isLiked, required this.username});

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json["id"],
      idPro: json["idPro"],
      name: json["name"],
      price: json["price"],
      img: json["img"],
      isLiked: json["isLiked"],
      username: json["username"],
    );
  }

  
}
