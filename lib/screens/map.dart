import 'package:favorite_places_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation location;
  final bool isSelecting;

  const MapScreen({
    super.key,
    this.isSelecting = true,
    this.location = const PlaceLocation(
        latitude: 37.422, longitude: -122.084, address: 'Googleplex'),
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick a Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedPosition);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onTap: (position) {
          if (!widget.isSelecting) {
            return;
          }
          setState(() {
            _pickedPosition = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 16,
        ),
        markers: (widget.isSelecting && _pickedPosition == null)
            ? <Marker>{}
            : <Marker>{
                Marker(
                  markerId: const MarkerId('m1'),
                  position: (_pickedPosition == null)
                      ? LatLng(
                          widget.location.latitude, widget.location.longitude)
                      : _pickedPosition!,
                ),
              },
      ),
    );
  }
}
