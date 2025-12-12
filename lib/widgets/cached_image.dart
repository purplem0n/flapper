import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/index.dart';
import 'index.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.url,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.progressIndicatorSize = 16,
    this.errorWidget,
    this.headers,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double progressIndicatorSize;
  final Widget? errorWidget;
  final Map<String, String>? headers;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: headers,
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
        );
      },
      progressIndicatorBuilder: (context, url, progress) {
        return CircularLoading(
          size: progressIndicatorSize,
          strokeWidth: 2,
        );
      },
      errorWidget: (context, url, error) {
        return errorWidget ??
            Icon(
              Icons.error,
              color: context.scheme.error,
              size: progressIndicatorSize,
            );
      },
    );
  }
}
