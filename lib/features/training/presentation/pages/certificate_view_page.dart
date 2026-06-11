import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/course_model.dart';

class CertificateViewPage extends StatelessWidget {
  final CertificateModel cert;
  const CertificateViewPage({super.key, required this.cert});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final expiry =
        cert.expiryDate != null ? DateTime.tryParse(cert.expiryDate!) : null;
    final isExpired = expiry != null && expiry.isBefore(now);
    final expiresSoon = expiry != null &&
        expiry.difference(now).inDays <= 30 &&
        expiry.isAfter(now);

    Color statusColor;
    Color statusBg;
    String statusLabel;

    if (isExpired) {
      statusColor = AppColors.rejected;
      statusBg = AppColors.rejectedBg;
      statusLabel = 'Expired';
    } else if (expiresSoon) {
      statusColor = AppColors.pending;
      statusBg = AppColors.pendingBg;
      statusLabel = 'Expiring Soon';
    } else {
      statusColor = AppColors.approved;
      statusBg = AppColors.approvedBg;
      statusLabel = 'Valid';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        backgroundColor: const Color(0xFF1B2064),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F7FF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // ── Certificate card ─────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Gold header band
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF5A623), Color(0xFFFFD166)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 64,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Certificate of Completion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Text(
                          cert.courseName,
                          style: AppTextStyles.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _InfoRow(
                          icon: Icons.calendar_today_rounded,
                          label: 'Issued',
                          value: cert.issuedDate,
                        ),

                        if (cert.expiryDate != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          _InfoRow(
                            icon: Icons.event_busy_rounded,
                            label: 'Expires',
                            value: cert.expiryDate!,
                            valueColor: isExpired
                                ? AppColors.rejected
                                : expiresSoon
                                    ? AppColors.pending
                                    : null,
                          ),
                        ],

                        const SizedBox(height: AppSpacing.md),

                        // Status pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusLabel,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Download button ──────────────────────────────
            if (cert.downloadUrl != null && !isExpired) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: open download URL
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text(
                    'Download Certificate',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
