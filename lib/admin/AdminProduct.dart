import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_quanao/Model/Product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_quanao/admin/CRUD/createProduct.dart';

class Adminproduct extends StatefulWidget {
  const Adminproduct({super.key});

  @override
  State<Adminproduct> createState() => _AdminproductState();
}

class _AdminproductState extends State<Adminproduct> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Future<List<Product>> fetchProducts()async{
    final respone = await http.get(Uri.parse("http://10.0.2.2:5125/api/Products"));
    if(respone.statusCode == 200){
      List<dynamic> data =jsonDecode(respone.body);
      return data.map((item) => Product.fromJson(item)).toList();
    }else {
      throw Exception('Failed to load products');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text('Error: No products found'));
          }else{
            final products = snapshot.data;
            return ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(product.img![0]),
                              fit: BoxFit.cover, 
                            ),
                          ),
                        ),
                        const SizedBox(width: 16), 
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name!,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text("Giá: ${product.price} đ"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                                onPressed: () {
                                  // 
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () {
                                  // Add action for add-to-cart button
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.blue),
                                onPressed: () {
                                  // Add action for share button
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // them
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Createproduct())
          );
        },
        tooltip: "Thêm công việc",
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}