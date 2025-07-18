import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_albania/models/place.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Place> _favorites = [];

  List<Place> get favorites => _favorites;

  bool isFavorite(Place place) => _favorites.contains(place);

  void addPlace(BuildContext context, Place place) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn || authProvider.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            'You need to be logged in be able to add favorites',
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }
    if (!_favorites.contains(place)) {
      _favorites.add(place);
      notifyListeners();
    }
  }

  void removePlace(BuildContext context, Place place) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      return;
    }
    _favorites.remove(place);
    notifyListeners();
  }
}
