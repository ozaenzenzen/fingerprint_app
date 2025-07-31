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

  Future<String> fileToBase64WithDataType(File file, {String format = 'png'}) async {
    try {
      // Read file as bytes
      final Uint8List bytes = await file.readAsBytes();

      // Encode to base64
      final String base64String = base64Encode(bytes);

      // Determine MIME type based on format
      final String mimeType = format.toLowerCase() == 'jpeg' || format.toLowerCase() == 'jpg' ? 'image/jpeg' : 'image/png';

      // Return base64 string with data type
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      print('Error encoding file to base64: $e');
      return '';
    }
  }

  Future<String> bytesToBase64WithDataType(Uint8List bytes, {String format = 'png'}) async {
    try {
      // Encode to base64
      final String base64String = base64Encode(bytes);

      // Determine MIME type based on format
      final String mimeType = format.toLowerCase() == 'jpeg' || format.toLowerCase() == 'jpg' ? 'image/jpeg' : 'image/png';

      // Return base64 string with data type
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      print('Error encoding bytes to base64: $e');
      return '';
    }
  }

  Future<File?> base64ToFile({
    required String base64String,
    required String fileName,
    String format = 'png',
  }) async {
    try {
      // Decode base64 string to bytes
      final Uint8List bytes = base64Decode(base64String);

      // Validate image format using the image package
      final img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) {
        throw Exception('Invalid image data');
      }

      // Re-encode to ensure correct format
      Uint8List? imageBytes;
      if (format.toLowerCase() == 'jpeg' || format.toLowerCase() == 'jpg') {
        imageBytes = img.encodeJpg(decodedImage, quality: 85);
      } else if (format.toLowerCase() == 'png') {
        imageBytes = img.encodePng(decodedImage);
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
      print('Error converting base64 to file: $e');
      return null;
    }
  }

  // /// Converts a plain base64 string to a base64 string with MIME type (data URI).
  // /// Parameters:
  // /// - base64String: The plain base64 string (e.g., 'iVBORw0KGgo...').
  // /// - format: The image format ('png' or 'jpeg'). Defaults to 'png'.
  // Future<File?> base64ToFile({
  //   required String base64String,
  //   required String fileName,
  //   String format = 'png',
  // }) async {
  //   try {
  //     // Decode base64 string to bytes
  //     final Uint8List bytes = base64Decode(base64String);

  //     // Validate image format using the image package
  //     final img.Image? decodedImage = img.decodeImage(bytes);
  //     if (decodedImage == null) {
  //       throw Exception('Invalid image data');
  //     }

  //     // Re-encode to ensure correct format
  //     Uint8List? imageBytes;
  //     if (format.toLowerCase() == 'jpeg' || format.toLowerCase() == 'jpg') {
  //       imageBytes = img.encodeJpg(decodedImage, quality: 85);
  //     } else if (format.toLowerCase() == 'png') {
  //       imageBytes = img.encodePng(decodedImage);
  //     } else {
  //       throw ArgumentError('Unsupported format: $format. Use "png" or "jpeg".');
  //     }

  //     // Get the temporary directory
  //     final Directory tempDir = await getTemporaryDirectory();

  //     // Create the file path
  //     final String filePath = '${tempDir.path}/$fileName';

  //     // Write bytes to file
  //     final File file = File(filePath);
  //     await file.writeAsBytes(imageBytes);

  //     return file;
  //   } catch (e) {
  //     print('Error converting base64 to file: $e');
  //     return null;
  //   }
  // }

  /// Converts a plain base64 string to a base64 string with MIME type (data URI).
  /// Parameters:
  /// - base64String: The plain base64 string (e.g., 'iVBORw0KGgo...').
  /// - format: The image format ('png' or 'jpeg'). Defaults to 'png'.
  String base64ToBase64WithMimeType({
    required String base64String,
    String format = 'png',
  }) {
    try {
      // Validate base64 string by decoding
      final Uint8List bytes = base64Decode(base64String);

      // Validate image format using the image package
      final img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) {
        throw Exception('Invalid image data');
      }

      // Determine MIME type
      final String mimeType = format.toLowerCase() == 'jpeg' || format.toLowerCase() == 'jpg' ? 'image/jpeg' : 'image/png';

      // Return base64 string with MIME type
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      print('Error adding MIME type to base64: $e');
      return '';
    }
  }
}
