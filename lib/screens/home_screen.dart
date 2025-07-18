import 'package:flutter/material.dart';
import 'package:visit_albania/screens/place_details.dart';
import 'package:visit_albania/widgets/categories.dart';
import 'package:visit_albania/widgets/place_card.dart';
import '../models/place.dart';
import 'package:visit_albania/helpers/place_service.dart';
import 'package:visit_albania/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Place> allPlaces = [];
  List<Place> filteredPlaces = [];
  String selectedCategory = 'All';
  List<String> categories = ['All'];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPlaces()
        .then((places) {
          setState(() {
            allPlaces = places;
            categories = [
              'All',
              ...{for (final place in places) ...place.categories},
            ];
            filteredPlaces = allPlaces;
            isLoading = false;
          });
        })
        .catchError((error, stackTrace) {
          print('Error loading places: $error');
          print(stackTrace);
          setState(() {
            isLoading = false;
          });
        });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      filteredPlaces =
          category == 'All'
              ? allPlaces
              : allPlaces
                  .where((p) => p.categories.contains(category))
                  .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  SearchBarWidget(
                    allPlaces: filteredPlaces,
                    onSuggestionTap: (place) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetails(place: place),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Categories(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 23),
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredPlaces.length,
                        itemBuilder: (context, index) {
                          final place = filteredPlaces[index];
                          return PlaceCard(
                            place: place,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PlaceDetails(place: place),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
