<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# receipt_generator

A Flutter package to generate payment receipts in PDF format.

## Getting started

To use this package, add `receipt_generator` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  receipt_generator: ^0.0.1
``` 

## Usage

import 'package:receipt_generator/receipt_generator.dart';

void main() async {
  // Données du reçu
  Map<String, dynamic> data = {
    "number": "1234567890",
    "amount": 100.0,
    "transactionid": "TXN1234567890",
  };

  // Chemins des fichiers
  String logoPath = 'assets/logo.png';
  String fontPath = 'assets/open-sans.regular.ttf';

  // Message de remerciement
  String thankYouMessage = "Merci d'avoir utilisé notre service.";

  // Nom de l'entreprise
  String companyName = "Miss Tabooret Royal";

  // Couleur
  String colorHex = "bf8100";

  // Localisation
  Map<String, String> localization = {
    'receiptTitle': 'Reçu de Paiement',
    'clientContact': 'Contact client :',
    'paymentMode': 'Mode de paiement :',
    'amountPaid': 'Montant payé :',
    'transactionId': 'ID de transaction :',
    'dateTime': 'Date et heure :',
  };

  // Générer le reçu
  final generator = ReceiptGenerator();
  final pdfPath = await generator.generateReceipt(
    data,
    logoPath,
    fontPath,
    thankYouMessage,
    companyName,
    colorHex,
    localization,
  );

  // Afficher le chemin du fichier généré
  print('Receipt generated at: \$pdfPath');
}



