import 'package:flutter/material.dart';
import 'package:flixora/resources/colors_app.dart';
import 'package:flixora/resources/strings_app.dart';

class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel = AppStrings.tryAgain,
    this.compact = false,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  final String actionLabel;
  final bool compact;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 28, vertical: compact ? 18 : 54),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 32 : 48, color: AppColors.muted),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 16 : 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, height: 1.4),
          ),
          if (action != null) ...[
            const SizedBox(height: 20),
            OutlinedButton(onPressed: action, child: Text(actionLabel)),
          ],
        ],
      ),
    ),
  );
}
