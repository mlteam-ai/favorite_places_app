import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _imageFile;
  PlaceLocation? _pickedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  _savePlace() {
    if (_titleController.text.isEmpty) {
      return;
    }
    final place = Place(
        title: _titleController.text,
        image: _imageFile!,
        location: _pickedLocation!);
    ref.read(userPlacesProvider.notifier).addPlace(place);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a New Place'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              ImageInput(onPickImage: (image) {
                _imageFile = image;
              }),
              const SizedBox(
                height: 16,
              ),
              LocationInput(
                onPickLocation: (location) {
                  _pickedLocation = location;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _savePlace();
                },
                label: const Text('Add Place'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ));
  }
}
