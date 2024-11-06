import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Cart.dart';
import 'package:shop_quanao/page/checkout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    cartProvider.loadCartData(context);
  } 
  
  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userInfoJson = prefs.getString('userInfo');
    if(userInfoJson != null){
      final Map<String , dynamic> userInfo = jsonDecode(userInfoJson);
      return userInfo['username'] as String;
    }
    return null;
  }

  Future<void> SaveCart() async{
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final userId = await getUserId();
    final List<String> idPro =[];
    for (final item in cartProvider.items) {
      idPro.addAll(List.filled(item.quantity, item.id));
    }
    final total = cartProvider.TotalPrice.toString();
    final cartData = {
    'id': '', 
    'idUser': userId,
    'idPro': idPro,
    'total': total,
    };

    const url = 'http://10.0.2.2:5125/api/Cart';
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(cartData),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        print('Cart saved successfully');
      }else{
        print('Failed to save cart. Status code: ${response.statusCode}');
      }
    }catch(e){
      print('Error: $e');
    }
  }  
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cartprovider>(context);
    
    
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //
            cartProvider.updateCart();
            Navigator.pop(context);
          },
        ),
        title: const Text('Giỏ hàng'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to the search page
            },
          ),
        ],
      ),
      bottomNavigationBar: checkoutBottomNavbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Giỏ hàng của bạn",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Sản phẩm",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 1,
              child: cartProvider.items.isEmpty?
              const Center(child: Text("Gio hang trong"),):
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                       
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Transform.rotate(
                            angle: 10 *
                                (3.14 / 180.0), // Convert degrees to radians
                            child: Image.network(
                              item.imageUrl,
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("${item.price} d",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Màu: ${item.color}",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(
                                height: 5,
                              ),Text("Size: ${item.size}",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 18.0,
                                      ),
                                    ),
                                    onTap: () {
                                      // xoa
                                      //cartProvider.addItem(item);  
                                      cartProvider.decreaseQuantity(item.id);                                  
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child:  Text(
                                      item.quantity.toString(),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.add,
                                        size: 18.0,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        cartProvider.increaseQuantity(item.id);
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartProvider.removeItem(item.id);
                              },
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkoutBottomNavbar() {
    final cartProvider= Provider.of<Cartprovider>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng Tiền",
                  ),
                  GestureDetector(
                    child:  Text(
                      "${cartProvider.TotalPrice} d",
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("/payments");
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // add icon checkout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff61ADF3),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => checkout(
                        cartItems: cartProvider.items.map((item) =>{
                          'id' : item.id,
                          'quantity' : item.quantity,
                          'totalPrice' : item.totalPrice,
                          'img': item.imageUrl,
                          'color': item.color,
                          'size' : item.size,
                          'namePro' : item.name,
                          'price' : item.price,
                        }).toList(),
                        totalPrice : cartProvider.TotalPrice,
                      )),
                      
                    );
                  },
                  child: const Text(
                    "Thanh Toán",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
