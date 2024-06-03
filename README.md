# favorite_places_app

A sample Flutter project based on the Udemy course [Flutter & Dart - The Complete Guide [2024 Edition]](https://www.udemy.com/course/fluhttps://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/).

![Here is the recording of the app](recording.gif)

## What is in This Project?

* Using camera to take images.
* Getting user location.
* Displaying a Location Preview Map Snapshot via Google.
* Displaying a picked place on a dynamic map.
* Using Google's Reverse Geocoding API.
* Handling Map Taps for Selecting a Location Manually
* Using SQLite to store data on the device. 
* Using Riverpod for state management.
* Using FutureBuilder for loading data.

## Installed Packages

```shell
flutter pub add google_fonts
flutter pub add uuid
flutter pub add http
flutter pub add flutter_riverpod
flutter pub add image_picker
flutter pub add location
flutter pub add google_maps_flutter
flutter pub add path_provider
flutter pub add path
flutter pub add sqflite
flutter pub add flutter_dotenv
```

## Additional Resources

* [HTTP package](https://pub.dev/packages/http)
* [Google Fonts package](https://pub.dev/packages/google_fonts)
* [UUID package](https://pub.dev/packages/uuid)
* [Flutter Riverpod package](https://pub.dev/packages/flutter_riverpod)
* [Image Picker package](https://pub.dev/packages/image_picker)
* [Location package](https://pub.dev/packages/location)
* [Google Maps Flutter package](https://pub.dev/packages/google_maps_flutter)
* [Path Provider package](https://pub.dev/packages/path_provider)
* [Path package](https://pub.dev/packages/path)
* [Sqflite package](https://pub.dev/packages/sqflite)
* [Google Maps API](https://developers.google.com/maps/documentation/geocoding/start)
* [Google Maps Reverse Geocoding API](https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding)
* [Adding your own native code](https://docs.flutter.dev/development/platform-integration/platform-channels)

## Additional Config
You should create a `.env` file in the root directory of the project and add your Google Maps API key as follows:

```shell
GOOGLE_MAPS_API_KEY=YOUR_API_KEY
```
