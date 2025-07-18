import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/place.dart';

Future<List<Place>> loadPlaces() async {
  final String response = await rootBundle.loadString('assets/places.json');
  final List<dynamic> data = json.decode(response);
  return data.map((json) => Place.fromJson(json)).toList();
}
