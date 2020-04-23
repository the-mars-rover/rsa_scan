import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../rsa_scan.dart';
import 'scanner_utils.dart';

enum IdDocumentType { idCard, idBook, driversLicense, passport }

/// Used to scan ID Cards.
///
/// Will pop with the [RsaIdCard] that was scanned or with null if nothing was scanned.
class RsaScanner extends StatefulWidget {
  @override
  _RsaScannerState createState() => _RsaScannerState();
}

/// The state for the [RsaIdCardScanner] widget.
class _RsaScannerState extends State<RsaScanner> with WidgetsBindingObserver {
  /// The controller for the camera being used.
  CameraController _cameraController;

  /// True while the camera is being initialized.
  bool _loading = true;

  /// The ID Card that has been successfully scanned.
  RsaIdCard _scannedDocument;

  /// True while the scanner is busy processing an image frame.
  bool _scannerBusy = false;

  /// The type of ID Document being scanned
  IdDocumentType _selectedType = IdDocumentType.idCard;

  /// The overridden initializer. Initializes the camera nd scanner when the widget
  /// is first opened.
  @override
  void initState() {
    super.initState();
    _initCameraAndScanner();
  }

  /// The overridden dispose method. First, disposes [_cameraController].
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// The overridden didChangeAppLifecycleState method implemented to deal with some
  /// issues associated with the camera plugin on android.
  ///
  /// Disposes [_cameraController] when the app is in the background and re-initializes
  /// it when the app is back in the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _cameraController?.dispose();
    }

    if (state == AppLifecycleState.resumed) {
      _initCameraAndScanner(); //// on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  /// The helper method for instantiating and initializing [_cameraController] and
  /// starting the stream of image frames for scanning.
  ///
  /// Sets [_loading] to true at the start of the method and back to false when it is finished.
  Future<void> _initCameraAndScanner() async {
    setState(() => _loading = true);

    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back),
      ResolutionPreset.max,
    );
    await _cameraController.initialize();
    if (!mounted) {
      return;
    }

    await _cameraController.startImageStream(_scanImageFrame);

    setState(() => _loading = false);
  }

  /// The helper method for scanning each image frame.
  ///
  /// If [_scannerBusy] is already true, this method will do nothing. Otherwise,
  /// it will set [_scannerBusy] to true and scan the given image frame for an
  /// ID Card before setting [_scannerBusy] back to false.
  ///
  /// Notably, if an ID Card is found in the given frame, [_scannerBusy] will
  /// stay true.
  Future<void> _scanImageFrame(CameraImage availableImage) async {
    if (_scannerBusy) return;

    _scannerBusy = true;
    var scannedDocument;
    switch (_selectedType) {
      case IdDocumentType.idCard:
        scannedDocument = await ScannerUtils.scanIdCard(availableImage);
        break;
      case IdDocumentType.idBook:
        scannedDocument = await ScannerUtils.scanIdBook(availableImage);
        break;
      case IdDocumentType.driversLicense:
        scannedDocument = await ScannerUtils.scanDrivers(availableImage);
        break;
      case IdDocumentType.passport:
        scannedDocument = await ScannerUtils.scanPassport(availableImage);
        break;
    }
    if (scannedDocument != null) {
      setState(() {
        this._scannedDocument = scannedDocument;
      });

      return;
    }
    _scannerBusy = false;
  }

  /// The build method.
  ///
  /// If [_loading] is true (ie. the camera is still being initialized),
  /// A loading screen will be displayed.
  ///
  /// If [_scannedDocument] is not null (ie. An ID Card has been successfully scanned),
  /// a PostFrameCallback is added to pop with the scanned ID Card as soon as the
  /// build method is finished. In this case, the build function itself just
  /// returns an empty Container.
  ///
  /// If [_loading] is false and [_scannedDocument] is still null, a camera preview
  /// is shown with some indicators hinting at how to scan the ID Card.
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_scannedDocument != null) {
      SchedulerBinding.instance.addPostFrameCallback((timestamp) {
        Navigator.of(context).pop(_scannedDocument);
      });
      return Container();
    }

    return Scaffold(
      body: Stack(
        alignment: FractionalOffset.center,
        children: <Widget>[
          Positioned.fill(
            child: AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController)),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Builder(
                builder: (context) {
                  switch (_selectedType) {
                    case IdDocumentType.idCard:
                      return Image.asset(
                        'assets/sample_id_card.png',
                        package: 'rsa_scan',
                        fit: BoxFit.fitWidth,
                      );
                    case IdDocumentType.idBook:
                      return Image.asset(
                        'assets/sample_id_book.jpg',
                        package: 'rsa_scan',
                        fit: BoxFit.fitWidth,
                      );
                    case IdDocumentType.driversLicense:
                      return Image.asset(
                        'assets/sample_id_card.png',
                        package: 'rsa_scan',
                        fit: BoxFit.fitWidth,
                      );
                    case IdDocumentType.passport:
                      return Image.asset(
                        'assets/sample_id_book.jpg',
                        package: 'rsa_scan',
                        fit: BoxFit.fitWidth,
                      );
                    default:
                      return Image.asset(
                        'assets/sample_id_card.png',
                        package: 'rsa_scan',
                        fit: BoxFit.fitWidth,
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        currentIndex: _selectedType.index,
        onTap: (index) {
          setState(() {
            _selectedType = IdDocumentType.values.elementAt(index);
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            title: Text('ID Card'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('ID Book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            title: Text('Driver\'s'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('Passport'),
          ),
        ],
      ),
    );
  }
}
