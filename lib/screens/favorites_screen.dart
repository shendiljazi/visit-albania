import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:visit_albania/providers/favorites_provider.dart';
import 'package:visit_albania/screens/place_details.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() {
    return _FavoritesScreenState();
  }
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return favorites.isEmpty
        ? Center(
          child: Text(
            'No favorites yet!',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.deepPurple,
            ),
          ),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your",
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  Text(
                    "Favorites",
                    style: GoogleFonts.urbanist(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final place = favorites[index];
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: ValueKey(place.title),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 18),
                      color: Colors.deepPurple.withOpacity(0.3),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    onDismissed: (direction) {
                      context.read<FavoritesProvider>().removePlace(
                        context,
                        place,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: Text(
                            '${place.title} has been removed from your favorites',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetails(place: place),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(18),
                              ),
                              child: Image.asset(
                                place.images[0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(place.title),
                                subtitle: Text(place.categories.join(', ')),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.bookmark,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<FavoritesProvider>()
                                        .removePlace(context, place);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.deepPurple,
                                        duration: Duration(seconds: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        content: Text(
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          '${place.title} removed from favorites',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
}
