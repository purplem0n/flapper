import 'package:flutter/material.dart';

import '../index.dart';

class LabelLargeText extends StatelessWidget {
  final String data;

  /// Override the style
  final TextStyle? style;

  /// Override the color.
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  final TextScaler? textScaler;

  const LabelLargeText(
    this.data, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
  });

  @override
  Widget build(BuildContext context) {
    final baseThemeStyle = Theme.of(context).textTheme.labelLarge;
    var effectiveStyle = baseThemeStyle ?? const TextStyle();

    effectiveStyle = effectiveStyle.merge(style);
    effectiveStyle = effectiveStyle.copyWith(color: color ?? context.onSurface);

    return Text(
      data,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textScaler: textScaler,
    );
  }
}
