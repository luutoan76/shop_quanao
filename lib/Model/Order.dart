
class Order {
  final String? id;
  final String? dayCreate;
  final String? total;
  final List<OrderItem>? orderItem;
  final String? address;
  final String? username;
  final String? status;
  
  Order({required this.id, required this.dayCreate, required this.total, required this.orderItem, required this.address, required this.username, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['orderItem'] as List;
    List<OrderItem> orderItemList = list.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: json["id"],
      dayCreate: json["dayCreate"],
      total: json["total"],
      orderItem: orderItemList,
      address: json["address"],
      username: json["username"],
      status: json["status"],
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayCreate': dayCreate,
      'total': total,
      'orderItem': orderItem,
      'address': address,
      'username': username,
      'status': status,
    };
  }
}


class OrderItem {
  final String idPro;
  final String namePro;
  final String price;
  final String img;
  final String quantity;
  final String color;
  final String size;

  OrderItem({
    required this.idPro,
    required this.namePro,
    required this.price,
    required this.img,
    required this.quantity,
    required this.color,
    required this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      idPro: json['idPro'],
      namePro: json['namePro'],
      price: json['price'],
      img: json['img'],
      quantity: json['quantity'],
      color: json['color'],
      size: json['size'],
    );
  }
}