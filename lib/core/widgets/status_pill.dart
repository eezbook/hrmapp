import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum RequestStatus {
  draft,
  pending,
  approved,
  rejected,
  cancelled,
  completed,
  inProgress,
}

extension RequestStatusX on RequestStatus {
  static RequestStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return RequestStatus.draft;
      case 'approved':
        return RequestStatus.approved;
      case 'rejected':
        return RequestStatus.rejected;
      case 'cancelled':
        return RequestStatus.cancelled;
      case 'completed':
        return RequestStatus.completed;
      case 'in_progress':
      case 'inprogress':
        return RequestStatus.inProgress;
      default:
        return RequestStatus.pending;
    }
  }

  Color get bgColor {
    switch (this) {
      case RequestStatus.draft:
        return AppColors.cancelledBg;
      case RequestStatus.pending:
        return AppColors.pendingBg;
      case RequestStatus.approved:
        return AppColors.approvedBg;
      case RequestStatus.rejected:
        return AppColors.rejectedBg;
      case RequestStatus.cancelled:
        return AppColors.cancelledBg;
      case RequestStatus.completed:
        return AppColors.completedBg;
      case RequestStatus.inProgress:
        return AppColors.inProgressBg;
    }
  }

  Color get textColor {
    switch (this) {
      case RequestStatus.draft:
        return AppColors.grey600;
      case RequestStatus.pending:
        return AppColors.pending;
      case RequestStatus.approved:
        return AppColors.approved;
      case RequestStatus.rejected:
        return AppColors.rejected;
      case RequestStatus.cancelled:
        return AppColors.cancelled;
      case RequestStatus.completed:
        return AppColors.completed;
      case RequestStatus.inProgress:
        return AppColors.inProgress;
    }
  }

  String get label {
    switch (this) {
      case RequestStatus.draft:
        return 'Draft';
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.cancelled:
        return 'Cancelled';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.inProgress:
        return 'In Progress';
    }
  }
}

class StatusPill extends StatelessWidget {
  final String status;

  const StatusPill(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = RequestStatusX.fromString(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: s.bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        s.label,
        style: AppTextStyles.labelSmall.copyWith(color: s.textColor),
      ),
    );
  }
}
