# rsa_scan

Scan identity documents such as South African ID Cards, ID Books and Driver's Licenses.

## Supported Documents
* [x] South African ID Cards
* [x] South African ID Books
* [X] South African Driver's Licenses

## Prerequisites

Since this plugin makes use of Firebase ML Vision for scanning, to use this plugin, add `rsa_scan` as a 
[dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). You must also configure Firebase for each 
platform project: Android and iOS (see https://firebase.google.com/docs/flutter/setup?platform=android).

### Android
Add the following declaration to your app's AndroidManifest.xml file:

```xml
<application ...>
  ...
  <meta-data
    android:name="com.google.firebase.ml.vision.DEPENDENCIES"
    android:value="barcode" />
</application>
```

### iOS
Add the line `platform :ios, '9.0'` in your iOS project `Podfile`.

You may also need to update your app's deployment target to 9.0 using Xcode. Otherwise, you may see
compilation errors.

Include the MLVisionBarcodeModel in your `Podfile`. Then run `pod update` in a terminal within the same directory as your 
`Podfile`.

```
pod 'Firebase/MLVisionBarcodeModel'
```

Add the following key to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```
<string>This app requires photo library access to function properly.</string>
<key>NSCameraUsageDescription</key>
```

## Usage

The package exposes to functions, namely `scanIdCard` and `scanIdBook`.

A simple usage example of `scanIdCard`:

```dart
import 'package:rsa_scan/rsa_scan.dart';

RsaIdCard idCard = await scanIdCard(context);
print(idCard.idNumber);
print(idCard.firstNames);
print(idCard.surname);
print(idCard.gender);
// See the API reference for the full set of available properties
```

A simple usage example of `scanIdBook`:

```dart
import 'package:rsa_scan/rsa_scan.dart';

RsaIdBook idBook = await scanIdBook(context);
print(idBook.idNumber);
print(idBook.birthDate);
print(idBook.gender);
print(idBook.citizenshipStatus);
// See the API reference for the full set of available properties
```

A simple usage example of `scanIdBook`:

```dart
import 'package:rsa_scan/rsa_scan.dart';

RsaDriversLicense driversLicense = await scanDrivers(context);
print(driversLicense.idNumber);
print(driversLicense.birthDate);
print(driversLicense.gender);
print(driversLicense.citizenshipStatus);
// See the API reference for the full set of available properties
```

For a more comprehensive example, please see [the example application](/example)

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/marcus-bornman/rsa_identification/issues).