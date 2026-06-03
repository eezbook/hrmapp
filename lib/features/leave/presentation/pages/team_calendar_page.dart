import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../bloc/leave_bloc.dart';
import '../bloc/leave_event.dart';
import '../bloc/leave_state.dart';

class TeamCalendarPage extends StatefulWidget {
  const TeamCalendarPage({super.key});

  @override
  State<TeamCalendarPage> createState() => _TeamCalendarPageState();
}

class _TeamCalendarPageState extends State<TeamCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, List<String>> _calendar = {};

  @override
  void initState() {
    super.initState();
    _loadCalendar();
  }

  void _loadCalendar() {
    context.read<LeaveBloc>().add(
          LoadApprovals(status: 'approved'),
        );
    // Team calendar is loaded separately via repository
  }

  List<String> _getEmployeesOnLeave(DateTime day) {
    final key = HrmDateUtils.formatApi(day);
    return _calendar[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Team Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay:
                DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) => _getEmployeesOnLeave(day),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;
                return Positioned(
                  bottom: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events
                        .take(3)
                        .map((_) => Container(
                              width: 6,
                              height: 6,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) {
              setState(() => _focusedDay = focused);
            },
          ),
          const Divider(),
          if (_selectedDay != null) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'On leave: ${HrmDateUtils.formatDisplay(_selectedDay!)}',
                style: AppTextStyles.titleSmall,
              ),
            ),
            Expanded(
              child: Builder(builder: (context) {
                final names = _getEmployeesOnLeave(_selectedDay!);
                if (names.isEmpty) {
                  return Center(
                    child: Text(
                      'No team members on leave',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: names.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: AvatarWidget(name: names[i]),
                    title: Text(names[i]),
                  ),
                );
              }),
            ),
          ] else
            Expanded(
              child: Center(
                child: Text(
                  'Tap a date to see who is on leave',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
