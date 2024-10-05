import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationSearchMapScreen extends StatefulWidget {
  const LocationSearchMapScreen({super.key});

  @override
  _LocationSearchMapScreenState createState() =>
      _LocationSearchMapScreenState();
}

class _LocationSearchMapScreenState extends State<LocationSearchMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  String? _errorMessage;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  // Fetch user's current location using Geolocator
  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorMessage = 'Location services are disabled.';
      });
      return;
    }

    // Check the current permission level
    permission = await Geolocator.checkPermission();

    // If the permission is denied, request it
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = 'Location permissions are denied.';
        });
        return;
      }
    }

    // If the permission is denied forever, display an error message
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _errorMessage = 'Location permissions are permanently denied.';
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Update the map position
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentLocation!),
      );
    }
  }

  /// Searches for a location and updates the map accordingly.
  ///
  /// [query] is the search query to search for.
  ///
  /// If the location is found, it will update the [_currentLocation] and animate
  /// the map to the new position.
  ///
  /// If the location is not found, it will set the [_errorMessage] to 'Location
  /// not found'.
  Future<void> _searchLocation(String query) async {
    try {
      // Search for the location
      List<Location> locations = await locationFromAddress(query);
      // Get the latitude and longitude of the first result
      LatLng searchLocation =
          LatLng(locations[0].latitude, locations[0].longitude);

      // Update the current position
      setState(() {
        _currentLocation = searchLocation;
        _errorMessage = null;
      });

      // Animate the map to the new position
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(searchLocation),
      );
    } catch (e) {
      // Set the error message if the location is not found
      setState(() {
        _errorMessage = 'Location not found';
      });
    }
  }

  // Toggle map type between normal and satellite
  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Location Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _toggleMapType,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchLocation(_searchController.text);
                  },
                ),
                errorText: _errorMessage,
              ),
            ),
          ),
          Expanded(
            child: _currentLocation != null
                ? GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 14.0,
                    ),
                    mapType: _currentMapType,
                    markers: {
                      Marker(
                        markerId: const MarkerId('searchedLocation'),
                        position: _currentLocation!,
                      ),
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
