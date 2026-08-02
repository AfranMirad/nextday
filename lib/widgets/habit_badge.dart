import 'package:flutter/material.dart';

import '../models/habit_type.dart';

class HabitBadge extends StatelessWidget {
  const HabitBadge({
    super.key,
    required this.type,
    this.size = 48,
    this.iconSize,
  });

  final HabitType type;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final r = size * 0.28;
    return Container(
      width: size * 0.72,
      height: size,
      decoration: BoxDecoration(
        color: type.badgeColor,
        borderRadius: BorderRadius.circular(r),
        boxShadow: [
          BoxShadow(
            color: type.badgeColor.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        type.icon,
        color: Colors.white,
        size: iconSize ?? size * 0.42,
      ),
    );
  }
}