import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isTransparent;
  final ValueChanged<int> onTap;
  const BottomNavBar({
    this.isTransparent = false,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10, bottom: 18),
      padding: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color:
            isTransparent
                ? Colors.deepPurpleAccent.withOpacity(0.4)
                : Colors.deepPurpleAccent.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 33),
            label: '',
          ), //0
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, size: 33),
            label: '', //1
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined, size: 33),
            label: '', //2
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail, size: 33),
            label: '',
          ), //3
        ],
      ),
    );
  }
}
