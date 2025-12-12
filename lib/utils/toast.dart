import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/index.dart';

void showInfoToast(BuildContext context, String message) {
  final scheme = context.scheme;
  toastification.show(
    context: context,
    title: const Text('Info'),
    description: Text(message),
    autoCloseDuration: Duration(milliseconds: _getToastDuration(message)),
    type: ToastificationType.success,
    icon: Icon(
      Icons.info_outline,
      color: scheme.onPrimaryContainer,
    ),
    foregroundColor: scheme.onPrimaryContainer,
    primaryColor: scheme.onPrimaryContainer,
    backgroundColor: scheme.primaryContainer,
  );
}

void showErrorToast(BuildContext context, String message) {
  final scheme = context.scheme;
  toastification.show(
    context: context,
    title: const Text('Error'),
    description: Text(message),
    autoCloseDuration: Duration(milliseconds: _getToastDuration(message)),
    type: ToastificationType.error,
    icon: Icon(
      Icons.error,
      color: scheme.onError,
    ),
    foregroundColor: scheme.onError,
    primaryColor: scheme.onError,
    backgroundColor: scheme.error,
  );
}

void showWarnToast(BuildContext context, String message) {
  final scheme = context.scheme;
  toastification.show(
    context: context,
    title: const Text('Success'),
    description: Text(message),
    autoCloseDuration: Duration(milliseconds: _getToastDuration(message)),
    type: ToastificationType.warning,
    icon: Icon(
      Icons.warning,
      color: scheme.onWarnContainer,
    ),
    foregroundColor: scheme.onWarnContainer,
    primaryColor: scheme.onWarnContainer,
    backgroundColor: scheme.warnContainer,
  );
}

void showSuccessToast(BuildContext context, String message) {
  final scheme = context.scheme;
  toastification.show(
    context: context,
    title: const Text('Success'),
    description: Text(message),
    autoCloseDuration: Duration(milliseconds: _getToastDuration(message)),
    type: ToastificationType.success,
    icon: Icon(
      Icons.check,
      color: scheme.onSuccessContainer,
    ),
    foregroundColor: scheme.onSuccessContainer,
    primaryColor: scheme.onSuccessContainer,
    backgroundColor: scheme.successContainer,
  );
}

/// Calculates the duration for a toast message in milliseconds based on the
/// length of the text.
///
/// This ensures longer messages are displayed for a longer period, giving the
/// user enough time to read them.
///
/// [errorMessage] The text content of the error message.
///
/// Returns the calculated duration in milliseconds.
int _getToastDuration(String errorMessage) {
  // Base duration for any toast message (e.g., 2.5 seconds).
  const baseDuration = 2500;

  // Additional time to grant per character for reading (e.g., 80 milliseconds).
  const timePerCharacter = 100;

  // A sensible maximum duration to prevent the toast from staying too long
  // (e.g., 8 seconds).
  const maxDuration = 8000;

  // Calculate the duration based on the message length.
  final calculatedDuration = baseDuration + (errorMessage.length * timePerCharacter);

  // Return the calculated duration, but cap it at the maximum allowed duration.
  return min(calculatedDuration, maxDuration);
}
