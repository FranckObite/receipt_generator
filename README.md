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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:receipt_generator/receipt_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReceiptGeneratorScreen(),
    );
  }
}

class ReceiptGeneratorScreen extends StatefulWidget {
  const ReceiptGeneratorScreen({super.key});

  @override
  _ReceiptGeneratorScreenState createState() => _ReceiptGeneratorScreenState();
}

class _ReceiptGeneratorScreenState extends State<ReceiptGeneratorScreen> {
  bool _isLoading = false;

  Future<void> _generateReceipt() async {
    setState(() {
      _isLoading = true;
    });

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
      'receiptTitle': 'Payment Receipt',
      'clientContact': 'Contact customer :',
      'paymentMode': 'Payment method :',
      'amountPaid': 'Amount paid :',
      'transactionId': 'Transaction ID :',
      'dateTime': 'Date and time :',
    };

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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Generator Example'),
      ),
      body: Center(
        child: _isLoading
            ? SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey),
                  );
                },
              ) // Afficher l'indicateur de chargement
            : ElevatedButton(
                onPressed: _generateReceipt,
                child: const Text('Generate Receipt'),
              ),
      ),
    );
  }
}

```

# Author

Franck Obité
obitefrank@gmail.com

# License

MIT License
