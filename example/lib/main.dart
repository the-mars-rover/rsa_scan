import 'package:flutter/material.dart';
import 'package:rsa_scan/rsa_scan.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Example App',
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Scan ID Card'),
              onPressed: () async {
                final idCard = await scanIdCard(
                  context,
                );

                // Nothing was scanned
                if (idCard == null) return;

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IdCardDetailsPage(rsaIdCard: idCard),
                ));
              },
            ),
            Container(height: 8.0),
            ElevatedButton(
              child: Text('Scan ID Book'),
              onPressed: () async {
                final idBook = await scanIdBook(context);

                // Nothing was scanned
                if (idBook == null) return;

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => IdBookDetailsPage(rsaIdBook: idBook),
                ));
              },
            ),
            Container(height: 8.0),
            ElevatedButton(
              child: Text('Scan Driver\'s License'),
              onPressed: () async {
                final drivers = await scanDrivers(context);

                // Nothing was scanned
                if (drivers == null) return;

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DriversDetailsPage(rsaDrivers: drivers),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class IdCardDetailsPage extends StatelessWidget {
  final RsaIdCard rsaIdCard;

  const IdCardDetailsPage({Key key, @required this.rsaIdCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID Card Details')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('idNumber: ${rsaIdCard.idNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('firstNames: ${rsaIdCard.firstNames}'),
          ),
          Divider(),
          ListTile(
            title: Text('surname: ${rsaIdCard.surname}'),
          ),
          Divider(),
          ListTile(
            title: Text('birthDate: ${rsaIdCard.birthDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('gender: ${rsaIdCard.gender}'),
          ),
          Divider(),
          ListTile(
            title: Text('nationality: ${rsaIdCard.nationality}'),
          ),
          Divider(),
          ListTile(
            title: Text('countryOfBirth: ${rsaIdCard.countryOfBirth}'),
          ),
          Divider(),
          ListTile(
            title: Text('issueDate: ${rsaIdCard.issueDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('smartIdNumber: ${rsaIdCard.smartIdNumber}'),
          ),
        ],
      ),
    );
  }
}

class IdBookDetailsPage extends StatelessWidget {
  final RsaIdBook rsaIdBook;

  const IdBookDetailsPage({Key key, @required this.rsaIdBook})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID Book Details')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('idNumber: ${rsaIdBook.idNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('birthDate: ${rsaIdBook.birthDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('gender: ${rsaIdBook.gender}'),
          ),
          Divider(),
          ListTile(
            title: Text('citizenshipStatus: ${rsaIdBook.citizenshipStatus}'),
          ),
        ],
      ),
    );
  }
}

class DriversDetailsPage extends StatelessWidget {
  final RsaDriversLicense rsaDrivers;

  const DriversDetailsPage({Key key, @required this.rsaDrivers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver\'s License')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('licenseNumber: ${rsaDrivers.licenseNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('idNumber: ${rsaDrivers.idNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text('idNumberType: ${rsaDrivers.idNumberType}'),
          ),
          Divider(),
          ListTile(
            title: Text('idCountryOfIssue: ${rsaDrivers.idCountryOfIssue}'),
          ),
          Divider(),
          ListTile(
            title: Text('firstNames: ${rsaDrivers.firstNames}'),
          ),
          Divider(),
          ListTile(
            title: Text('surname: ${rsaDrivers.surname}'),
          ),
          Divider(),
          ListTile(
            title: Text('birthDate: ${rsaDrivers.birthDate}'),
          ),
          Divider(),
          ListTile(
            title: Text('gender: ${rsaDrivers.gender}'),
          ),
          Divider(),
          ListTile(
            title: Text('driverRestrictions: ${rsaDrivers.driverRestrictions}'),
          ),
          Divider(),
          ListTile(
            title: Text('issueDates: ${rsaDrivers.issueDates}'),
          ),
          Divider(),
          ListTile(
            title: Text('licenseIssueNumber: ${rsaDrivers.licenseIssueNumber}'),
          ),
          Divider(),
          ListTile(
            title: Text(
                'licenseCountryOfIssue: ${rsaDrivers.licenseCountryOfIssue}'),
          ),
          Divider(),
          ListTile(
            title: Text('prdpCode: ${rsaDrivers.prdpCode}'),
          ),
          Divider(),
          ListTile(
            title: Text('prdpExpiry: ${rsaDrivers.prdpExpiry}'),
          ),
          Divider(),
          ListTile(
            title: Text('validFrom: ${rsaDrivers.validFrom}'),
          ),
          Divider(),
          ListTile(
            title: Text('validTo: ${rsaDrivers.validTo}'),
          ),
          Divider(),
          ListTile(
            title: Text('vehicleCodes: ${rsaDrivers.vehicleCodes}'),
          ),
          Divider(),
          ListTile(
            title:
                Text('vehicleRestrictions: ${rsaDrivers.vehicleRestrictions}'),
          ),
        ],
      ),
    );
  }
}
