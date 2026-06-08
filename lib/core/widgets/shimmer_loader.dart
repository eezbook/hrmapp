import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const _navy   = Color(0xFF1B2064);
const _purple = Color(0xFF7367F0);

// ── Base shimmer box ───────────────────────────────────────────────────────────

class ShimmerLoader extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    this.height = 80,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return _Wrap(
      child: _Box(
        height: height,
        width: width,
        borderRadius: borderRadius,
      ),
    );
  }
}

// ── Generic list loader ────────────────────────────────────────────────────────

class ShimmerListLoader extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ShimmerListLoader({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 90,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => ShimmerLoader(height: itemHeight),
    );
  }
}

// ── Dashboard body skeleton ───────────────────────────────────────────────────

class ShimmerDashboardBody extends StatelessWidget {
  const ShimmerDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return _Wrap(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section label + gear
            Row(
              children: [
                _Box(height: 14, width: 80),
                const Spacer(),
                _Box(height: 20, width: 20, borderRadius: 10),
              ],
            ),
            const SizedBox(height: 14),

            // Summary cards (3 side by side)
            Row(
              children: List.generate(3, (i) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 6,
                    right: i == 2 ? 0 : 6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Box(height: 34, width: 34, borderRadius: 10),
                            const SizedBox(width: 8),
                            _Box(height: 22, width: 28),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _Box(height: 10, width: 60),
                        const SizedBox(height: 4),
                        _Box(height: 10, width: 40),
                      ],
                    ),
                  ),
                ),
              )),
            ),

            const SizedBox(height: 26),

            // Section label
            _Box(height: 14, width: 70),
            const SizedBox(height: 14),

            // Module grid (2 rows × 3)
            ...List.generate(2, (row) => Padding(
              padding: EdgeInsets.only(bottom: row == 0 ? 12 : 0),
              child: Row(
                children: List.generate(3, (col) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: col == 0 ? 0 : 6,
                      right: col == 2 ? 0 : 6,
                    ),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Box(height: 48, width: 48, borderRadius: 14),
                          const SizedBox(height: 10),
                          _Box(height: 10, width: 50),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ── Attendance body skeleton ──────────────────────────────────────────────────

class ShimmerAttendanceBody extends StatelessWidget {
  const ShimmerAttendanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return _Wrap(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly attendance card skeleton
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Box(height: 14, width: 140),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Donut placeholder
                      _Box(height: 150, width: 150, borderRadius: 75),
                      const SizedBox(width: 20),
                      // Legend lines
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(8, (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                _Box(height: 10, width: 10, borderRadius: 5),
                                const SizedBox(width: 8),
                                _Box(height: 10, width: 55 + (i % 3) * 10.0),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _Box(height: 14, width: 90),
            const SizedBox(height: 14),

            // Action tiles (2 rows × 3)
            ...List.generate(2, (row) => Padding(
              padding: EdgeInsets.only(bottom: row == 0 ? 12 : 0),
              child: Row(
                children: List.generate(3, (col) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: col == 0 ? 0 : 6,
                      right: col == 2 ? 0 : 6,
                    ),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Box(height: 48, width: 48, borderRadius: 14),
                          const SizedBox(height: 10),
                          _Box(height: 10, width: 54),
                          const SizedBox(height: 4),
                          _Box(height: 10, width: 36),
                        ],
                      ),
                    ),
                  ),
                )),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ── Leave balance skeleton ────────────────────────────────────────────────────

class ShimmerBalanceList extends StatelessWidget {
  final int itemCount;
  const ShimmerBalanceList({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return _Wrap(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => _BalanceCardSkeleton(),
      ),
    );
  }
}

class _BalanceCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + title + pill
          Row(
            children: [
              _Box(height: 36, width: 36, borderRadius: 10),
              const SizedBox(width: 10),
              _Box(height: 14, width: 110),
              const Spacer(),
              _Box(height: 26, width: 72, borderRadius: 999),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          _Box(height: 8, borderRadius: 6),
          const SizedBox(height: 14),
          // Stats row
          Row(
            children: [
              Expanded(child: Column(children: [
                _Box(height: 16, width: 32),
                const SizedBox(height: 4),
                _Box(height: 10, width: 52),
              ])),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              Expanded(child: Column(children: [
                _Box(height: 16, width: 28),
                const SizedBox(height: 4),
                _Box(height: 10, width: 36),
              ])),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              Expanded(child: Column(children: [
                _Box(height: 16, width: 28),
                const SizedBox(height: 4),
                _Box(height: 10, width: 48),
              ])),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Leave request skeleton ────────────────────────────────────────────────────

class ShimmerRequestList extends StatelessWidget {
  final int itemCount;
  const ShimmerRequestList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return _Wrap(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: itemCount,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => _RequestCardSkeleton(),
      ),
    );
  }
}

class _RequestCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + title + status pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Box(height: 38, width: 38, borderRadius: 10),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Box(height: 13, width: 120),
                    const SizedBox(height: 6),
                    _Box(height: 11, width: 160),
                  ],
                ),
              ),
              _Box(height: 24, width: 64, borderRadius: 999),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 10),
          // Chips row
          Row(
            children: [
              _Box(height: 20, width: 70, borderRadius: 6),
              const SizedBox(width: 8),
              _Box(height: 20, width: 60, borderRadius: 6),
              const SizedBox(width: 8),
              _Box(height: 20, width: 80, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 8),
          _Box(height: 10, width: 130),
        ],
      ),
    );
  }
}

// ── ShimmerCard (legacy) ──────────────────────────────────────────────────────

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Wrap(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Box(height: 40, width: 40, borderRadius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Box(height: 12),
                      const SizedBox(height: 6),
                      _Box(height: 10, width: 120),
                    ],
                  ),
                ),
                _Box(height: 24, width: 60, borderRadius: 12),
              ],
            ),
            const SizedBox(height: 12),
            _Box(height: 10),
          ],
        ),
      ),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _Wrap extends StatelessWidget {
  final Widget child;
  const _Wrap({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

class _Box extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _Box({
    required this.height,
    this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
