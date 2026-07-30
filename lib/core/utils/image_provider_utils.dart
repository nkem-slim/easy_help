import 'package:flutter/material.dart';

/// Resolves [path] to the right [ImageProvider] whether it's a network URL
/// (doctor photos) or a local asset path (clinic photos) — several screens
/// in the appointment flow display either, depending on what's being booked.
ImageProvider resolveImageProvider(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return NetworkImage(path);
  }
  return AssetImage(path);
}
