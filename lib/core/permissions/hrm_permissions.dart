import '../storage/hive_storage.dart';

abstract class Permissions {
  // Leave
  static const leaveApply = 'hrm.leave.apply';
  static const leaveApprove = 'hrm.leave.approve';
  static const leaveManage = 'hrm.leave.manage';
  static const leaveView = 'hrm.leave.view';

  // Travel
  static const travelApply = 'hrm.travel.apply';
  static const travelApprove = 'hrm.travel.approve';
  static const travelManage = 'hrm.travel.manage';

  // Training
  static const trainingEnroll = 'hrm.training.enroll';
  static const trainingManage = 'hrm.training.manage';

  // Overtime
  static const overtimeApply = 'hrm.overtime.apply';
  static const overtimeApprove = 'hrm.overtime.approve';
  static const overtimeManage = 'hrm.overtime.manage';

  // Attendance
  static const attendanceView = 'hrm.attendance.view';

  // Reports
  static const reportsView = 'hrm.reports.view';
}

class HrmPermissions {
  HrmPermissions._();

  static List<String> _permissions = [];

  static void load(List<String> permissions) {
    _permissions = permissions;
    HiveStorage.permissions.put(HiveKeys.permissions, permissions);
  }

  static void loadFromHive() {
    final stored =
        HiveStorage.permissions.get(HiveKeys.permissions) as List?;
    _permissions = stored?.cast<String>() ?? [];
  }

  static bool has(String permission) => _permissions.contains(permission);

  static bool get canApplyLeave => has(Permissions.leaveApply);
  static bool get canApproveLeave => has(Permissions.leaveApprove);
  static bool get canApplyTravel => has(Permissions.travelApply);
  static bool get canApproveTravel => has(Permissions.travelApprove);
  static bool get canEnrollTraining => has(Permissions.trainingEnroll);
  static bool get canApplyOvertime => has(Permissions.overtimeApply);
  static bool get canApproveOvertime => has(Permissions.overtimeApprove);
  static bool get canViewAttendance => true; // all employees can view their own attendance
  static bool get canViewReports => has(Permissions.reportsView);

  static void clear() {
    _permissions = [];
    HiveStorage.permissions.delete(HiveKeys.permissions);
  }

  static List<String> get all => List.unmodifiable(_permissions);
}
