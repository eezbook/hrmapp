import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubit/hrm_header_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/attendance_record_model.dart';
import '../cubit/attendance_cubit.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);
const _golden = Color(0xFFF5A623);
const _pageBg = Color(0xFFF5F7FF);

String _toAmPm(String? t) {
  if (t == null) return '--:--';
  final parts = t.split(':');
  if (parts.length < 2) return t;
  final h = int.tryParse(parts[0]);
  if (h == null) return t;
  final period = h < 12 ? 'AM' : 'PM';
  final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$h12:${parts[1]} $period';
}

const _clrPresent  = Color(0xFF4CAF50);
const _clrExDelay  = Color(0xFF1A237E);
const _clrAbsent   = Color(0xFFEF4444);
const _clrLeave    = Color(0xFFE0E0E0);
const _clrVisit    = Color(0xFFFFC107);
const _clrWeekend  = Color(0xFF546E7A);
const _clrDelay    = Color(0xFF42A5F5);
const _clrHoliday  = Color(0xFFFF7043);

class AttendanceHomePage extends StatefulWidget {
  const AttendanceHomePage({super.key});

  @override
  State<AttendanceHomePage> createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceCubit>().load();
    getIt<HrmHeaderCubit>().update(
      subtitle: 'Check in / out',
      clearBottom: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceOfflineQueued) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.amber.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          if (state is! AttendanceLoaded) return;
          if (state.punchStatus == PunchStatus.success) {
            final today = state.todayRecord;
            final isCheckOut = today?.checkOut != null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isCheckOut
                      ? 'Checked out successfully at ${_toAmPm(today?.checkOut)}'
                      : 'Checked in successfully at ${_toAmPm(today?.checkIn)}',
                ),
                backgroundColor: _clrPresent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.punchStatus == PunchStatus.error &&
              state.punchError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.punchError!),
                backgroundColor: _clrAbsent,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _purple),
            );
          }
          if (state is AttendanceError) {
            return _ErrorBody(
              message: state.message,
              onRetry: () => context.read<AttendanceCubit>().load(),
            );
          }
          if (state is AttendanceLoaded) {
            return RefreshIndicator(
              color: _purple,
              onRefresh: () => context
                  .read<AttendanceCubit>()
                  .load(month: state.month, year: state.year),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TodayPunchCard(
                      todayRecord: state.todayRecord,
                      punchStatus: state.punchStatus,
                      onCheckIn: () =>
                          context.read<AttendanceCubit>().checkIn(),
                      onCheckOut: () =>
                          context.read<AttendanceCubit>().checkOut(),
                    ),
                    const SizedBox(height: 20),
                    _WeeklyAttendanceCard(state: state),
                    const SizedBox(height: 24),
                    Text(
                      'Attendance',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: _navy,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _ActionGrid(),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Today Punch Card ──────────────────────────────────────────────────────────

class _TodayPunchCard extends StatelessWidget {
  final AttendanceRecordModel? todayRecord;
  final PunchStatus punchStatus;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const _TodayPunchCard({
    required this.todayRecord,
    required this.punchStatus,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  bool get _isLoading => punchStatus == PunchStatus.loading;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateLabel =
        '${_weekdayName(now.weekday)}, ${now.day} ${_monthName(now.month)} ${now.year}';

    final checkedIn  = todayRecord?.checkIn  != null;
    final checkedOut = todayRecord?.checkOut != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, Color(0xFF2D3A8C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Attendance",
                style: AppTextStyles.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              if (todayRecord != null)
                _StatusChip(
                  status: todayRecord!.status,
                  label: todayRecord!.statusLabel,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            dateLabel,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _TimeBlock(
                label: 'Check In',
                time: _toAmPm(todayRecord?.checkIn),
                icon: Icons.login_rounded,
                active: checkedIn,
              ),
              const SizedBox(width: 16),
              _TimeBlock(
                label: 'Check Out',
                time: _toAmPm(todayRecord?.checkOut),
                icon: Icons.logout_rounded,
                active: checkedOut,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!checkedOut)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed:
                    _isLoading ? null : (checkedIn ? onCheckOut : onCheckIn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _golden,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _golden.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        checkedIn ? Icons.logout_rounded : Icons.login_rounded,
                        size: 20,
                      ),
                label: Text(
                  _isLoading
                      ? 'Verifying location…'
                      : (checkedIn ? 'Check Out' : 'Check In'),
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: _clrPresent, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Attendance complete for today',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static String _weekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[(weekday - 1).clamp(0, 6)];
  }

  static String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[(month - 1).clamp(0, 11)];
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final bool active;

  const _TimeBlock({
    required this.label,
    required this.time,
    required this.icon,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(active ? 0.15 : 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(active ? 0.3 : 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? _golden : Colors.white38, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: active ? Colors.white : Colors.white38,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final String label;

  const _StatusChip({required this.status, required this.label});

  Color _chipColor() {
    switch (status) {
      case 'present':  return _clrPresent;
      case 'late':     return _clrDelay;
      case 'absent':   return _clrAbsent;
      case 'on_leave': return Colors.blueGrey;
      case 'half_day': return _clrExDelay;
      case 'holiday':  return _clrHoliday;
      case 'wfh':      return _clrVisit;
      default:         return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _chipColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label.isNotEmpty ? label : status,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ── Monthly Attendance Card ────────────────────────────────────────────────────

class _WeeklyAttendanceCard extends StatelessWidget {
  final AttendanceLoaded state;
  const _WeeklyAttendanceCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final summary = state.summary;
    final cubit   = context.read<AttendanceCubit>();

    final legendData = [
      _LegendData(_clrPresent,  'Present',  summary.presentDays),
      _LegendData(_clrAbsent,   'Absent',   summary.absentDays),
      _LegendData(_clrLeave,    'Leave',    summary.leaveDays),
      _LegendData(_clrDelay,    'Late',     summary.lateDays),
      _LegendData(_clrExDelay,  'Half Day', summary.halfDays),
      _LegendData(_clrVisit,    'Travel',   summary.travelDays),
      _LegendData(_clrWeekend,  'Weekend',  summary.weekendDays),
      _LegendData(_clrHoliday,  'Holiday',  summary.holidayDays),
    ];

    final segments = legendData
        .where((d) => d.count > 0)
        .map((d) => _DonutSegment(d.count.toDouble(), d.color))
        .toList();

    if (segments.isEmpty) segments.add(_DonutSegment(1, _clrLeave));

    final pct = summary.attendancePercentage.toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                summary.monthName,
                style: AppTextStyles.titleSmall.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  _NavButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: cubit.prevMonth,
                  ),
                  const SizedBox(width: 4),
                  _NavButton(
                    icon: Icons.chevron_right_rounded,
                    onTap: cubit.canGoNext ? cubit.nextMonth : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _DonutPainter(segments: segments),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$pct%',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: _navy,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          'Attendance',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: legendData
                      .where((d) => d.count > 0)
                      .map((d) => _LegendItem(
                            color: d.color,
                            label: d.label,
                            count: d.count,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: _pageBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _StatPill(
                  label: 'Working Days',
                  value: '${summary.workingDays}',
                  color: _navy,
                ),
                _StatPill(
                  label: 'Present',
                  value: '${summary.presentDays}',
                  color: _clrPresent,
                ),
                _StatPill(
                  label: 'Absent',
                  value: '${summary.absentDays}',
                  color: _clrAbsent,
                ),
                _StatPill(
                  label: 'Avg Hrs',
                  value: summary.averageWorkingHours.toStringAsFixed(1),
                  color: _purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendData {
  final Color color;
  final String label;
  final int count;
  const _LegendData(this.color, this.label, this.count);
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  const _LegendItem({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            '$count',
            style: AppTextStyles.bodySmall.copyWith(
              color: _navy,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: active ? _navy.withOpacity(0.08) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? _navy : Colors.grey.shade400,
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade500,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Donut chart painter ────────────────────────────────────────────────────────

class _DonutSegment {
  final double value;
  final Color color;
  const _DonutSegment(this.value, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  const _DonutPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold(0.0, (s, e) => s + e.value);
    if (total == 0) return;

    final rect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    const strokeWidth = 22.0;
    double startAngle = -math.pi / 2;
    const gapAngle = 0.03;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    for (final seg in segments) {
      final sweep = (seg.value / total) * 2 * math.pi - gapAngle;
      if (sweep <= 0) continue;
      paint.color = seg.color;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => old.segments != segments;
}

// ── Action tiles grid ─────────────────────────────────────────────────────────

class _ActionGrid extends StatelessWidget {
  const _ActionGrid();

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _ActionTile(
        icon: Icons.person_pin_rounded,
        label: 'My\nAttendance',
        onTap: () {},
      ),
      _ActionTile(
        icon: Icons.assignment_ind_outlined,
        label: 'View\nAttendance',
        onTap: () {},
      ),
      _ActionTile(
        icon: Icons.fact_check_outlined,
        label: 'Recon.\nApplication',
        onTap: () {},
      ),
      _ActionTile(
        icon: Icons.how_to_reg_outlined,
        label: 'Recon.\nApproval',
        onTap: () {},
      ),
      _ActionTile(
        icon: Icons.location_on_outlined,
        label: 'Remote Att.\nApproval',
        onTap: () {},
      ),
      _ActionTile(
        icon: Icons.qr_code_scanner_rounded,
        label: 'QR Scan /\nFace Att.',
        onTap: () {},
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: tiles,
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _purple, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: _navy,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
