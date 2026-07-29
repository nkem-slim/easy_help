import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// A bulleted paragraph: small green dot, then wrapping body text.
class PolicyBullet extends StatelessWidget {
  /// Shared style for all long-form copy on the privacy policy page, so the
  /// bullets and the surrounding paragraphs stay identical.
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 15,
    height: 1.6,
    color: AppColors.textMuted,
  );

  final String text;

  const PolicyBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: Text(text, style: bodyStyle)),
        ],
      ),
    );
  }
}
