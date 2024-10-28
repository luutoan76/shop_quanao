
class User {
  final String? id;
  final String? username;
  final String? pass;
  final String? phonenum;
  final String? address;
  final String? img;
  final String? dateBirth;
  final String? email;

  User({required this.id, required this.username, required this.pass, required this.phonenum, required this.img, required this.address, required this.dateBirth, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["username"],
      pass: json["pass"],
      phonenum: json["phonenum"],
      address: json["address"],
      img: json["img"],
      dateBirth: json["dateBirth"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'username': username,
      'pass': pass,
      'phonenum': phonenum,
      'address': address,
      'img': img,
      'dateBirth': dateBirth,
      'email': email,
    };
  }
}