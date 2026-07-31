import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/language_picker_sheet.dart';
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
  bool _notifications = true;
  bool _textMessages = true;
  bool _phoneCalls = true;

  void _comingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showLogoutConfirmDialog(context);
    if (confirmed != true || !mounted) return;

    context.read<AuthBloc>().add(const AuthLogoutRequested());
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  Future<void> _pickLanguage() async {
    final authState = context.read<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    if (user == null) return;

    final selected = await showLanguagePicker(
      context,
      user.preferredLanguage ?? 'English',
    );
    if (selected == null || selected == user.preferredLanguage || !mounted)
      return;

    context.read<AuthBloc>().add(
      AuthProfileUpdateRequested(
        name: user.name,
        mobile: user.mobile,
        gender: user.gender,
        dateOfBirth: user.dateOfBirth,
        preferredLanguage: selected,
      ),
    );
  }

  void _linkGoogle() {
    context.read<AuthBloc>().add(const AuthLinkGoogleRequested());
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
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthGoogleLinkSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google account linked'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(
                name: user?.name ?? 'Guest',
                onCameraTap: () => _comingSoon('Change photo'),
              ),

              const ProfileSectionTitle('Account settings'),
              ProfileTile(
                title: 'Change Password',
                leading: const ProfileIconBadge(
                  icon: Icons.lock_rounded,
                  color: AppColors.badgeRed,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.changePassword),
              ),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
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
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(
                title: 'Edit Profile',
                leading: const ProfileIconBadge(
                  icon: Icons.edit_rounded,
                  color: AppColors.badgeBlue,
                ),
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.userDetails),
              ),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(
                title: 'About us',
                leading: const ProfileIconBadge(
                  icon: Icons.people_rounded,
                  color: AppColors.badgeOrange,
                ),
                onTap: () => Navigator.pushNamed(context, AppRoutes.aboutUs),
              ),

              const ProfileSectionTitle('More options'),
              ProfileTile(
                title: 'Text messages',
                trailing: _switch(
                  _textMessages,
                  (v) => setState(() => _textMessages = v),
                ),
              ),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(
                title: 'Phone calls',
                trailing: _switch(
                  _phoneCalls,
                  (v) => setState(() => _phoneCalls = v),
                ),
              ),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(
                title: 'Languages',
                trailingText: user?.preferredLanguage ?? 'English',
                onTap: _pickLanguage,
              ),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(
                title: 'Privacy Policy',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.privacyPolicy),
              ),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(title: 'Link Google Account', onTap: _linkGoogle),
              const Divider(
                height: 1,
                color: AppColors.divider,
                indent: 20,
                endIndent: 20,
              ),
              ProfileTile(title: 'Log Out', onTap: _logout),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
