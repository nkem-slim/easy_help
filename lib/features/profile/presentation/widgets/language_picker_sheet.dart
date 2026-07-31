import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

const List<String> kSupportedLanguages = ['English', 'French', 'Kinyarwanda'];

Future<String?> showLanguagePicker(BuildContext context, String current) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final language in kSupportedLanguages)
                ListTile(
                  title: Text(language),
                  trailing: language == current
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.secondary,
                        )
                      : null,
                  onTap: () => Navigator.pop(sheetContext, language),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}
