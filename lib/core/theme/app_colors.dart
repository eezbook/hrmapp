import 'package:flutter/material.dart';

abstract class AppColors {
  // Status
  static const pending = Color(0xFFF59E0B);
  static const pendingBg = Color(0xFFFEF3C7);
  static const approved = Color(0xFF10B981);
  static const approvedBg = Color(0xFFD1FAE5);
  static const rejected = Color(0xFFEF4444);
  static const rejectedBg = Color(0xFFFEE2E2);
  static const cancelled = Color(0xFF9CA3AF);
  static const cancelledBg = Color(0xFFF3F4F6);
  static const completed = Color(0xFF3B82F6);
  static const completedBg = Color(0xFFDBEAFE);
  static const inProgress = Color(0xFF8B5CF6);
  static const inProgressBg = Color(0xFFEDE9FE);

  // Semantic
  static const error = Color(0xFFDC2626);
  static const success = Color(0xFF059669);
  static const warning = Color(0xFFD97706);
  static const info = Color(0xFF2563EB);

  // Neutral
  static const grey50 = Color(0xFFF9FAFB);
  static const grey100 = Color(0xFFF3F4F6);
  static const grey200 = Color(0xFFE5E7EB);
  static const grey400 = Color(0xFF9CA3AF);
  static const grey600 = Color(0xFF4B5563);
  static const grey800 = Color(0xFF1F2937);

  // Offline
  static const offlineBg = Color(0xFFDC2626);
}
