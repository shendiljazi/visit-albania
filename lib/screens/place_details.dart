import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:visit_albania/models/place.dart';
import 'package:visit_albania/providers/auth_provider.dart';
import 'package:visit_albania/providers/favorites_provider.dart';

class PlaceDetails extends StatefulWidget {
  final Place place;
  final bool isFavorite;

  const PlaceDetails({
    this.isFavorite = false, //maje mend
    required this.place,
    super.key,
  });

  @override
  State<PlaceDetails> createState() {
    return _PlaceDetailsState();
  }
}

class _PlaceDetailsState extends State<PlaceDetails> {
  late bool isBookmarked;
  late PageController _pagecontroller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.isFavorite;
    _pagecontroller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isFavorite = favoritesProvider.isFavorite(place);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.deepPurpleAccent),
        ),
        title: Center(child: Image.asset('assets/images/logo.png', height: 50)),
        elevation: 0,
        actions: [
          SizedBox(width: 48), //e mban logon te pa deformuar
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pagecontroller,
                      itemCount: place.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            place.images[index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(place.images.length, (index) {
                          return AnimatedContainer(
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: _currentPage == index ? 24 : 12,
                            decoration: BoxDecoration(
                              color:
                                  _currentPage == index
                                      ? Colors.white
                                      : Colors.white70,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      place.title,
                      style: GoogleFonts.montserratAlternates(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      size: 33,
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? Colors.deepPurpleAccent : Colors.grey,
                    ),
                    onPressed: () {
                      if (!authProvider.isLoggedIn || authProvider.isGuest) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Text(
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              'You need to have an account to add to favorites',
                            ),
                          ),
                        );
                        return;
                      }

                      if (isFavorite) {
                        favoritesProvider.removePlace(context, place);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.deepPurpleAccent,
                            duration: Duration(seconds: 1),
                            content: Text(
                              '${place.title} is removed from your favorites',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else {
                        favoritesProvider.addPlace(context, place);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.deepPurpleAccent,
                            duration: Duration(seconds: 1),
                            content: Text(
                              '${place.title} is added to your favorites',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 9),
              Text(
                place.description,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
