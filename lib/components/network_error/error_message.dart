import 'package:flutter/material.dart';
import 'package:flixora/components/network_error/state_message.dart';
import 'package:flixora/data/services/api_error_mapper.dart';
import 'package:flixora/resources/strings_app.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
    required this.error,
    required this.retry,
    this.compact = false,
  });
  final AppException error;
  final VoidCallback retry;
  final bool compact;
  @override
  Widget build(BuildContext context) => StateMessage(
    icon: error.type == AppErrorType.noConnection
        ? Icons.wifi_off_rounded
        : Icons.error_outline_rounded,
    title: error.type == AppErrorType.noConnection
        ? AppStrings.offlineTitle
        : AppStrings.unableToLoad,
    message: error.type == AppErrorType.noConnection
        ? AppStrings.offlineBody
        : error.message,
    action: retry,
    compact: compact,
  );
}
