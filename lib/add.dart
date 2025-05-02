import 'dart:convert';

import 'package:flutter/material.dart';
import './services/request_services.dart';
import './models/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  List<String> addedLocations = []; // List of added locations

  String selectedCity = ''; // Selected city

  String hinted = 'Search for a city'; // Default hint text
  double lat = 0, long = 0; // Location coordinates (not used in this code yet)


  // Show modal to add new location
  void _showAddLocationModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onSubmitted: (city) {
                  setState(() {
                    addedLocations.add(city);
                    _searchController.clear();
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    addedLocations.add(_searchController.text);
                    _searchController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Text('Add Location'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Sliding card for adding a new location

  // List of added locations
  Widget _addedLocationsList() {
    return ListView.builder(
      itemCount: addedLocations.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap:
              () => {
                Navigator.pushNamed(
                  context,
                  "/Cards",
                  arguments: addedLocations[index],
                ),
              },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  addedLocations[index],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      addedLocations.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fetch suggestions for cities
  final TextEditingController _searchController =
      TextEditingController(); // To read input
  List<dynamic> _suggestions = []; // To store suggestions from API

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final url = Uri.parse(
      'https://api.weatherapi.com/v1/search.json?key=0e85ff7496b64fe08df84436251804&q=$query',
    );

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        setState(() {
          _suggestions = jsonDecode(res.body);
        });
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // _getLocation();

    getData();
  }

  Weather? list;

  getData() async {
    list = await RequestServices().getReq(lat, long, selectedCity);
    if (list != null) {
      setState(() {});
    } else {
      setState(() {
        selectedCity = "";
        getData();
      });
    }
  }

  // Suggestion overlay for search
  Widget _suggestionOverlay() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 30, 50, 70),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            final loc = _suggestions[index];
            return ListTile(
              title: Text(
                '${loc['name']}, ${loc['region']}, ${loc['country']}',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                if (!addedLocations.contains(loc['name'])) {
                  setState(() {
                    _searchController.text = loc['name'];
                    _suggestions.clear();
                    lat = 0;
                    long = 0;
                    addedLocations.add(loc['name']);
                    _searchController.clear();
                  });
                  getData();
                  Navigator.pushNamed(
                    context,
                    "/Cards",
                    arguments: loc['name'],
                  );
                } else {
                  _suggestions.clear();
                  lat = 0;
                  long = 0;
                  _searchController.clear();

                  Navigator.pushNamed(
                    context,
                    "/Cards",
                    arguments: loc['name'],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  // Search bar widget
  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(91, 0, 52, 76),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(130, 0, 0, 0).withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _fetchSuggestions,
        onSubmitted: (e) {
          setState(() {
            selectedCity = e;
            lat = 0;
            long = 0;
            _suggestions.clear();
            addedLocations.add(e);
            _searchController.clear();
          });
          getData();
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hinted,
          hintStyle: const TextStyle(color: Color.fromARGB(147, 1, 1, 1)),
          prefixIcon: Container(
            padding: const EdgeInsets.only(left: 8, right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _searchController.clear(); // Clear text
                    setState(() {
                      // Force rebuild to show hint
                      _suggestions.clear();
                    });
                  },
                  child: Tooltip(
                    message: "Go to your location",
                    child: InkWell(
                      onTap: () => {Navigator.pushNamed(context, "/Cards")},

                      child: Icon(
                        Icons.pin_drop,
                        size: 30,
                        color: Color.fromARGB(90, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(width: 1, height: 30, color: Colors.black26),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBar(),
                const SizedBox(height: 20),
                if (_suggestions.isNotEmpty) _suggestionOverlay(),

                // Display list of added locations or a message
                addedLocations.isEmpty
                    ? Expanded(child: Center(child: Text('No locations added')))
                    : Expanded(child: _addedLocationsList()),
              ],
            ),
          ),

          // Suggestion Overlay
        ],
      ),
    );
  }
}
