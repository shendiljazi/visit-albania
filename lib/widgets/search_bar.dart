import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visit_albania/models/place.dart';

class SearchBarWidget extends StatefulWidget {
  final List<Place> allPlaces;
  final Function(Place) onSuggestionTap;

  const SearchBarWidget({
    required this.allPlaces,
    required this.onSuggestionTap,
    super.key,
  });

  @override
  State<SearchBarWidget> createState() {
    return _SearchBarWidgetState();
  }
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _userInput = TextEditingController();
  List<Place> _suggestions = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _userInput.text = '';
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userInput.dispose();
    _focusNode.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.length < 3) {
      setState(() {
        _suggestions = [];
        return;
      });
    }
    final query = value.toLowerCase();
    setState(() {
      _suggestions =
          widget.allPlaces
              .where(
                (place) =>
                    place.title.toLowerCase().contains(query) ||
                    place.categories.any(
                      (cat) => cat.toLowerCase().contains(query),
                    ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(25),
          child: TextField(
            focusNode: _focusNode,
            controller: _userInput,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Color.fromARGB(255, 138, 133, 133),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search destinations',
              hintStyle: GoogleFonts.urbanist(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.urbanist(fontSize: 16),
          ),
        ),
        if (_suggestions.isNotEmpty && _userInput.text.length >= 3)
          Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, _) => Divider(height: 1),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final place = _suggestions[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      place.images[0],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    place.title,
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    widget.onSuggestionTap(place);
                    setState(() {
                      _userInput.text = place.title;
                      _suggestions = [];
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
