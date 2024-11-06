import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_quanao/page/DangNhap.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class Dk extends StatefulWidget {
  const Dk({super.key});

  @override
  _DkState createState() => _DkState();
}

class _DkState extends State<Dk> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController RePassController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String _errorMessage = "";
  String? downloadURL = "";
  Future<bool> isUsernameTaken(String username) async {
    List<Map<String, dynamic>> users = await fetchUsers();

    for (var user in users) {
      if (user['username'] == username) {
        return true;
      }
    }
    return false;
  }

  Future<void> uploadImageToFirebase(BuildContext context) async {
    try {
      final ByteData byteData = await rootBundle.load('lib/public/assets/ava.jpg');
      final Uint8List imageData = byteData.buffer.asUint8List();

      const String fileName = "ava.jpg";
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('user_profileAvatar/$fileName');

      final UploadTask uploadTask = firebaseStorageRef.putData(imageData);
      final TaskSnapshot snapshot = await uploadTask;

      downloadURL = await snapshot.ref.getDownloadURL();
      print('Image URL: $downloadURL');

      
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  Future<bool> registerUser(String username, String password, String phonenum, String email) async {
    await uploadImageToFirebase(context);
    const String apiUrl = 'http://10.0.2.2:5125/api/User/';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': "",
        'username': username,
        'pass': password,
        'phonenum':  phonenum,
        'email': email,
        'address': "",
        'img': downloadURL,
        'dateBirth': "",
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Failed to register user. Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return false;
    }
  }

  Future<bool> createCart(String username) async {
    const String apiUrl = 'http://10.0.2.2:5125/api/Cart';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': '', 
        'nameUser': username,
        'cartItem': [],
        'total': "0",
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Failed to register user. Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return false;
    }
  }

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
                        
                        const Padding(
                          padding: EdgeInsetsDirectional.only(top: 40),
                          child: Text(
                            "Đăng Ký",
                            style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                    
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              
                              controller: emailController,
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
                              
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.black, width: 1.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.blue, width: 1.0)
                                ),
                                prefixIcon: const Icon(Icons.person, color: Colors.black, size: 20,),
                    
                              ),
                    
                    
                            ),
                          ),
                    
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              
                              controller: phoneController,
                              decoration: InputDecoration(
                                hintText: "Phone num",
                                
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.black, width: 1.0)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:const BorderSide(color: Colors.blue, width: 1.0)
                                ),
                                prefixIcon: const Icon(Icons.phone, color: Colors.black, size: 20,),
                    
                              ),
                    
                    
                            ),
                          ),
                    
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              
                              controller: passController,
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
                        Padding(
                          padding: const EdgeInsetsDirectional.only(top: 20),
                          child: SizedBox(
                            width: 270,
                            child: TextField(
                              
                              controller: RePassController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Re-Password",
                                
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
                                  String username = usernameController.text;
                                  String phonenum = phoneController.text;
                                  String password = passController.text;
                                  String Repassword = RePassController.text;
                                  String email = emailController.text;

                                  if(username.isEmpty || phonenum.isEmpty || password.isEmpty || Repassword.isEmpty || email.isEmpty){
                                    setState(() {
                                      _errorMessage = "Không được để trống các ô trên";
                                    });
                                    return;
                                  }
                                  if (await isUsernameTaken(username)) {
                                    setState(() {
                                      _errorMessage = "Tên đăng nhập đã tồn tại!";
                                    });
                                    return;
                                  }

                                  bool success = await registerUser(username, password, phonenum, email);
                                  bool success2 = await createCart(username);
                                  if (success && success2) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Dangnhap()),
                                    );
                                  } else {
                                    setState(() {
                                      _errorMessage = "Đăng ký thất bại!";
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
                                  "Đăng Ký" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
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
