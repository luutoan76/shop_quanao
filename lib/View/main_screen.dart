import 'package:flutter/material.dart';
import 'package:shop_quanao/components/bottom_navigationbar.dart';
import 'package:shop_quanao/components/bodyWidgets/chatBody.dart';
import 'package:shop_quanao/components/bodyWidgets/homeBody.dart';
import 'package:shop_quanao/components/bodyWidgets/loveBody.dart';
import 'package:shop_quanao/components/bodyWidgets/profileBody.dart';
import 'package:shop_quanao/components/bodyWidgets/Errorbody.dart';

import 'package:shop_quanao/Model/Fake_User.dart';
import 'package:shop_quanao/page/SearchProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Main_screen extends StatefulWidget {
  // Attribute:
  final String title;

  // constructor:
  const Main_screen({super.key, required this.title});

  @override
  State<Main_screen> createState() => _Main_screenState();
}

// ignore: camel_case_types
class _Main_screenState extends State<Main_screen> {
  final TextEditingController _searchController = TextEditingController();
 

  
  User user = User(18, '🐸');

  // Attribute:
  int _selectedIndex = 0; // default: home body.

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
  }

  

  void UpdateUser () async{
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('userInfo');
  }
  @override
  Widget build(BuildContext context) {
    // TODO: Move bodyItem initialization here to ensure context is available
    List<Widget> bodyItem = [
      const HomeBody(), // 0
      const loveBody(), // 2
      chatbody(), // 3
      const Profilebody(), // 4
    ];

    return Scaffold(
      // appbar:
      appBar: AppBar(
        title: const Text("Trang Chủ"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            "lib/public/assets/logo.png",
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // function       
              showSearch(context: context, delegate: CustomSearchDelegate(),);
            },
          )
        ],
      ),
      // body:
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        // lỗi dữ liệu json j á => tính sau ฅ^•ﻌ•^ฅ
        // demo:
        // children: user.name.length != 2 ? bodyItem : [Errorbody(user)], // Errorbody(var)
        children: bodyFunction_(bodyItem),
      ),
      // CustomBottomNavigationBar(int, void(int))
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),

    );
  }

  /*
  * demo:
  * => lỗi j đó hoặc dữ liệu ko hợp lệ 🐸🐸
  * hoặc bình thường trả về danh sách widget body.
  */
  List<Widget> bodyFunction_(List<Widget> bodyItem) {
   return user.name != '🐸' 
    ? [Errorbody(user)] // Errorbody(var)
    : bodyItem; // 5
  }

  

}
