import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/auth_provider.dart';

class InterestTagsScreen extends ConsumerStatefulWidget {
  const InterestTagsScreen({super.key});

  @override
  ConsumerState<InterestTagsScreen> createState() => _InterestTagsScreenState();
}

class _InterestTagsScreenState extends ConsumerState<InterestTagsScreen> {
  bool _isSaving = false;

  Future<void> _onContinue() async {
    final selectedTags = ref.read(selectedInterestsProvider);
    if (selectedTags.length < 3) return;

    setState(() => _isSaving = true);
    try {
      final api = ref.read(apiServiceProvider);
      // Persist to backend
      await api.patch('/students/me', {'interests': selectedTags});
      
      // Update local state if needed (state is already updated in UI)
      if (!mounted) return;
      context.go(AppRoutes.suggestedClubs);
    } catch (e) {
      // Fallback for demo if backend unreachable
      if (!mounted) return;
      context.go(AppRoutes.suggestedClubs);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTags = ref.watch(selectedInterestsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'What are you into?',
                style: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pick 3 or more interests so we can suggest the best clubs for you',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: MockDataService.interestTags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    final tagColor = AppColors.categoryColors[tag] ?? AppColors.primary;

                    return GestureDetector(
                      onTap: () {
                        final notifier = ref.read(selectedInterestsProvider.notifier);
                        if (isSelected) {
                          notifier.state = selectedTags.where((t) => t != tag).toList();
                        } else {
                          notifier.state = [...selectedTags, tag];
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: isSelected
                              ? tagColor.withValues(alpha: 0.15)
                              : Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkCard
                                  : AppColors.surfaceVariant,
                          border: Border.all(
                            color: isSelected ? tagColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              Icon(Icons.check_circle, size: 18, color: tagColor),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              tag,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? tagColor
                                    : Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              if (selectedTags.isNotEmpty)
                Center(
                  child: Text(
                    '${selectedTags.length} selected',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Continue',
                  isLoading: _isSaving,
                  onPressed: selectedTags.length >= 3 ? _onContinue : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

