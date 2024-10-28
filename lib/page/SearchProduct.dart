import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_quanao/page/ProductDetails_screen.dart';


class CustomSearchDelegate extends SearchDelegate<Product?>{
  //CustomSearchDelegate();
  final String url = "http://10.0.2.2:5125/api/Products/Search/";
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
        query = '';
        },
      ),
    ];  
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    return FutureBuilder<List<Product>>(
      future: _searchProducts(query),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return const Center(child: Text("Sản Phẩm không tồn tại"));
        }
        else if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text("Khon tim thay san pham"));          
        }else{
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index){
              final product = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            key: ValueKey('product_detail_page_$index'),
                            productName: product.name.toString(),
                            productDescription: product.description.toString(),
                            productImages: product.img!,
                            ProductId: product.id.toString(),
                            productPrice: product.price.toString(),
                            productLoaisp: product.loaisp.toString(),
                            productSize: product.size!,
                            productColor: product.color!,
                            productLike: product.like.toString(),
                          ),
                        ),
                      );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0,4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 120.0, 
                          height: 120.0, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: product.img != null && product.img!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(product.img![0]),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16, ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name ?? '',
                                style: const TextStyle(
                                  fontSize: 22.0, // Adjust font size as needed
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                product.price ?? '',
                                style: TextStyle(
                                  fontSize: 18.0, // Adjust font size as needed
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          )
                        ),
                
                      ],
                    ),
                    
                  ),
                ),
              );
            },
          );
        }
      }
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
  
  Future<List<Product>> _searchProducts(String query) async {
    final response = await http.get(Uri.parse('$url$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Sản phẩm không tồn tại');
    }
  }
}