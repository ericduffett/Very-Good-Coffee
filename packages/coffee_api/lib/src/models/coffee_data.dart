
import 'dart:typed_data';

///Class for handling unique coffee images with image data and uid
class CoffeeData {
  ///Construct instance of coffee data
  const CoffeeData({
    required this.uid,
    required this.imageData,
  });

  ///Unique ID for image
  final String uid;
  ///Image data as bytes
  final Uint8List imageData;
}