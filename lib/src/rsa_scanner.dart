import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:rsa_identification/rsa_identification.dart';
import 'package:rsa_scan/rsa_scan.dart';

abstract class RsaScanner extends StatefulWidget {
  @override
  _RsaScannerState createState() => _RsaScannerState();

  RsaIdDocument documentFromBarcode(Barcode barcode);

  String title();

  String hint();
}

class _RsaScannerState extends State<RsaScanner> {
  CameraController? _controller;
  BarcodeScanner _barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  bool _isBusy = false;
  RsaIdDocument? _scannedDocument;

  @override
  void initState() {
    super.initState();
    _startLiveFeed();
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller?.value.isInitialized == true
          ? Container(
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CameraPreview(_controller!),
                ],
              ),
            )
          : Container(),
      appBar: AppBar(title: Text(widget.title())),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(widget.hint(), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = await availableCameras().then((cameras) =>
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back));
    _controller =
        CameraController(camera, ResolutionPreset.veryHigh, enableAudio: false);

    _controller?.initialize().then((_) {
      if (!mounted) return;
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final inputImage = _inputImageFromCameraImage(image);
    _tryScanDocumentFromImage(inputImage);
  }

  InputImage _inputImageFromCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final imageRotation = InputImageRotationMethods.fromRawValue(
            _controller!.description.sensorOrientation) ??
        InputImageRotation.Rotation_0deg;
    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;
    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();
    final data = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: data);

    return inputImage;
  }

  Future _tryScanDocumentFromImage(InputImage image) async {
    if (_isBusy) return null;
    _isBusy = true;
    final barcodes = await _barcodeScanner.processImage(image);

    for (Barcode barcode in barcodes) {
      try {
        _scannedDocument = widget.documentFromBarcode(barcode);
        Navigator.of(context).pop(_scannedDocument);
        return;
      } catch (e) {}
    }

    _isBusy = false;
  }
}
