import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:rsa_identification/rsa_identification.dart';

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
  static Future<RsaIdCard> scanDrivers(CameraImage image) async {
    // TODO: Implement Scanning for Driver's License
    return null;
  }

  /// Scan the given [image] for an ID Card.
  ///
  /// Returns the [RsaIdCard] that was scanned or null if no ID Book was found.
  static Future<RsaIdCard> scanPassport(CameraImage image) async {
    // TODO: Implement Scanning for Passport
    return null;
  }

  /// Scans the given [image] for any barcodes and returns all the barcodes that were found.
  ///
  /// May throw an [Exception] if something went wrong.
  static Future<List<Barcode>> _scanBarcodes(CameraImage image) async {
    final FirebaseVisionImageMetadata metadata = _buildMetaData(image);

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final barcodeReader = FirebaseVision.instance.barcodeDetector();
    final barcodes = await barcodeReader.detectInImage(visionImage);

    return barcodes;
  }

  /// Converts the given [image] into a [FirebaseVisionImageMetadata] object
  /// and returns the object.
  ///
  /// May throw an [Exception] if something went wrong.
  static FirebaseVisionImageMetadata _buildMetaData(CameraImage image) {
    return FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes
            .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: currentPlane.bytesPerRow,
                height: currentPlane.height,
                width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation90);
  }
}
