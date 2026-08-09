import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../providers/academic_provider.dart';

class CollegeCalendarScreen extends ConsumerStatefulWidget {
  const CollegeCalendarScreen({super.key});

  @override
  ConsumerState<CollegeCalendarScreen> createState() => _CollegeCalendarScreenState();
}

class _CollegeCalendarScreenState extends ConsumerState<CollegeCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final calendarItems = ref.watch(collegeCalendarProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('College Calendar', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              },
              eventLoader: (day) {
                return calendarItems.where((item) => isSameDay(item.date, day)).toList();
              },
              calendarStyle: CalendarStyle(
                todayDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                markerDecoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Schedule for ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(AppUtils.formatDate(_selectedDay ?? _focusedDay), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildEventList(calendarItems),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(List calendarItems) {
    final dayEvents = calendarItems.where((item) => isSameDay(item.date, _selectedDay)).toList();

    if (dayEvents.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available_outlined, size: 48, color: AppColors.textTertiary),
            SizedBox(height: 12),
            Text('No scheduled events for this day.', style: TextStyle(color: AppColors.textTertiary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final item = dayEvents[index];
        Color typeColor;
        switch (item.type) {
          case 'Exam': typeColor = AppColors.error; break;
          case 'Holiday': typeColor = Colors.green; break;
          default: typeColor = AppColors.primary;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: typeColor.withOpacity(0.2)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: typeColor.withOpacity(0.1),
              child: Icon(
                item.type == 'Exam' ? Icons.assignment_rounded : 
                item.type == 'Holiday' ? Icons.beach_access_rounded : Icons.campaign_rounded,
                color: typeColor,
              ),
            ),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.description, style: const TextStyle(fontSize: 12)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(item.type, style: TextStyle(color: typeColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}
