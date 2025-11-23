import 'package:flutter/material.dart';

class SavingGoal {
  final String id;
  String title;
  double currentAmount;
  double targetAmount;
  Color color;
  IconData icon;

  SavingGoal({
    required this.id,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.color,
    required this.icon,
  });

  double get progress => (currentAmount / targetAmount).clamp(0.0, 1.0);
}
