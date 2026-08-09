import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../providers/events_provider.dart';
import '../../../core/utils/attendance_calculator.dart';
import '../../../core/services/pdf_service.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  late ConfettiController _confettiController;
  bool _descExpanded = false;

  // Attendance Calculator State
  double _currentAttendance = 82.0;
  int _totalLectures = 150;
  bool _showCalculator = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleRegister(Event event) {
    // Academic Integration: Timetable Clash Detection
    // For demonstration, we simulate a clash if the event is scheduled between 9 AM and 4 PM on a weekday.
    bool hasClash = event.date.weekday >= 1 && 
                    event.date.weekday <= 5 && 
                    event.date.hour >= 9 && 
                    event.date.hour <= 16;

    if (hasClash) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
          title: const Text('Timetable Clash Detected'),
          content: Text(
            'This event overlaps with your academic schedule:\n\n'
            '• Data Structures & Algorithms\n'
            '• ${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][event.date.weekday - 1]} ${event.date.hour}:00 AM - ${event.date.hour + 2}:00 PM\n\n'
            'Attending this event may affect your attendance.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmRegistration(event);
              },
              child: const Text('Register Anyway'),
            ),
            FilledButton(
               onPressed: () {
                 Navigator.pop(context);
                 _confirmRegistration(event);
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Registered for non-clashing sessions only.')),
                 );
               },
               child: const Text('Skip Clashing Sessions'),
            ),
          ],
        ),
      );
    } else {
      _confirmRegistration(event);
    }
  }

  void _confirmRegistration(Event event) {
    ref.read(eventsListProvider.notifier).toggleRegistration(event.id);
    if (!event.isRegistered) {
      _confettiController.play();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Successfully registered!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsListProvider);

    return eventsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (events) {
        final event = events.where((e) => e.id == widget.eventId).firstOrNull;
        if (event == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyStateWidget(
              icon: Icons.event_busy_outlined,
              title: 'Event not found',
              message: 'This event may have been removed',
            ),
          );
        }

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Hero poster
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'event-poster-${event.id}',
                        child: Image.network(
                          event.posterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.primaryGradient,
                            ),
                            child: const Center(
                              child: Icon(Icons.event, size: 64, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),

                          // Date & Time
                          _InfoRow(
                            icon: Icons.calendar_today,
                            iconColor: AppColors.primary,
                            label: AppUtils.formatDate(event.date),
                            sublabel: AppUtils.formatTime(event.date),
                          ),
                          const SizedBox(height: 12),

                          // Venue
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            iconColor: AppColors.error,
                            label: event.venue,
                            sublabel: 'Tap to view on map',
                          ),
                          const SizedBox(height: 16),

                          // Club info
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.surfaceVariant,
                            ),
                            child: Row(
                              children: [
                                ClubAvatar(
                                  name: event.clubName,
                                  imageUrl: event.clubLogoUrl,
                                  size: 42,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.clubName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        event.type == 'college'
                                            ? 'College Event'
                                            : 'Club Event',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    minimumSize: const Size(0, 36),
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Juno-Safe Attendance Impact Calculator
                          _buildAttendanceImpactBox(context),
                          const SizedBox(height: 20),

                          // Description
                          Text(
                            'About',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _descExpanded = !_descExpanded),
                            child: Text(
                              event.description,
                              maxLines: _descExpanded ? null : 3,
                              overflow: _descExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          if (!_descExpanded)
                            TextButton(
                              onPressed: () =>
                                  setState(() => _descExpanded = true),
                              child: const Text('Read more'),
                            ),
                          const SizedBox(height: 16),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: event.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Volunteer section
                          if (event.volunteerSlotsOpen > 0) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: AppColors.accentGradient,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.volunteer_activism,
                                      color: Colors.white),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Volunteer Opportunities',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${event.volunteerSlotsOpen} slots available',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white
                                                .withValues(alpha: 0.85),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white),
                                    ),
                                    child: const Text('Apply'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // QR Ticket (if registered)
                          if (event.isRegistered) ...[
                            Text(
                              'Your Ticket',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    QrImageView(
                                      data:
                                          'nextutsav://ticket/${event.id}',
                                      version: QrVersions.auto,
                                      size: 180,
                                      eyeStyle: const QrEyeStyle(
                                        eyeShape: QrEyeShape.square,
                                        color: AppColors.primary,
                                      ),
                                      dataModuleStyle: const QrDataModuleStyle(
                                        dataModuleShape:
                                            QrDataModuleShape.square,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppUtils.formatDateTime(event.date),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Download PDF button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => AttendancePdfService.generateAndPrintPermission(
                                  studentName: 'Student Name', // Should come from profile data
                                  division: 'B',
                                  eventName: event.title,
                                  eventDate: event.date,
                                  clubName: event.clubName,
                                ),
                                icon: const Icon(Icons.picture_as_pdf_outlined),
                                label: const Text('Download Attendance Permission'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  side: const BorderSide(color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  particleDrag: 0.05,
                  emissionFrequency: 0.05,
                  numberOfParticles: 25,
                  gravity: 0.2,
                  colors: const [
                    AppColors.primary,
                    AppColors.accent,
                    Colors.amber,
                    Colors.pink,
                    Colors.cyan,
                  ],
                ),
              ),
            ],
          ),

          // Sticky register button
          bottomNavigationBar: event.isRegistered
              ? null
              : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: event.isRegistrationOpen
                            ? () => _handleRegister(event)
                            : null,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(
                          event.isRegistrationOpen
                              ? 'Register Now'
                              : 'Registration Closed',
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAttendanceImpactBox(BuildContext context) {
    // Import helper
    final impact = AttendanceCalculator.calculateImpact(
      currentPercentage: _currentAttendance,
      totalLectures: _totalLectures,
    );

    return Container(
      decoration: BoxDecoration(
        color: impact['isBelowThreshold'] ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: impact['isBelowThreshold'] ? Colors.red.shade200 : Colors.blue.shade200,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Icon(
          Icons.calculate_outlined,
          color: impact['isBelowThreshold'] ? Colors.red : AppColors.primary,
        ),
        title: Text(
          'Juno Attendance Impact',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: impact['isBelowThreshold'] ? Colors.red.shade900 : Colors.blue.shade900,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'Target: ${_currentAttendance.toInt()}% → ${impact['newPercentage']}%',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  impact['warning'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: impact['isBelowThreshold'] ? Colors.red : Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Attendance %', style: TextStyle(fontSize: 11)),
                          Slider(
                            value: _currentAttendance,
                            min: 0,
                            max: 100,
                            activeColor: AppColors.primary,
                            onChanged: (v) => setState(() => _currentAttendance = v),
                          ),
                        ],
                      ),
                    ),
                    Text('${_currentAttendance.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  'Calculated based on average 5 lectures/day. Missing 1 day will drop your attendance by ${impact['drop']}%.',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? sublabel;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            if (sublabel != null)
              Text(
                sublabel!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
