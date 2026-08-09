import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: April 2026\n\n'
              'Please read these Terms and Conditions carefully before using the NextUtsav mobile application operated by our team.\n\n'
              '1. Acceptance of Terms\n'
              'By accessing and using our app, you accept and agree to be bound by the terms and provision of this agreement.\n\n'
              '2. Privacy Policy\n'
              'Our Privacy Policy is part of these Terms. By using the app, you agree to our collection, use, and sharing of information as set forth in the Privacy Policy.\n\n'
              '3. User Account\n'
              'You are responsible for maintaining the confidentiality of your account credentials and for any activities that occur under your account.\n\n'
              '4. Rules of Conduct\n'
              'You agree not to use the application to engage in any prohibited conduct including spamming, harassment, and unauthorized data scraping.\n\n'
              '5. Modifications\n'
              'We reserve the right to modify these terms at any time. Your continued use of the application following the posting of changes will mean you accept those changes.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
