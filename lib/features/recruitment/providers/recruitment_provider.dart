import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';

final recruitmentRolesProvider = FutureProvider<List<RecruitmentRole>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return MockDataService.recruitmentRoles;
});

final applicationsProvider =
    StateNotifierProvider<ApplicationsNotifier, AsyncValue<List<Application>>>(
        (ref) {
  return ApplicationsNotifier();
});

class ApplicationsNotifier extends StateNotifier<AsyncValue<List<Application>>> {
  ApplicationsNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = AsyncValue.data(List.from(MockDataService.applications));
  }

  void addApplication(Application app) {
    state.whenData((applications) {
      state = AsyncValue.data([app, ...applications]);
    });
  }
}
