import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_quanao/Model/Cart.dart';
import 'package:shop_quanao/page/editShipmet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checkout extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  const checkout({super.key, required this.cartItems, required this.totalPrice});
  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  int selected = 0;
  String newAddress = '';
  bool isLoading = false;

  Future<void> _performCheckout() async {
    setState(() {
      isLoading = true;
    });

    final List<String> idPro = [];
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    final String? username = await getUsername();
    if(username == null){
      print("id null");
    }
    final List<Map<String , dynamic>> orderItem = widget.cartItems.map((item) => {
      'idPro': item['id'],
      'namePro': item['namePro'],
      'price': item['price'],       
      'img': item['img'],           
      'quantity': item['quantity'].toString(), 
      'color': item['color'],     
      'size': item['size'],  
    }).toList();
    
    final order = {
      'id' : "",
      'dayCreate': formattedDate,
      'orderItem': orderItem,
      'address': newAddress,
      'total': widget.totalPrice.toString(),
      'username': username,
      'status': "Đang chờ xác nhận", 
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5125/api/Order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order),
    );

    setState(() {
      isLoading = false;
    });
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      Provider.of<Cartprovider>(context, listen: false).clearCart();
      Navigator.pop(context);
      _showDialog('Thanh toán thành công', 'Cảm ơn bạn đã mua hàng!');
    } else {
      _showDialog('Lỗi', 'Đã xảy ra lỗi khi gửi đơn hàng.');
    }
  }
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
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
          "Thanh Toán",
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


      body:  SafeArea(
          child:  Column(
            mainAxisSize: MainAxisSize.max,
            children:  [
              const Align(
                alignment:  AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 30, 0, 0),
                  child: Text(
                    'Chọn hình thức',
                    style:  TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Text(
                    'Thanh Toán',
                    style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Radio <int> (
                    value: 1, 
                    groupValue: selected, 
                    onChanged: (int? value) {
                      setState(() {
                        selected = value!;
                      });
                    },                  
                  ),
                  
                  Image.asset(
                    'lib/public/assets/ipay.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    
                  ),
                  
                  Radio <int> (
                    value: 2, 
                    groupValue: selected, 
                    onChanged: (int? value) {
                      setState(() {
                        selected = value!;
                      });
                    },                  
                  ),
                  Image.asset(
                    'lib/public/assets/visa.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  Radio <int> (
                    value: 3, 
                    groupValue: selected, 
                    onChanged: (int? value) {
                      setState(() {
                        selected = value!;
                      });
                    },                  
                  ),
                  Image.asset(
                    'lib/public/assets/mastercard.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              Align(
                  alignment: const AlignmentDirectional(-1, -1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 30, 0, 0),
                        child: Text(
                          'Địa chỉ giao',
                          style: TextStyle(
                                fontFamily: 'Readex Pro',
                                fontSize: 20,
                                letterSpacing: 0,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.asset(
                                  'lib/public/assets/Group_8756.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Flexible(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  newAddress,
                                  style: const TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 20,
                                        letterSpacing: 0,
                                      ),
                                ),
                              ),
                            ),

                            Flexible(
                              child:  Align(
                                alignment: Alignment.topRight,
                                
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                        offset: const Offset(0,1),
                                      ),
                                    ]
                                  ),
                                  child: IconButton(
                                    
                                    icon: const Icon(Icons.edit),
                                    iconSize: 35,
                                    color: Colors.black,
                                    tooltip: "edit",
                                    splashColor: Colors.red,
                                    onPressed: ()async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChangePlace(place: newAddress)),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          newAddress = result;
                                        });
                                      }                                      
                                    },                                    
                                  ),
                                  
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      
                    ]
                  ),
                  
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 50, 0, 0),
                    child: Text(
                      'Giá',
                      style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 18,
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 20, 0),
                    child: Text(
                      "${widget.totalPrice} d",
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

              const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 50, 0, 0),
                    child: Text(
                      'Phí Giao',
                      style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 18,
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 50, 20, 0),
                    child: Text(
                      '10 d',
                      style: TextStyle(
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
                    padding: EdgeInsetsDirectional.fromSTEB(20, 50, 0, 0),
                    child: Text(
                      'Tông tiền',
                      style: TextStyle(
                            fontFamily: 'Readex Pro',
                            fontSize: 18,
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 20, 0),
                    child: Text(
                      "${widget.totalPrice + 10} d",
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

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 40),
                    backgroundColor: const Color(0xFF61ADF3),
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    elevation: 3,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),

                  ),


                  onPressed: isLoading ? null: () async {
                    // su ly thanh toan
                    await _performCheckout();
                  },
                  
                  child: const Text("Thanh Toán"),
                ),
              ),
            ],
          ),
          
          
        ),
    );
  }
}