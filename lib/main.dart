import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Cart.dart';
import 'package:shop_quanao/page/DangNhap.dart';
import 'package:provider/provider.dart';

void main()async {
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cartprovider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cửa Hàng Bán Đồ Thể Thao',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ), debugShowCheckedModeBanner: false,
      home:  const Dangnhap(),
    
    );
  }
}
