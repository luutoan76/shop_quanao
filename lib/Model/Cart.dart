import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Cart{
  final String id;
  final String name;
  final String imageUrl;
  final String price; 
  final String color;
  final String size;  
  int quantity; 

  Cart({required this.id , required this.name, required this.price, required this.imageUrl, this.quantity = 1, required this.color, required this.size});
  double get totalPrice => double.parse(price) * quantity;

  
}


class Cartprovider with ChangeNotifier{
  final List<Cart> _items = [];

  List<Cart> get items => _items;

  void addItem(Cart item) {
    final existingItemIndex = _items.indexWhere((i) => i.id == item.id);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  double get TotalPrice{
    return _items.fold(
      0.0,
      (previousValue, item) => previousValue + double.parse(item.price) * item.quantity,
    );
  } 

  void increaseQuantity(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      if (_items[itemIndex].quantity > 1) {
        _items[itemIndex].quantity -= 1;
      } else {
        _items.removeAt(itemIndex);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }


  Future<void> loadCartData(BuildContext context) async {
    final userId = await _getUserId();
    final url = 'http://10.0.2.2:5125/api/Cart/byNameUser/$userId';
    try{
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final data = jsonDecode(response.body) as Map<String , dynamic>;
        final List<dynamic> cartItems = data['cartItem'];
        for(final item in cartItems){
          final cart = Cart(id: item['idPro'], name: item['namePro'], price: item['price'], imageUrl: item['img'], color: item['color'], size: item['size'], quantity: int.parse(item['quantity']));
          addItem(cart);
        }
        print('Cart data loaded successfully');
      }
      else{
        print('Failed to load cart data. Status code: ${response.statusCode}');
      }
    }catch(e){
      print("Error $e");
    }
  }

  Future<String?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userInfoJson = prefs.getString('userInfo');
    if (userInfoJson != null) {
      final Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
      return userInfo['username'] as String?;
    }
    return null;
  }

  Future<String?> fetchCartId() async{
    final nameUser = await _getUserId();
    final url = 'http://10.0.2.2:5125/api/Cart/byNameUser/$nameUser';
    try{
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
      final Map<String,dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final String cartId = data['id'];
        return cartId;
      } else {
        print("No cart data found for user. The list is empty.");
      }
      } else {
        print('Failed to load cart. Status code: ${response.statusCode}');
      }
    }catch(e){
      print('Error: $e');
    }
    return null;
  }

  Future<void> updateCart() async {
    final id = await fetchCartId();
    final nameUser = await _getUserId();
    final List<Map<String , dynamic>> cartItem = _items.map((item){
      return{
        'idPro': item.id,
        'namePro': item.name,
        'price': item.price,
        'img': item.imageUrl,
        'quantity': item.quantity.toString(),
        'color': item.color,
        'size': item.size,
      };
    }).toList();
    final cartData = {
      'id': id,
      'cartItem': cartItem,
      'total': TotalPrice.toString(),
      'nameUser': nameUser,
    };

    final url = 'http://10.0.2.2:5125/api/Cart/$id';
    try{
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(cartData),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Cart updated successfully');
        clearCart();
      } else {
        print('Failed to update cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

      }
    }catch(e){
      print('Error: $e');
    }
  }
  
}