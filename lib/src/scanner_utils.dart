import 'package:firebase_ml_vision_raw_bytes/firebase_ml_vision_raw_bytes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:rsa_identification/rsa_identification.dart';
import 'package:rsa_scan/rsa_scan.dart';

/// Some utilities for scanning [CameraImage]'s for identity documents.
class ScannerUtils {
  /// Scan the given [image] for an ID Book.
  ///
  /// Returns the [RsaIdBook] that was scanned or null if no ID Book was found.
  static Future<RsaIdBook> scanIdBook(CameraImage image) async {
    try {
      final barcodes = await _scanBarcodes(image);
      if (barcodes.isEmpty) {
        return null;
      }

      return RsaIdBook.fromIdNumber(barcodes.first.rawValue);
    } catch (e) {
      return null;
    }
  }

  /// Scan the given [image] for an ID Card.
  ///
  /// Returns the [RsaIdCard] that was scanned or null if no ID Book was found.
  static Future<RsaIdCard> scanIdCard(CameraImage image) async {
    try {
      final barcodes = await _scanBarcodes(image);
      if (barcodes.isEmpty) {
        return null;
      }

      return RsaIdCard.fromBarcodeString(barcodes.first.rawValue);
    } catch (e) {
      return null;
    }
  }

  /// Scan the given [image] for a Driver's license.
  ///
  /// Returns the [RsaIdCard] that was scanned or null if no ID Book was found.
  static Future<RsaDriversLicense> scanDrivers(CameraImage image) async {
    try {
      final barcodes = await _scanBarcodes(image);
      if (barcodes.isEmpty) {
        return null;
      }

      return RsaDriversLicense.fromBarcodeBytes(barcodes.first.rawBytes);
    } catch (e) {
      return null;
    }
  }

  /// Scan the given [image] for an Passport.
  ///
  /// Returns the [RsaIdCard] that was scanned or null if no ID Book was found.
  static Future<RsaIdCard> scanPassport(CameraImage image) async {
    try {
      final visionText = await _scanText(image);
      if (visionText.text.isEmpty) {
        return null;
      }

      // TODO: Get passport from text
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Scans the given [image] for any barcodes and returns all the barcodes that were found.
  ///
  /// May throw an [Exception] if something went wrong.
  static Future<List<Barcode>> _scanBarcodes(CameraImage image) async {
    final visionImage = _buildVisionImage(image);
    final barcodeReader = FirebaseVision.instance.barcodeDetector();
    final barcodes = await barcodeReader.detectInImage(visionImage);

    return barcodes;
  }

  /// Scans the given [image] for any machine readable zones and returns all the barcodes that were found.
  ///
  /// May throw an [Exception] if something went wrong.
  static Future<VisionText> _scanText(CameraImage image) async {
    final visionImage = _buildVisionImage(image);
    final textReader = FirebaseVision.instance.textRecognizer();
    final visionText = await textReader.processImage(visionImage);

    return visionText;
  }

  /// Converts the given [image] into a [FirebaseVisionImageMetadata] object
  /// and returns the object.
  ///
  /// May throw an [Exception] if something went wrong.
  static FirebaseVisionImage _buildVisionImage(CameraImage image) {
    final metadata = FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes
            .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: currentPlane.bytesPerRow,
                height: currentPlane.height,
                width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation90);

    return FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
  }
}
