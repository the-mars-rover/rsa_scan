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
/// Returns the scanned [RsaIdBook] or null if nothing was scanned.
Future<RsaIdDocument> scanId(BuildContext context) async {
  final scannedIdBook = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaScanner(),
  ));

  return scannedIdBook;
}

/// A function for scanning an ID Book.
///
/// Returns the scanned [RsaIdBook] or null if nothing was scanned.
Future<RsaIdBook> scanIdBook(BuildContext context) async {
  final scannedIdBook = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaIdBookScanner(),
  ));

  return scannedIdBook;
}

/// A function for scanning an ID Card.
///
/// Returns the scanned [RsaIdCard] or null if nothing was scanned.
Future<RsaIdCard> scanIdCard(BuildContext context) async {
  final scannedIdCard = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaIdCardScanner(),
  ));

  return scannedIdCard;
}

/// A function for scanning a South African Drivers License.
///
/// Returns the scanned [RsaIdCard] or null if nothing was scanned.
Future<RsaDriversLicense> scanDrivers(BuildContext context) async {
  final scannedDrivers = await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => RsaDriversScanner(),
  ));

  return scannedDrivers;
}
