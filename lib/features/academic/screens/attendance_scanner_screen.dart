import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/attendance_service.dart';
import '../../../core/models/academic_models.dart';

class AttendanceScannerScreen extends ConsumerStatefulWidget {
  const AttendanceScannerScreen({super.key});

  @override
  ConsumerState<AttendanceScannerScreen> createState() => _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState extends ConsumerState<AttendanceScannerScreen> {
  bool _isScanned = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Attendance'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_isScanned || _isProcessing) return;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                setState(() => _isScanned = true);
                final String? code = barcodes.first.rawValue;
                _handleScannedCode(code);
              }
            },
          ),
          // Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Align Student Ticket QR inside the frame',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleScannedCode(String? code) async {
    if (code == null) return;
    
    setState(() => _isProcessing = true);

    // Mock subject for demo
    const subject = "Web Technologies";
    
    final success = await ref.read(attendanceServiceProvider).markAttendance(
      studentId: code, 
      subject: subject, 
      status: AttendanceStatus.present,
    );

    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (success) {
      _showSuccessSheet(code);
    } else {
      _showErrorSnackBar();
    }
  }

  void _showSuccessSheet(String code) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.success, size: 64),
              const SizedBox(height: 16),
              const Text('Attendance Verified!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Student ID: $code', style: const TextStyle(color: AppColors.textTertiary)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _isScanned = false);
                  },
                  child: const Text('Next Student'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to verify attendance. Please try again.'),
        backgroundColor: AppColors.error,
      ),
    );
    setState(() => _isScanned = false);
  }
}
