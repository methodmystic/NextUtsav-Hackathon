import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/app_utils.dart';

class AttendancePdfService {
  static Future<void> generateAndPrintPermission({
    required String studentName,
    required String division,
    required String eventName,
    required DateTime eventDate,
    required String clubName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('OFFICIAL EVENT PARTICIPATION REQUEST',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('To,'),
                pw.Text('The Head of Department,'),
                pw.Text('D.Y. Patil College of Engineering (DYPCOE), Akurdi.'),
                pw.SizedBox(height: 30),
                pw.Text('Subject: Permission for Academic Leave for Event Participation'),
                pw.SizedBox(height: 20),
                pw.Text('Respected Sir/Madam,'),
                pw.SizedBox(height: 10),
                pw.Text(
                    'I, $studentName, a student from Division $division, am writing to request permission to attend the upcoming event "$eventName" organized by $clubName.'),
                pw.SizedBox(height: 10),
                pw.Text(
                    'The event is scheduled for ${AppUtils.formatDate(eventDate)} starting at ${AppUtils.formatTime(eventDate)}.'),
                pw.SizedBox(height: 10),
                pw.Text(
                    'I understand that it is my responsibility to cover any academic loss during this period. I request you to kindly grant me the necessary leave and consider my attendance for the same.'),
                pw.SizedBox(height: 30),
                pw.Text('Verification Details:'),
                pw.SizedBox(height: 5),
                pw.Text('• Participation ID: UTSAV-${DateTime.now().millisecondsSinceEpoch}'),
                pw.Text('• Verification App: NextUtsav (Verified Student Partner)'),
                pw.SizedBox(height: 40),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('____________________'),
                        pw.Text('Student Signature'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('____________________'),
                        pw.Text('Faculty/Club In-charge'),
                      ],
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: 'https://nextutsav.com/verify/student/${studentName.replaceAll(' ', '_')}',
                        width: 100,
                        height: 100,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Scan to verify attendance on NextUtsav Portal',
                          style: const pw.TextStyle(fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Permission_${studentName.replaceAll(' ', '_')}.pdf',
    );
  }

  static Future<void> generateCertificate({
    required String studentName,
    required String eventName,
    required DateTime eventDate,
    required String clubName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.amber, width: 10),
            ),
            padding: const pw.EdgeInsets.all(20),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.amber, width: 2),
              ),
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('CERTIFICATE OF PARTICIPATION',
                      style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.SizedBox(height: 20),
                  pw.Text('This is to certify that', style: const pw.TextStyle(fontSize: 16)),
                  pw.SizedBox(height: 10),
                  pw.Text(studentName,
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                  pw.SizedBox(height: 10),
                  pw.Text('has successfully participated in the event', style: const pw.TextStyle(fontSize: 16)),
                  pw.SizedBox(height: 10),
                  pw.Text(eventName,
                      style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
                  pw.SizedBox(height: 10),
                  pw.Text('organized by $clubName', style: const pw.TextStyle(fontSize: 16)),
                  pw.SizedBox(height: 10),
                  pw.Text('on ${AppUtils.formatDate(eventDate)} at D.Y. Patil College of Engineering, Akurdi.',
                      style: pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 40),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text('____________________', style: const pw.TextStyle(fontSize: 12)),
                          pw.Text('Event Coordinator', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: 'https://nextutsav.com/verify/cert/${DateTime.now().millisecondsSinceEpoch}',
                            width: 60,
                            height: 60,
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text('Verify Certificate', style: const pw.TextStyle(fontSize: 8)),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text('____________________', style: const pw.TextStyle(fontSize: 12)),
                          pw.Text('Principal/Faculty In-charge', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Certificate_${eventName.replaceAll(' ', '_')}.pdf',
    );
  }
}
