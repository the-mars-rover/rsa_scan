/// Scan identity documents such as South African ID Cards, ID Books and
/// Driver's Licenses.
library rsa_scan;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsa_identification/rsa_identification.dart';
import 'package:rsa_scan/src/rsa_drivers_scanner.dart';
import 'package:rsa_scan/src/rsa_id_book_scanner.dart';
import 'package:rsa_scan/src/rsa_id_card_scanner.dart';
import 'package:rsa_scan/src/rsa_scanner.dart';

export 'package:rsa_identification/rsa_identification.dart';

/// A function for scanning an ID Document.
///
/// - [context] is the current build context.
///
/// - [idBookOverlay] is an optional widget to display as an overlay when scanning
/// an ID Book. If not provided, a sample ID Book will be displayed as the overlay.
///
/// - [idCardOverlay] is an optional widget to display as an overlay when scanning
/// an ID Card. If not provided, a sample ID Card will be displayed as the overlay.
///
/// - [driversOverlay] is an optional widget to display as an overlay when scanning
/// a Driver's License. If not provided, a sample Driver's license will be displayed
/// as the overlay.
///
/// Returns the scanned [RsaIdBook] or null if nothing was scanned.
Future<RsaIdDocument> scanId(
  BuildContext context, {
  Widget idBookOverlay,
  Widget idCardOverlay,
  Widget driversOverlay,
}) async {
  final scannedIdBook = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaScanner(
      idBookOverlay: idBookOverlay,
      idCardOverlay: idCardOverlay,
      driversOverlay: driversOverlay,
    ),
  ));

  return scannedIdBook;
}

/// A function for scanning an ID Book.
///
/// - [overlay] is an optional widget to display as an overlay when scanning
/// an ID Book. If not provided, a sample ID Book will be displayed as the overlay.
///
/// Returns the scanned [RsaIdBook] or null if nothing was scanned.
Future<RsaIdBook> scanIdBook(BuildContext context, {Widget overlay}) async {
  final scannedIdBook = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaIdBookScanner(overlay: overlay),
  ));

  return scannedIdBook;
}

/// A function for scanning an ID Card.
///
/// - [overlay] is an optional widget to display as an overlay when scanning
/// an ID Card. If not provided, a sample ID Card will be displayed as the overlay.
///
/// Returns the scanned [RsaIdCard] or null if nothing was scanned.
Future<RsaIdCard> scanIdCard(BuildContext context, {Widget overlay}) async {
  final scannedIdCard = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaIdCardScanner(overlay: overlay),
  ));

  return scannedIdCard;
}

/// A function for scanning a South African Drivers License.
///
/// - [overlay] is an optional widget to display as an overlay when scanning
/// a Driver's License. If not provided, a sample Driver's license will be displayed
/// as the overlay.
///
/// Returns the scanned [RsaDriversLicense] or null if nothing was scanned.
Future<RsaDriversLicense> scanDrivers(BuildContext context,
    {Widget overlay}) async {
  final scannedDrivers = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaDriversScanner(overlay: overlay),
  ));

  return scannedDrivers;
}
