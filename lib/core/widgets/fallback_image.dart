import 'package:flutter/material.dart';

import '../utils/image_provider_utils.dart';

const String kDefaultFallbackImageAsset = 'assets/images/easy_help_logo.png';

/// Renders [imagePath] (a network URL or local asset path, resolved via
/// [resolveImageProvider]) and falls back to the Easy Help logo — the same
/// asset shown on the splash screen — whenever [imagePath] is null/empty or
/// fails to load, so no screen ever shows a broken-image icon.
class FallbackImage extends StatelessWidget {
  final String? imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const FallbackImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path == null || path.isEmpty) {
      return Image.asset(
        kDefaultFallbackImageAsset,
        fit: fit,
        width: width,
        height: height,
      );
    }
    return Image(
      image: resolveImageProvider(path),
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => Image.asset(
        kDefaultFallbackImageAsset,
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
