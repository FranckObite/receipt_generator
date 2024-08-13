library receipt_generator;

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptGenerator {
  Future<String> generateReceipt(
      Map<String, dynamic> data,
      String logoPath,
      String thankYouMessage,
      String fontPath,
      String companyName,
      String colorHex,
      Map<String, String> localization,
      [String? tempDirPath]) async {
    final pdf = pw.Document();

    var fontData = await rootBundle.load(fontPath);
    final ttf = pw.Font.ttf(fontData);

    var imageData = await rootBundle.load(logoPath);
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    pw.Row row({required String text1, required String text2}) {
      return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(text1, style: pw.TextStyle(font: ttf, fontSize: 12)),
            pw.Text(text2, style: pw.TextStyle(font: ttf, fontSize: 12)),
          ]);
    }

    // Ajouter une page
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.SizedBox(height: 5),
                pw.Image(image, height: 40), // Ajouter l'image ici
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text("${localization['receiptTitle']} - $companyName",
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        color: PdfColor.fromHex(colorHex))),
                pw.SizedBox(height: 5),
                pw.Divider(),
                pw.SizedBox(
                  height: 18,
                ),
                row(
                    text1: localization['clientContact']!,
                    text2: "${data["number"]}"),
                pw.SizedBox(
                  height: 5,
                ),
                row(
                    text1: localization['paymentMode']!,
                    text2: "${data["amount"]}"),
                pw.SizedBox(
                  height: 5,
                ),
                row(
                    text1: localization['amountPaid']!,
                    text2: "${data["amount"]} FCFA"),
                pw.SizedBox(
                  height: 5,
                ),
                row(
                    text1: localization['transactionId']!,
                    text2: "${data["transactionid"]!}"),
                pw.SizedBox(
                  height: 5,
                ),
                row(
                    text1: localization['dateTime']!,
                    text2: DateTime.now().toString()),
                pw.Spacer(),
                pw.Divider(),
                pw.SizedBox(height: 5),
                pw.Text(thankYouMessage,
                    style: pw.TextStyle(font: ttf, fontSize: 12)),
                pw.SizedBox(height: 5),
                pw.Divider(),
                pw.SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        },
      ),
    );

    try {
      // Enregistrer le document PDF
      final pdfData = await pdf.save();

      // Utiliser le répertoire temporaire si spécifié, sinon utiliser le répertoire de stockage externe
      Directory directory;
      if (tempDirPath != null) {
        directory = Directory(tempDirPath);
      } else {
        var output = await getExternalStorageDirectory();
        directory = Directory('${output?.path}/receipts');
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Create a file object with a unique filename
      final now = DateTime.now();
      final filename = "receipt_${now.toIso8601String()}.pdf";
      var file = File("${directory.path}/$filename");

      // Save the PDF data to the file
      await file.writeAsBytes(pdfData);

      return file.path;
    } catch (e) {
      rethrow;
    }
  }
}
