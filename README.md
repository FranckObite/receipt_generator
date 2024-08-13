# receipt_generator

A Flutter package to generate payment receipts in PDF format.

## Getting started

To use this package, add `receipt_generator` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  receipt_generator: ^0.0.3
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:receipt_generator/receipt_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final generator = ReceiptGenerator();
  final data = {
    "number": "1234567890",
    "amount": 100.0,
    "transactionid": "TXN1234567890",
  };
  String logoPath = 'assets/kyrmann2.png';
  String fontPath = "assets/open-sans.regular.ttf";

  String thankYouMessage = "Merci d'avoir utilisé notre service.";
  String companyName = "Mlle Tabooret Royal";
  String colorHex = "bf8100";
  final localization = {
    'receiptTitle': 'Reçu de Paiement',
    'clientContact': 'Contacter le client :',
    'paymentMode': 'Mode de paiement :',
    'amountPaid': 'Montant payé :',
    'transactionId': 'ID de transaction :',
    'dateTime': 'Date et heure :',
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Receipt Generator Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {


              try {
                final pdfPath = await generator.generateReceipt(
                  data,
                  logoPath,
                  thankYouMessage,
                  fontPath,
                  companyName,
                  colorHex,
                  localization,
                );

                print('PDF generated at: $pdfPath');
              } catch (e) {
                print('Error generating PDF: $e');
              }
            },
            child: Text('Generate Receipt'),
          ),
        ),
      ),
    );
  }
}
```
