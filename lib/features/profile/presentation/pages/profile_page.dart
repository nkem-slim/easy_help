import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/logout_confirm_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_icon_badge.dart';
import '../widgets/profile_section_title.dart';
import '../widgets/profile_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // TODO: read/write these through a settings repository (shared_preferences)
  // once the profile feature has a data layer. Local-only for now.
  bool _notifications = true;
  bool _textMessages = true;
  bool _phoneCalls = true;

  void _comingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showLogoutConfirmDialog(context);
    // The dialog resolves to null when dismissed by tapping outside it, and the
    // widget may be gone by the time the await returns.
    if (confirmed != true || !mounted) return;

    context.read<AuthBloc>().add(const AuthLogoutRequested());
    // Drop every route below login so back cannot return to the signed-in app.
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  Widget _switch(bool value, ValueChanged<bool> onChanged) {
    return Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.secondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(
              name: 'Mommy Uwineza',
              // TODO: pass 'assets/images/<photo>.png' once the avatar is added.
              onCameraTap: () => _comingSoon('Change photo'),
            ),

            const ProfileSectionTitle('Account settings'),
            ProfileTile(
              title: 'Change Password',
              leading: const ProfileIconBadge(
                icon: Icons.lock_rounded,
                color: AppColors.badgeRed,
              ),
              onTap: () => _comingSoon('Change Password'),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Notifications',
              leading: const ProfileIconBadge(
                icon: Icons.notifications_rounded,
                color: AppColors.badgeGreen,
              ),
              trailing: _switch(
                _notifications,
                (v) => setState(() => _notifications = v),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Edit Profile',
              leading: const ProfileIconBadge(
                icon: Icons.edit_rounded,
                color: AppColors.badgeBlue,
              ),
              onTap: () => Navigator.pushNamed(context, AppRoutes.userDetails),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'About us',
              leading: const ProfileIconBadge(
                icon: Icons.people_rounded,
                color: AppColors.badgeOrange,
              ),
              onTap: () => _comingSoon('About us'),
            ),

            const ProfileSectionTitle('More options'),
            ProfileTile(
              title: 'Text messages',
              trailing: _switch(
                _textMessages,
                (v) => setState(() => _textMessages = v),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Phone calls',
              trailing: _switch(
                _phoneCalls,
                (v) => setState(() => _phoneCalls = v),
              ),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Languages',
              trailingText: 'English',
              onTap: () => _comingSoon('Languages'),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Privacy Policy',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.privacyPolicy),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Link social accounts',
              trailingText: 'Facebook, Google',
              onTap: () => _comingSoon('Link social accounts'),
            ),
            const Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20),
            ProfileTile(
              title: 'Log Out',
              onTap: _logout,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
