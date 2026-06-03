import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final int id;
  final String leaveTypeName;
  final String leaveTypeCode;
  final double allocated;
  final double used;
  final double pending;
  final double remaining;
  final String? color;

  const LeaveBalance({
    required this.id,
    required this.leaveTypeName,
    required this.leaveTypeCode,
    required this.allocated,
    required this.used,
    required this.pending,
    required this.remaining,
    this.color,
  });

  @override
  List<Object?> get props => [id];
}
