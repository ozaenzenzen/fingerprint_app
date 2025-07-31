import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class AppDatatypeConverter {
  Future<File?> convertImageToFile({
    required img.Image image,
    required String fileName,
    String format = 'png',
  }) async {
    try {
      // Encode the image to the specified format
      Uint8List? imageBytes;
      if (format.toLowerCase() == 'jpeg' || format.toLowerCase() == 'jpg') {
        imageBytes = img.encodeJpg(image);
      } else if (format.toLowerCase() == 'png') {
        imageBytes = img.encodePng(image);
      } else {
        throw ArgumentError('Unsupported format: $format. Use "png" or "jpeg".');
      }

      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Create the file path
      final String filePath = '${tempDir.path}/$fileName';

      // Write bytes to file
      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      return file;
    } catch (e) {
      print('Error converting Image to File: $e');
      return null;
    }
  }

  Future<File?> convertBase64ToFile({
    required String base64String,
    required String fileName,
  }) async {
    try {
      // Decode base64 string to bytes
      final Uint8List bytes = base64Decode(base64String);

      // Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Create a file path with the provided file name
      final String filePath = '${tempDir.path}/$fileName';

      // Create a File instance and write the bytes to it
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print('Error converting base64 to file: $e');
      return null;
    }
  }
}
