import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_generator/receipt_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  test('generateReceipt doit générer un fichier PDF', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

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

    // Utiliser un répertoire temporaire pour les tests
    final tempDir = await Directory.systemTemp.createTemp('test_receipt');
    final pdfPath = await generator.generateReceipt(
      data,
      logoPath,
      thankYouMessage,
      fontPath,
      companyName,
      colorHex,
      localization,
      tempDir.path, // Passer le chemin du répertoire temporaire
    );

    expect(pdfPath, isNotEmpty);
  });
}
