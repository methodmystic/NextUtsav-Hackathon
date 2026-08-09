import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(eventFilterProvider);
    final isListView = ref.watch(eventViewModeProvider);
    final eventsAsync = ref.watch(eventsListProvider);
    final events = ref.watch(filteredEventsListProvider);
    final filters = ['All', 'Registered', 'Upcoming', 'Past'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: Icon(
              isListView ? Icons.calendar_month_outlined : Icons.view_list_outlined,
            ),
            onPressed: () =>
                ref.read(eventViewModeProvider.notifier).state = !isListView,
          ),
        ],
      ),
      body: eventsAsync.when(
        loading: () => ListView.builder(
          itemCount: 3,
          itemBuilder: (_, __) => const CardSkeleton(),
        ),
        error: (e, _) => EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Failed to load events',
          message: e.toString(),
          actionLabel: 'Retry',
          onAction: () => ref.read(eventsListProvider.notifier).refresh(),
        ),
        data: (_) => Column(
          children: [
            // Filter chips
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final f = filters[index];
                  final isSelected = filter == f;
                  return GestureDetector(
                    onTap: () =>
                        ref.read(eventFilterProvider.notifier).state = f,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceVariant,
                        border: isSelected
                            ? Border.all(color: AppColors.primary)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          f,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Calendar or list view
            Expanded(
              child: isListView
                  ? _buildListView(context, ref, events)
                  : _buildCalendarView(context, ref, events),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
      BuildContext context, WidgetRef ref, List events) {
    if (events.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.event_busy_outlined,
        title: 'No events found',
        message: 'Try a different filter or check back later',
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => ref.read(eventsListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onTap: () => context.push('/event/${event.id}'),
            onRegister: () => ref
                .read(eventsListProvider.notifier)
                .toggleRegistration(event.id),
          );
        },
      ),
    );
  }

  Widget _buildCalendarView(
      BuildContext context, WidgetRef ref, List events) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 90)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
            markerSize: 6,
          ),
          eventLoader: (day) {
            return events
                .where((e) =>
                    e.date.year == day.year &&
                    e.date.month == day.month &&
                    e.date.day == day.day)
                .toList();
          },
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: ClubAvatar(
                    name: event.clubName, imageUrl: event.clubLogoUrl),
                title: Text(event.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle:
                    Text('${AppUtils.formatDate(event.date)} • ${event.venue}'),
                onTap: () => context.push('/event/${event.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
