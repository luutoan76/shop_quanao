import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shop_quanao/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class Udateprofile extends StatefulWidget {
  final User user;
  const Udateprofile({super.key, required this.user});

  @override
  State<Udateprofile> createState() => _UdateprofileState();
}

class _UdateprofileState extends State<Udateprofile> {
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController newpasswordController = TextEditingController();
  late TextEditingController phonenumController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  late TextEditingController dateBirthController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  DateTime? selectedDate;
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  String downloadURL = "";

  @override
  void initState() {
    super.initState();
    phonenumController = TextEditingController(text: widget.user.phonenum);
    addressController = TextEditingController(text: widget.user.address);
    emailController = TextEditingController(text: widget.user.email);
    phonenumController = TextEditingController(text: widget.user.phonenum);
    dateBirthController = TextEditingController(text: widget.user.dateBirth);

  }

  Future<void> pickImage()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }
  
  

  Future<Map<String, dynamic>?> getUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userInfoString = prefs.getString('userInfo');

    if (userInfoString != null) {
      return json.decode(userInfoString) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  

  Future<void> updateProfile(User user) async {
    const apiUrl = 'http://10.0.2.2:5125/api/User';
    print(widget.user.pass);
    if(passwordController.text == widget.user.pass){
      
      final userData ={
        'id': widget.user.id,
        'username': widget.user.username,
        'pass': newpasswordController.text,  
        'phonenum': phonenumController.text,
        'address': addressController.text,
        'img': downloadURL, 
        'dateBirth': dateBirthController.text,
        'email': emailController.text,
      };
      try{
        final response = await http.put(
          Uri.parse('$apiUrl/${widget.user.id}'), 
          headers: {
            "Content-Type": "application/json",
            //"Authorization": "Bearer yourTokenHere"
          },
          body: jsonEncode(userData),
        );
        if(response.statusCode == 200 || response.statusCode ==201 || response.statusCode == 204){
          print('Profile updated successfully');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userInfo', json.encode(userData));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thông tin đã được cập nhật')),
          );
        }
        else {
          print('Failed to update profile. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
      catch(e){
        print('Error occurred: $e');
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu cũ không đúng')),
      );
    }
    
  }



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateBirthController.text = DateFormat('dd-MM-yyyy').format(picked); 
      });
    }
  }
  
  
  void showImagePickerDialog(){
    showDialog(
      context: context, 
      builder: (BuildContext content){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Chọn ảnh đại diện'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: ()async{
                  await pickImage();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.blue,
                ),
                child: const Icon(Icons.photo_library, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text('Chọn từ thư viện'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: ()async {
                if (imageFile != null) {
                  await uploadImageToFirebase(context); // Upload image
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chưa chọn ảnh!')),
                  );
                }
              },
              child: const Text("Luu"),
            ),
          ],
        );
      }
    );
  }

  Future<void> uploadImageToFirebase(BuildContext context) async {
  try {
    final String fileName = Path.basename(imageFile!.path);
    final Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('user_profile_images/$fileName');

    // Upload file
    final UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});

    // Get the download URL
    downloadURL = await snapshot.ref.getDownloadURL();
    print('Image URL: $downloadURL');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ảnh đã được tải lên thành công!')),
    );

    Navigator.of(context).pop(); 
  } catch (e) {
    print('Error uploading image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lỗi khi tải ảnh lên')),
    );
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
          "Thay đổi thông tin",
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
      body: SingleChildScrollView(
        
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                        width: 90,
                        height: 90,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: imageFile != null
                        ?Image.file(
                          File(imageFile!.path),
                          fit: BoxFit.cover,
                        ) 
                        :Image.network(
                          widget.user.img!,
                          fit: BoxFit.cover,
                        ),
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Text(
                        widget.user.username!,
                        style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          showImagePickerDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 105, 163, 239),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          "Đổi Avatar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
              child: TextField(
                controller: newpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Mật khẩu mới",
                  labelText: "Mật khẩu mới",
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const  BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Mật khẩu cũ",
                  labelText: "Mật khẩu cũ",
                  prefixIcon: const Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const  BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
              child: TextField(
                controller: phonenumController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Số điện thoại",
                  labelText: "Số điện thoại",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const  BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
              child: TextField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const  BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
              child: TextField(
                controller: addressController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Địa chỉ",
                  labelText: "Địa chỉ",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:const  BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: dateBirthController,
                    decoration: InputDecoration(
                      hintText: "Date of Birth",
                      labelText: "Ngày sinh",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.05),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    // luu vao api
                    User user = User(id: widget.user.id, username: widget.user.username, pass: newpasswordController.text, phonenum: phonenumController.text, img: widget.user.img, address: addressController.text, dateBirth: dateBirthController.text, email: emailController.text);
                    await updateProfile(user);
                    Navigator.pop(context);
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Main_screen(title: '',)),
                    );*/
                    

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 105, 163, 239),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Lưu thay đổi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}