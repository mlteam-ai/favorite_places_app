import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation) onPickLocation;
  const LocationInput({super.key, required this.onPickLocation});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isLoading = false;

  Future<String> _getAddress(double lat, double lng) async {
    setState(() {
      _isLoading = true;
    });
    final reverseGeocodingUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey');
    final response = await http.get(reverseGeocodingUrl);
    final resData = json.decode(response.body);
    String address = resData['results'][0]['formatted_address'];
    return address;
  }

  _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });
    location.enableBackgroundMode(enable: true);
    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final address = await _getAddress(lat, lng);

    setState(() {
      _isLoading = false;
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
    });
    if (_pickedLocation != null) {
      widget.onPickLocation(_pickedLocation!);
    }
  }

  void _selectOnMap() async {
    final pickedLatlng = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (pickedLatlng == null) {
      return;
    }

    final address =
        await _getAddress(pickedLatlng.latitude, pickedLatlng.longitude);

    setState(() {
      _isLoading = false;
      _pickedLocation = PlaceLocation(
        latitude: pickedLatlng.latitude,
        longitude: pickedLatlng.longitude,
        address: address,
      );
    });
    if (_pickedLocation != null) {
      widget.onPickLocation(_pickedLocation!);
    }
  }

  String get _locationImageUrl {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    const zoom = 16;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=$zoom&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=$googleMapsApiKey';
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent;

    if (_pickedLocation != null) {
      previewContent = Image.network(
        _locationImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      previewContent = Center(
        child: Text(
          'No Location Chosen',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    }

    if (_isLoading) {
      previewContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: const Text('Select on Map'),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
