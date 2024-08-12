
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_generator/receipt_generator.dart';

void main() {
  test('generateReceipt should generate a PDF file', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final generator = ReceiptGenerator();
    final data = {
      "number": "1234567890",
      "amount": 100.0,
      "transactionid": "TXN1234567890",
    };
    String logoPath = 'assets/kyrmann2.png';
    String fontPath = 'assets/open-sans.regular.ttf';
    String thankYouMessage = "Merci d'avoir utilisé notre service.";
    String companyName = "Miss Tabooret Royal";
    String colorHex = "bf8100";
    final localization = {
      'receiptTitle': 'Reçu de Paiement',
      'clientContact': 'Contact client :',
      'paymentMode': 'Mode de paiement :',
      'amountPaid': 'Montant payé :',
      'transactionId': 'ID de transaction :',
      'dateTime': 'Date et heure :',
    };

    final pdfPath = await generator.generateReceipt(
      data,
      logoPath,
      fontPath,
      thankYouMessage,
      companyName,
      colorHex,
      localization,
    );

    expect(pdfPath, isNotEmpty);
  });
}
