// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Favourite.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class loveBody extends StatefulWidget {
  const loveBody({super.key});

  @override
  State<loveBody> createState() => _loveBodyState();
}

class _loveBodyState extends State<loveBody> {

  Future<String?> getUsername() async{
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final String? userInfoJson= pref.getString("userInfo");
  if(userInfoJson != null){
    final Map<String , dynamic> userInfo = jsonDecode(userInfoJson);
    return userInfo['username'] as String;
  }
  return null;
}

Future<List<Favourite>> getFav() async {
  const String baseUrl = "http://10.0.2.2:5125";
  String? username = await getUsername();
  final response = await http.get(Uri.parse('$baseUrl/api/Favourite/getFav/$username'));

    if (response.statusCode == 200) {
      final favourite = (jsonDecode(response.body) as List)
          .map((e) => Favourite.fromJson(e))
          .toList();
      return favourite;
    } else {
      throw Exception('Failed to load products');
    }
}

Future<void> DeleteFav(String id) async{
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Sản phẩm yêu thích",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<Favourite>>(
                future: getFav(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }else if(snapshot.hasError){
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(child: Text('Không có sản phẩm yêu thích'));
                  }else{
                    final favourite = snapshot.data!;
                    return ListView.builder(
                      itemCount: favourite.length,
                      itemBuilder: (context, index){
                        final fav = favourite[index];
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
                                    fav.img,
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
                                    Text(fav.name!,
                                        style:const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("${fav.price!} d",
                                        style:const TextStyle(fontSize: 16)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    
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
                                    onPressed: () async {
                                      String id = fav.idPro!;
                                      await DeleteFav(id);
                                      setState(() {
                                        favourite.removeAt(index);
                                      });
                                    },
                                  ))
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