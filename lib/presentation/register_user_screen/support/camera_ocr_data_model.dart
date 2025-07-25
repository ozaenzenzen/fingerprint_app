import 'package:saas_mlkit/saas_mlkit.dart';

class CameraOcrDataModel {
  KTPData? ktpData;
  String? imageFromCard;
  String? imageCard;

  CameraOcrDataModel({
    this.ktpData,
    this.imageFromCard,
    this.imageCard,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'ktpData': ktpData?.toJson(),
      'imageFromCard': imageFromCard,
      'imageCard': imageCard,
    };
  }

  // Create from JSON
  factory CameraOcrDataModel.fromJson(Map<String, dynamic> json) {
    return CameraOcrDataModel(
      ktpData: json['ktpData'] != null ? KTPData.fromJson(json['ktpData']) : null,
      imageFromCard: json['imageFromCard'],
      imageCard: json['imageCard'],
    );
  }
}

// // Assuming KTPData also needs serialization methods
// extension KTPDataSerialization on KTPData {
//   Map<String, dynamic> toJson() {
//     // Replace with actual properties of KTPData
//     return {
//       // Example properties - adjust according to your actual KTPData class
//       'name': name,
//       'idNumber': idNumber,
//       // Add all other properties of KTPData here
//     };
//   }

//   // If KTPData doesn't have a fromJson constructor, you might need to create one
//   static KTPData fromJson(Map<String, dynamic> json) {
//     return KTPData(
//       // Replace with actual constructor parameters of KTPData
//       name: json['name'],
//       idNumber: json['idNumber'],
//       // Add all other properties of KTPData here
//     );
//   }
// }
