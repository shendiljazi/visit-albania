import 'package:flutter/material.dart';
import 'package:visit_albania/screens/contact_screen.dart';
import 'package:visit_albania/screens/favorites_screen.dart';
import 'package:visit_albania/screens/home_screen.dart';
import 'package:visit_albania/screens/profile_screen.dart';
import 'package:visit_albania/widgets/app_drawer.dart';
import 'package:visit_albania/widgets/bottom_navbar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool get _isContactScreen => _selectedIndex == 3;
  int _selectedIndex = 0;
  bool _isOpenDrawer = false;

  final List<String> _pageNames = ['home', 'favorites', 'profile', 'contact'];
  final List<Widget Function()> _screenBuilders = [
    () => HomeScreen(),
    () => FavoritesScreen(),
    () => ProfileScreen(),
    () => ContactScreen(),
  ];

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.deepPurpleAccent),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      title: Center(child: Image.asset('assets/images/logo.png', height: 50)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [SizedBox(width: 50)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: _isContactScreen,
      extendBody: _isContactScreen,
      drawer: AppDrawer(
        currentPage: _pageNames[_selectedIndex],
        onSelectPage: (pageIndex) {
          setState(() {
            _selectedIndex = pageIndex;
          });
          Navigator.of(context).pop();
        },
      ),
      onDrawerChanged: (isOpen) {
        setState(() {
          _isOpenDrawer = isOpen;
        });
      },
      appBar: _buildAppBar(context),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenBuilders.map((builder) => builder()).toList(),
      ),
      bottomNavigationBar:
          _isOpenDrawer
              ? null
              : BottomNavBar(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
    );
  }
}
