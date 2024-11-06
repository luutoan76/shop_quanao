import 'package:flutter/material.dart';
import 'package:shop_quanao/admin/AdminAccount.dart';
import 'package:shop_quanao/admin/AdminProduct.dart';
import 'package:shop_quanao/admin/Dashboard.dart';
import 'package:shop_quanao/admin/OrderAdmin.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({super.key});

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  int _currentIndex = 0;
  final List<Widget> page =[
    const Adminproduct(),
    const Orderadmin(),
    const Dashboard(),
    const Adminaccount(),
  ];

  final List<String> title =[
    "Sản phẩm", // thong ke
    "Đơn hàng", // product crud
    "Dashboard", // order view
    "Tài khoản", 
  ];
   void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title[_currentIndex]),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            "lib/public/assets/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: page[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0), // or 15.0 - 20.0
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'Sản phẩm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist),
                label: 'Đơn hàng',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Tài khoản',
              ),
              
            ],
            backgroundColor: const Color(0xFF152354),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            // icon select:
            selectedIconTheme: const IconThemeData(
              color: Colors.amber,
            ),
            // icon select:
            unselectedIconTheme: const IconThemeData(
              color: Colors.white,
            ),
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
        ),
      ),
    );
  }
}