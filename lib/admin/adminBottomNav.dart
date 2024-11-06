import 'package:flutter/material.dart';

class Adminbottomnav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Adminbottomnav({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

    Widget _buildIcon(String assetName, int index) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (selectedIndex == index)
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
          Image.asset(
            assetName,
            width: 24,
            height: 24,
            color: selectedIndex == index ? Colors.white : Colors.grey,
          ),
        ],
      );
    }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // or 15.0 - 20.0
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            // home = 0
            BottomNavigationBarItem(
              icon: _buildIcon('lib/public/assets/shirt.png', 0),
              label: 'Sản Phẩm',
            ),
            // edit = 1
            
            // love = 2
            BottomNavigationBarItem(
              icon: _buildIcon('lib/public/assets/checklist.png', 1),
              label: 'Đơn Hàng',
            ),
            // chat = 3
            BottomNavigationBarItem(
              icon: _buildIcon('lib/public/assets/dashboard.png', 2),
              label: 'Dashboard',
            ),
            // profile = 4
            BottomNavigationBarItem(
              icon: _buildIcon('lib/public/assets/account.png', 3),
              label: 'Tài Khoản',
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
          currentIndex: selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
