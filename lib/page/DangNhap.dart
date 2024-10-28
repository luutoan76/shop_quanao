import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_quanao/page/dk.dart';
import 'package:shop_quanao/page/qmk.dart';
import 'package:shop_quanao/View/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Dangnhap extends StatefulWidget {
  const Dangnhap({super.key});

  @override
  _DangnhapState createState() => _DangnhapState();
}

class _DangnhapState extends State<Dangnhap> {
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
    prefs.setString('userInfo', json.encode(userInfo));
    print("Luu vao share pref thanh cong$userInfo");
  }//ham de luu thong tin nguoi dung vao bo nho may de su dung cho chuc nang khac ten la userInfo


  Future<List<Map<String, dynamic>>> fetchUsers() async {
  const String apiUrl = 'http://10.0.2.2:5125/api/User/';

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
                            "Đăng Nhập",
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
                                  String username = _usernameController.text;
                                  String password = _passwordController.text;
                              
                                  bool loginSuccess = await authenticateUser(username, password);
                                  
                                  if (loginSuccess) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Main_screen(title: '',)),
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
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => const Dk())
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Đăng Ký" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            
                          ),
                        ),
                        Padding(
                          
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      )
                                    ),
                                    child: ClipRRect(
                                      
                                      
                                      child: Center(
                                        child: Image.asset(
                                          'lib/public/assets/facebook.png', 
                                          width: 35,
                                          height: 35,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      )
                                    ),
                                    child: ClipRRect(
                                      
                                      
                                      child: Image.asset(
                                        'lib/public/assets/googlelogo.png', 
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                      ),
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

  _header(context) {
    return const Column(
      children: [
        Text(
          "Đăng Nhập",
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontWeight: FontWeight.w700,
            fontSize: 30,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  _header2(context) {
    return const Column(
      children: [
        Text(
          "Chào mừng quay trở lại!!!",
          style: TextStyle(
            fontFamily: 'Inria Sans',
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Tên đăng nhập",
          style: TextStyle(
            fontFamily: 'Noto Sans Kannada',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0x99000000),
          ),
        ),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Nhập tên đăng nhập",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Mật khẩu",
          style: TextStyle(
            fontFamily: 'Noto Sans Kannada',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0x99000000),
          ),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Nhập mật khẩu",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  _login(context) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;
            
                // Giả sử bạn gọi một API để xác thực người dùng
                bool loginSuccess = await authenticateUser(username, password);
                
                if (loginSuccess) {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Main_screen(title: '',)),
                );
                } else {
                  setState(() {
                    _errorMessage = "Tên đăng nhập hoặc mật khẩu không đúng!";
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 133, 201, 234), // Màu nền
                minimumSize: const Size(150, 60),
              ),
              child: const Text(
                "Đăng nhập",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
              ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
              onPressed: () async {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dk()),
                );
                
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 133, 201, 234), // Màu nền
                minimumSize: const Size(150, 60),
              ),
              child: const Text(
                "Đăng ký",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
              ),
              ),
            ]
            
          ),
          
        ),
        const SizedBox(height: 20),
        const Text("Quên mật khẩu?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const qmk()),
            );
          },
          child: const Text("Nhập email"),
        ),
      ],
    );
  }

}
