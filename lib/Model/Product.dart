class Product {
  final String? id;
  final String? name;
  final String? description;
  final String? price;
  final List<String>? img;
  final List<String>? size;
  final List<String>? color;

  final String? loaisp;
  final String? like;

  Product({required this.id, required this.name, required this.description, required this.price, required this.img, required this.size,required this.color, required this.loaisp,required this.like});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      description: json["des"],
      price: json["price"],
      img: List<String>.from(json["img"] ?? []),
      size: List<String>.from(json["size"] ?? []),
      color: List<String>.from(json["color"] ?? []),
      loaisp: json["loaisp"],
      like: json["like"],
    );
  }
  
}

class ProductWithQuantity {
  final Product product;
  final int quantity;

  ProductWithQuantity({required this.product, required this.quantity});
}
