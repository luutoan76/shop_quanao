import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/User.dart';
import 'package:shop_quanao/page/DangNhap.dart';
import 'package:shop_quanao/page/OrderHistory.dart';
import 'package:shop_quanao/page/cart_page.dart';
import 'package:shop_quanao/page/udateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilebody extends StatefulWidget {
  const Profilebody({super.key});

  @override
  State<Profilebody> createState() => _ProfilebodyState();
}

class _ProfilebodyState extends State<Profilebody> {
  late Future<User?> userInfo;

  Future<User?> getUserInfoFromPrefs() async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userJson = preferences.getString('userInfo');
    
    Map<String, dynamic> userMap = jsonDecode(userJson!);
    return User.fromJson(userMap);
  }

  

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
    print("Xoa thanh cong");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = getUserInfoFromPrefs();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child:  FutureBuilder<User?>(
        future: userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user info found.'));
          } else {
          User user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20,),
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                        user.img!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Text(
                        user.username!,
                        style: const TextStyle(
                          letterSpacing: 0,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    user.email!,
                    style: const TextStyle(
                              fontFamily: 'Readex Pro',
                              color: Colors.black,
                              letterSpacing: 0,
                    ),
                  ),
                ),
                const Divider(
                  height: 44,
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                  color: Colors.black,
                ),
            
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Địa chỉ',
                        style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                      child: Text(
                        user.address!,
                        style: const TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
            
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Số điện thoại',
                        style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                      child: Text(
                        user.phonenum!,
                        style: const TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
            
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Ngày sinh',
                        style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              letterSpacing: 0,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                      child: Text(
                        user.dateBirth!,
                        style: const TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
            
                GestureDetector(
                  onTap: () async{
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Udateprofile(
                        user: user,
                      ))
                    );
                    setState(() {
                      userInfo = getUserInfoFromPrefs();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                        ),
                      ),
                      child:const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                        child: Row(
                          mainAxisSize:MainAxisSize.max ,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                              child: Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.black,
                                    size: 24,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text(
                                'Chỉnh sửa thông tin cá nhân',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage())
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                        ),
                      ),
                      child:const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                        child: Row(
                          mainAxisSize:MainAxisSize.max ,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                              child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.black,
                                    size: 24,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text(
                                'Giỏ Hàng',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Orderhistory())
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                        ),
                      ),
                      child:const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                        child: Row(
                          mainAxisSize:MainAxisSize.max ,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                              child: Icon(
                                    Icons.list,
                                    color: Colors.black,
                                    size: 24,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text(
                                'Lịch sử đặt hàng',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      // log out
                      logout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Dangnhap())
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F4F8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      "Đăng xuất", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

