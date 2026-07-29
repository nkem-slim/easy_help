import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Confirmation dialog for signing out.
///
/// Pops with `true` when the user confirms and `false` when they cancel, so the
/// decision is made by the caller rather than inside the dialog.
class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const actionStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.secondary,
    );

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      title: const Text(
        'Log Out',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: const Text(
        'Are you sure you want to logout?',
        style: TextStyle(fontSize: 15, color: AppColors.textHeading),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(8, 4, 16, 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel', style: actionStyle),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Ok', style: actionStyle),
        ),
      ],
    );
  }
}

/// Shows [LogoutConfirmDialog] and resolves to the user's choice.
///
/// Resolves to `null` if the dialog is dismissed by tapping outside it, so
/// callers should treat anything other than `true` as "do not log out".
Future<bool?> showLogoutConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => const LogoutConfirmDialog(),
  );
}
