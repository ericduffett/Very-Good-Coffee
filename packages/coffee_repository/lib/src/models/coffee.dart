import 'dart:typed_data';

///A class that defines coffee for the Coffee Repository
class Coffee {
  ///Initialize instance with two required properties
  Coffee({required this.uid, required this.imageData});

  ///Unique identifier needed to avoid duplicates
  final String uid;

  ///Image Data as bytes
  final Uint8List imageData;
}
