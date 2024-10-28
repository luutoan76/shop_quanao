import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Order.dart';
import 'package:shop_quanao/page/Order_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Orderhistory extends StatefulWidget {
  const Orderhistory({super.key});

  @override
  State<Orderhistory> createState() => _OrderhistoryState();
}

class _OrderhistoryState extends State<Orderhistory> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<String?> getUsername() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? userInfoJson= pref.getString("userInfo");
    if(userInfoJson != null){
      final Map<String , dynamic> userInfo = jsonDecode(userInfoJson);
      return userInfo['username'] as String;
    }
    return null;
  }

  Future<List<Order>> getOrder() async {
  const String baseUrl = "http://10.0.2.2:5125";
  String? username = await getUsername();
  final response = await http.get(Uri.parse('$baseUrl/api/Order/getUser/$username'));
    if (response.statusCode == 200) {
      final favourite = (jsonDecode(response.body) as List)
          .map((e) => Order.fromJson(e))
          .toList();
      return favourite;
    } else {
      throw Exception('Failed to load order');
    }
  }



  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // chuyen den trang moi
            Navigator.pop(context);

          },
        ),
        title: const Text(
          "Đơn hàng",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: (){

            },
          ),
        ],

      ),
    body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Lịch sử đặt hàng",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: getOrder(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }else if(snapshot.hasError){
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(child: Text('Không có đơn hàng nào'));
                  }else{
                    final order = snapshot.data!;
                    return ListView.builder(
                      itemCount: order.length,
                      itemBuilder: (context, index) {
                        final item = order[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                            
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                
                                  child: Image.asset(
                                    'lib/public/assets/package.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
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
                                    Text(item.total!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(item.status!,
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10)),
                                    child: IconButton(
                                      icon: const Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetail(order: item),));
                                      },
                                )),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  
                },
                
                ),
            ),
          ],
        ),
      ),
  );
  }
}

