// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Cart.dart';
import 'package:shop_quanao/Model/Review.dart';
import 'package:shop_quanao/page/cart_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ProductDetailPage extends StatefulWidget {
  final String productName;
  final String productDescription;
  final List<String> productImages;
  final String ProductId;
  final String productPrice;
  final List<String> productSize;
  final List<String> productColor;
  final String productLoaisp;
  final String productLike;

  const ProductDetailPage({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productImages,
    required this.ProductId,
    required this.productPrice,
    required this.productSize,
    required this.productColor,
    required this.productLoaisp,
    required this.productLike,

  });

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false;
  int currentImageIndex = 0;
  String? id, name, description, img, price, size,color, loaisp, like;
  String? userAva;
  final TextEditingController userReviewController = TextEditingController();
  late Future<List<Review>> futureReviews;
  String selectedSize = '';
  String? selectedColor;
  void _nextImage() {
    setState(() {
      currentImageIndex = (currentImageIndex + 1) % widget.productImages.length;
      print(widget.productImages.length);
    });
  }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    id = widget.ProductId;
    name = widget.productName;
    description = widget.productDescription;
    img = widget.productImages[0];
    price = widget.productPrice;
    size = widget.productSize.toString();
    color = widget.productColor.toString();
    loaisp = widget.productLoaisp;
    like = widget.productLike;
    checkIfFavorite();
    getUserAva();
    futureReviews = getReview();
  }
  Future<List<Review>> getReview() async{
    final response = await http.get(Uri.parse("http://10.0.2.2:5125/api/Review/${widget.ProductId}"));
    if(response.statusCode == 200){
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Review.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load reviews');
    }
  }

  Future<void> checkIfFavorite() async {
    final result = await productIsLiked(widget.ProductId);
    setState(() {
      isFavorite = result;
    });
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

   Future<void> getUserAva() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userInfoJson = prefs.getString('userInfo');
    if(userInfoJson != null){
      final Map<String , dynamic> userInfo = jsonDecode(userInfoJson);
      userAva = userInfo['img'];
      setState(() {
      });
    }
  }

  Future<void> SaveReview(String review) async{
    String? username = await getUserId();
    await getUserAva();
    final url = Uri.parse('http://10.0.2.2:5125/api/Review').replace(
    queryParameters: {
      'username': username,
      'review': review,
      'idPro': id,
      'like': '0',
      'avatar': userAva,
    },
    );
    try{
      final response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'text/plain',
        },
      );
      if(response.statusCode == 200 || response.statusCode ==201){
        print("Review posted successfull");
      }else{
        print('Failed to post review. Status code: ${response.statusCode}');
        print('Response body: ${response.body}'); 

      }
    }catch(e){
      print('Error: $e');
    }
  }



  Future<void> SaveFav() async{
    String? username = await getUserId();
    final SaveData = {
      "id": "",
      "idPro" : id,
      "name" : name,
      "price": price,
      "img": img,
      "username": username, 
    };
    print("username$username$SaveData");
    const url = 'http://10.0.2.2:5125/api/Favourite';
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(SaveData),
      );
      if(response.statusCode == 200 || response.statusCode ==201){
        print("Fav save successfull");
      }else{
        print('Failed to save Fav. Status code: ${response.statusCode}');
      }
    }catch(e){
      print('Error: $e');
    }
  }

  Future<void> DeleteFav() async{
    final url = 'http://10.0.2.2:5125/api/Favourite/$id';
    final response = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},

    );
    if(response.statusCode == 200 || response.statusCode == 204){
      print('Item was deleted successfully.');
    }else{
      throw Exception('Failed to delete item with $id');
    }
  }

  

  Future<bool> productIsLiked(String productId) async{
    String? username = await getUserId();
    final response = await http.get(Uri.parse('http://10.0.2.2:5125/api/Favourite/getFav/$username'));
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      for (var item in data) {
        if(item['idPro'] == productId){
          return true;
        }
      }
      return false;
    }else{
      throw Exception('Failed to load product like status');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Stack( 
        children: [
          ListView(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),  
                  bottomRight: Radius.circular(30), 
                ),
                child: Image.network(
                  widget.productImages[currentImageIndex],
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 236, 232, 232),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 30),
                      onPressed: _nextImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 24.0),
                        const SizedBox(width: 8),
                        const Text('Đánh giá: 4.5', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 50),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            if (isFavorite) {
                              await DeleteFav();
                            } else {
                              await SaveFav();
                            }
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                        const SizedBox(width: 0),
                        Text(
                          widget.productLike,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productName,
                          style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.productPrice} Đ",
                          style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                      
                    ),
                    const SizedBox(height: 15),
                    
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Chọn Size:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10), 
                        Row(
                          children: widget.productSize.map((option) {
                            return Row(
                              children: [
                                Radio<String>(
                                  value: option,
                                  groupValue: selectedSize, 
                                  activeColor: Colors.blue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedSize = value!;
                                    });
                                  },
                                ),
                                Text(option ,   style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),), 
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    
                    Text(
                      'Loại Sản Phẩm: ${widget.productLoaisp}',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          "Chọn màu áo: ",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedColor, 
                              hint: const Text("Chọn màu"), 
                              icon: const Icon(Icons.arrow_drop_down), 
                              iconSize: 24,
                              elevation: 16,  
                              style: const TextStyle(color: Colors.black, fontSize: 16),  
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedColor = newValue!;  
                                });
                              },
                              items: widget.productColor.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),  
                                );
                              }).toList(),  
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    const Text(
                      'Kiểu dáng: Thể thao',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(0, 0),
                          child:  Text(
                            "Mô Tả",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-1, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(5, 20, 4, 0),
                            child: AutoSizeText(
                              widget.productDescription,
                              style: const TextStyle(color: Colors.black, fontSize: 17),
                              maxLines: 10,
                              minFontSize: 12,
                            ),
                          ),
                        ),

                      ],
                      
                    ),
                    const SizedBox(height: 20), // Add space before reviews
                    const Text(
                      'Review sản phẩm',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userAva != null
                            ? Image.network(userAva!, width: 60, height: 60)
                            : const CircularProgressIndicator(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: userReviewController,
                            maxLines: 2,
                            minLines: 2,
                            decoration: InputDecoration(
                              hintText: "Review của bạn",
                              contentPadding: const EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(color: Colors.black, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: Colors.blue,
                          iconSize: 30,
                          onPressed: () async {
                            String review = userReviewController.text;
                            if (review.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Error"),
                                    content: const Text("Không được để trống"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("ok"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              await SaveReview(review);
                              setState(() {
                                futureReviews = getReview();
                                userReviewController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Review>>(
                      future: futureReviews,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Sản phẩm chưa có đánh giá"));
                        } else {
                          final reviews = snapshot.data!;
                          return SizedBox(
                            height: 300, 
                            child: ListView.builder(
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(review.avatar!),
                                    ),
                                    title: Text(review.nameUser!),
                                    subtitle: Text(review.review!),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                        ],
                      ),
                    ),
              
            ],
          ),
          Positioned(
              top: 40, 
              left: 10, 
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
          ),
        ],
        
      ),
      bottomNavigationBar: checkoutBottomNavbar(),
    );
  }
  checkoutBottomNavbar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff61ADF3),
                  ),
                  onPressed: () {
                    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
                      cartProvider.addItem(
                        Cart(id: widget.ProductId, name: widget.productName, price: widget.productPrice, imageUrl: widget.productImages[0], quantity: 1, color: selectedColor! , size: selectedSize),
                      );
                      Navigator.push(
                          context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                      
                  },
                  child: const Text(
                    "Thêm Vào Giỏ Hàng",
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