library receipt_generator;

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// A Calculator.
class ReceiptGenerator {
  Future<String> generateReceipt(
      Map<String, dynamic> data,
      String logoPath,
      String fontPath,
      String thankYouMessage,
      String companyName,
      String colorHex,
      Map<String, String> localization) async {
    final pdf = pw.Document();

    var fontData = await rootBundle.load(fontPath);
    final ttf = pw.Font.ttf(fontData);

    var imageData = await rootBundle.load(logoPath);
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    pw.Row row({required String text1, required String text2}) {
      return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(text1, style: pw.TextStyle(font: ttf, fontSize: 15.h)),
            pw.Text(text2, style: pw.TextStyle(font: ttf, fontSize: 15.h)),
          ]);
    }

    // Ajouter une page
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.SizedBox(height: 5.h),
                pw.Image(image, height: 50.h), // Ajouter l'image ici
                pw.Divider(),
                pw.SizedBox(height: 5.h),
                pw.Text("\${localization['receiptTitle']} - $companyName",
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 15.h,
                        color: PdfColor.fromHex(colorHex))),
                pw.SizedBox(height: 5.h),
                pw.Divider(),
                pw.SizedBox(
                  height: 20.h,
                ),
                row(
                    text1: localization['clientContact']!,
                    text2: "${data["number"]}"),
                pw.SizedBox(
                  height: 5.h,
                ),
                row(
                    text1: localization['paymentMode']!,
                    text2: "${data["amount"]}"),
                pw.SizedBox(
                  height: 5.h,
                ),
                row(
                    text1: localization['amountPaid']!,
                    text2: "${data["amount"]} FCFA"),
                pw.SizedBox(
                  height: 5.h,
                ),
                row(
                    text1: localization['transactionId']!,
                    text2: "${data["transactionid"]!}"),
                pw.SizedBox(
                  height: 5.h,
                ),
                row(
                    text1: localization['dateTime']!,
                    text2: DateTime.now().toString()),
                pw.Spacer(),
                pw.Divider(),
                pw.SizedBox(height: 5.h),
                pw.Text(thankYouMessage),
                pw.SizedBox(height: 5.h),
                pw.Divider(),
                pw.SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Enregistrer le document PDF
    final pdfData = await pdf.save();

    // Get the external storage directory
    var output = await getExternalStorageDirectory();
    var directory = Directory('${output?.path}/receipts');
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
  }
}
