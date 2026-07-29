import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/policy_bullet.dart';
import '../widgets/soft_gradient_background.dart';

/// TODO: have this copy reviewed before release — it is a plain-language draft,
/// not legally vetted text.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String _intro =
      'Easy Help is a post-diagnosis autism support platform for caregivers in '
      'Rwanda. We collect only what we need to support you and the child in '
      'your care: your name and contact details, the screening answers and '
      'journal entries you choose to record, and the appointments you book '
      'through the app. We do not sell your information, and we do not share '
      'it with advertisers.';

  static const List<String> _points = [
    'Your journal entries and screening results stay private to your account. '
        'Care professionals can see them only when you explicitly choose to '
        'share them.',
    'We use Firebase for sign-in, storage, and notifications. Your data is '
        'encrypted in transit, and access is limited to the account it '
        'belongs to.',
    'You can turn notifications, text messages, and phone calls on or off at '
        'any time from the Profile screen.',
    'You may request a copy of your data, or ask us to delete your account and '
        'everything in it, by contacting our support team.',
  ];

  static const String _closing =
      'Because Easy Help handles information about children, we take extra care '
      'with what we store and how long we keep it. If we change the way your '
      'data is used, we will tell you inside the app before the change takes '
      'effect. Questions about this policy can be sent to the address listed '
      'under About us.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SoftGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _BackButton(onTap: () => Navigator.pop(context)),
                      const SizedBox(width: 16),
                      const Text(
                        'Privacy policy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Easy Help Apps Privacy Policy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(_intro, style: PolicyBullet.bodyStyle),
                  const SizedBox(height: 24),
                  for (final point in _points) PolicyBullet(point),
                  const SizedBox(height: 6),
                  const Text(_closing, style: PolicyBullet.bodyStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// White rounded square holding a back chevron.
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
