import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<Database> get _database async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      );
    }, version: 1);
  }

  Future<void> loadPlaces() async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final db = await _database;
    final placesData = await db.query('user_places');
    state = placesData.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String,
        location: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lng'] as double,
          address: row['address'] as String,
        ),
        image: File('${appDir.path}/${row['image'] as String}'),
      );
    }).toList();
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final imageFileName = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$imageFileName');

    final newPlace = Place(
      id: place.id,
      title: place.title,
      location: place.location,
      image: copiedImage,
    );

    final db = await _database;
    db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': imageFileName,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) {
    return UserPlacesNotifier();
  },
);
