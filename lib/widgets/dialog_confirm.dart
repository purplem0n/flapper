import 'package:flutter/material.dart';

import '../theme/index.dart';
import 'index.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String description,
  ColorType? type,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final confirmed = await showDialog<bool?>(
    context: context,
    builder: (context) {
      return ConfirmDialog(
        title: title,
        description: description,
        type: type,
        scheme: scheme,
      );
    },
  );
  return confirmed ?? false;
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    required this.description,
    required this.scheme,
    this.type,
    super.key,
  });

  final String title;
  final String description;
  final ColorType? type;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: scheme.getContainerColor(type),
      surfaceTintColor: scheme.getContainerColor(type),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitleLargeText(title, color: scheme.getOnContainerColor(type)),
            const SizedBox(height: 24),
            BodyMediumText(description, color: scheme.getOnContainerColor(type)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextButton(
                  label: "No",
                  noTheme: true,
                  scheme: scheme,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                const SizedBox(width: 8),
                CustomTextButton(
                  label: "Yes",
                  type: type,
                  scheme: scheme,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
