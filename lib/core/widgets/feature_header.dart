import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

const _navy   = Color(0xFF1B2064);
const _pageBg = Color(0xFFF5F7FF);

/// Convenience background color for feature home pages.
const featurePageBg = _pageBg;

/// Pill-style segmented tab switcher placed in the shell header bottom slot.
class FeatureTabSwitcher extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final void Function(int) onChanged;

  const FeatureTabSwitcher({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (i) => _TabBtn(
            label: labels[i],
            selected: selectedIndex == i,
            onTap: () => onChanged(i),
          ),
        ),
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: selected ? _navy : Colors.white60,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
