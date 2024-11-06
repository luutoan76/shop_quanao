import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_quanao/admin/AdminPage.dart';
import 'package:shop_quanao/admin/AdminProduct.dart';
import 'package:shop_quanao/page/DangNhap.dart';
import 'package:http/http.dart' as http;


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";

  Future<bool> authenticateUser(String username, String password) async {
    List<Map<String, dynamic>> users = await fetchUsers();

    for (var user in users) {
      if (user['username'] == username && user['pass'] == password) {
        await saveUserInfoToPrefs(user);
        return true;
      }
    }
    return false;
  }

  Future<void> saveUserInfoToPrefs(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('adminInfo', json.encode(userInfo));
    print("Luu vao share pref thanh cong$userInfo");
  }//ham de luu thong tin nguoi dung vao bo nho may de su dung cho chuc nang khac ten la userInfo


  Future<List<Map<String, dynamic>>> fetchUsers() async {
    const String apiUrl = 'http://10.0.2.2:5125/api/Admin/';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'});

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        return responseBody.cast<Map<String, dynamic>>();
      } else {
        print("Server error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Connection error: $e");
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "lib/public/assets/loginback.png",
                fit: BoxFit.cover,
              ),
            ),
            Align(
              child: Material(
                color: Colors.white,
                elevation: 30,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(
                  width: 300,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 40),
                          child: Image.asset(
                            "lib/public/assets/logo.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.only(top: 20),
                          child: Text(
                            "Đăng Nhập Admin",
                            style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                    
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.black, width: 1.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.blue, width: 1.0)
                                ),
                                prefixIcon: const Icon(Icons.email, color: Colors.black, size: 20,),
                    
                              ),
                    
                    
                            ),
                          ),
                    
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                                
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.black, width: 1.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.blue, width: 1.0)
                                ),
                                prefixIcon: const Icon(Icons.password, color: Colors.black),
                    
                              ),
                    
                    
                            ),
                          ),
                    
                        ),
                        _errorMessage.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                          )
                        : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // dang nhap
                                  String username = _usernameController.text;
                                  String password = _passwordController.text;
                              
                                  bool loginSuccess = await authenticateUser(username, password);
                                  
                                  if (loginSuccess) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Adminpage()),
                                    );
                                  } 
                                  
                                  else {
                                    setState(() {
                                      _errorMessage = "Tên đăng nhập hoặc mật khẩu không đúng!";
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Đăng Nhập" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                                ),
                              ),
                              
                            ],
                            
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Dangnhap()),
                                  );
                                },
                                child: const Text(
                                  'Quay lại trang đăng nhập khách',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue
                                  ),
                                ),
                              ),
                              
                            ],
                            
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}