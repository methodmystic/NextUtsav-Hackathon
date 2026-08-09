import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/recruitment_provider.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  final String roleId;
  const ApplyScreen({super.key, required this.roleId});

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Arjun Mehta');
  final _emailController =
      TextEditingController(text: 'arjun.mehta@iitd.ac.in');
  final _whyController = TextEditingController();
  final _experienceController = TextEditingController();
  final _linksController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _whyController.dispose();
    _experienceController.dispose();
    _linksController.dispose();
    super.dispose();
  }

  RecruitmentRole? get _role {
    return MockDataService.recruitmentRoles
        .where((r) => r.id == widget.roleId)
        .firstOrNull;
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final role = _role;
    if (role != null) {
      ref.read(applicationsProvider.notifier).addApplication(
            Application(
              id: 'app_new_${DateTime.now().millisecondsSinceEpoch}',
              clubId: role.clubId,
              clubName: role.clubName,
              clubLogoUrl: role.clubLogoUrl,
              roleTitle: role.roleTitle,
              status: 'applied',
              appliedAt: DateTime.now(),
            ),
          );
    }

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: AppColors.success, size: 48),
        title: const Text('Application Submitted!'),
        content: const Text(
          'Your application has been submitted successfully. You\'ll be notified when there\'s an update.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/recruitment/status');
            },
            child: const Text('View Status'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = _role;
    if (role == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyStateWidget(
          icon: Icons.work_off_outlined,
          title: 'Role not found',
          message: 'This role may have been removed',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Apply — ${role.roleTitle}'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _handleSubmit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  AppButton(
                    label: _currentStep == 2 ? 'Submit' : 'Continue',
                    onPressed: details.onStepContinue,
                    isLoading: _isSubmitting,
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    AppButton(
                      label: 'Back',
                      onPressed: details.onStepCancel,
                      variant: AppButtonVariant.outline,
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Personal Info'),
              subtitle: const Text('Pre-filled from your profile'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  AppTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Why Join?'),
              subtitle: const Text('Tell us about your motivation'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  AppTextField(
                    label: 'Why do you want to join ${role.clubName}?',
                    hint:
                        'Share what excites you about this club and role...',
                    controller: _whyController,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            Step(
              title: const Text('Experience'),
              subtitle: const Text('Relevant background & links'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  AppTextField(
                    label: 'Relevant Experience',
                    hint: 'Describe your relevant experience...',
                    controller: _experienceController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Portfolio/Links (optional)',
                    hint: 'GitHub, LinkedIn, portfolio URL...',
                    controller: _linksController,
                    prefixIcon: Icons.link,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
