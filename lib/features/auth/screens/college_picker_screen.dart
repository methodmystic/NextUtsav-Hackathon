import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/services/local_storage_service.dart';
import '../providers/auth_provider.dart';


class CollegePickerScreen extends ConsumerStatefulWidget {
  const CollegePickerScreen({super.key});

  @override
  ConsumerState<CollegePickerScreen> createState() => _CollegePickerScreenState();
}

class _CollegePickerScreenState extends ConsumerState<CollegePickerScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCollegeId = ref.watch(selectedCollegeProvider);
    final colleges = MockDataService.colleges.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Select Your College',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Find your institution to discover clubs and events near you',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search colleges...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: colleges.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.school_outlined,
                        title: 'No colleges found',
                        message: 'Try a different search term',
                      )
                    : ListView.separated(
                        itemCount: colleges.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final college = colleges[index];
                          final isSelected = selectedCollegeId == college.id;
                          return _CollegeTile(
                            name: college.name,
                            domain: college.domain,
                            logoUrl: college.logoUrl,
                            isSelected: isSelected,
                            onTap: () {
                              ref.read(selectedCollegeProvider.notifier).state =
                                  college.id;
                              ref.read(localStorageProvider).setSelectedCollege(college.id);
                            },

                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Continue',
                  onPressed: selectedCollegeId != null
                      ? () => context.go(AppRoutes.login)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollegeTile extends StatelessWidget {
  final String name;
  final String domain;
  final String logoUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _CollegeTile({
    required this.name,
    required this.domain,
    required this.logoUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            ClubAvatar(name: name, imageUrl: logoUrl, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    domain,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
