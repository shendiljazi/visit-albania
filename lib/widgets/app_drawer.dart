import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_albania/screens/welcome_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.onSelectPage,
    required this.currentPage,
    super.key,
  });

  final String currentPage;
  final ValueChanged<int> onSelectPage;

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerItems = [];

    if (currentPage != 'home') {
      drawerItems.add(
        ListTile(
          leading: Icon(Icons.home, color: Colors.white),
          title: Text(
            'Home',
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          onTap: () {
            onSelectPage(0);
          },
        ),
      );
    }
    if (currentPage != 'favorites') {
      drawerItems.add(
        ListTile(
          leading: Icon(Icons.bookmark, color: Colors.white),
          title: Text(
            'Favorites',
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          onTap: () {
            onSelectPage(1);
          },
        ),
      );
    }
    if (currentPage != 'profile') {
      drawerItems.add(
        ListTile(
          leading: Icon(Icons.person, color: Colors.white),
          title: Text(
            'Profile',
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          onTap: () {
            onSelectPage(2);
          },
        ),
      );
    }
    if (currentPage != 'contact') {
      drawerItems.add(
        ListTile(
          leading: Icon(Icons.email, color: Colors.white),
          title: Text(
            'Contact us',
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          onTap: () {
            onSelectPage(3);
          },
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Image.asset('assets/images/logo.png', height: 60),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.deepPurpleAccent,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...drawerItems,
                  ListTile(
                    leading: Icon(Icons.logout_rounded, color: Colors.white),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.quicksand(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
