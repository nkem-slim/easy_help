import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/soft_gradient_background.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/page_back_button.dart';

class AuthPasswordChangeRequested extends AuthEvent {
  const AuthPasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final current = _currentController.text;
    final next = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      _showError('Fill in all three fields.');
      return;
    }
    if (next.length < 6) {
      _showError('New password must be at least 6 characters.');
      return;
    }
    if (next != confirm) {
      _showError('New password and confirmation do not match.');
      return;
    }

    context.read<AuthBloc>().add(
      AuthPasswordChangeRequested(currentPassword: current, newPassword: next),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordChangeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state is AuthFailureState) {
          _showError(state.message);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const SoftGradientBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        PageBackButton(),
                        SizedBox(width: 16),
                        Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: _PasswordCard(
                            currentController: _currentController,
                            newController: _newController,
                            confirmController: _confirmController,
                            obscureCurrent: _obscureCurrent,
                            obscureNew: _obscureNew,
                            obscureConfirm: _obscureConfirm,
                            onToggleCurrent: () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                            onToggleNew: () =>
                                setState(() => _obscureNew = !_obscureNew),
                            onToggleConfirm: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                            onSubmit: _submit,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  final TextEditingController currentController;
  final TextEditingController newController;
  final TextEditingController confirmController;
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;
  final VoidCallback onToggleCurrent;
  final VoidCallback onToggleNew;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;

  const _PasswordCard({
    required this.currentController,
    required this.newController,
    required this.confirmController,
    required this.obscureCurrent,
    required this.obscureNew,
    required this.obscureConfirm,
    required this.onToggleCurrent,
    required this.onToggleNew,
    required this.onToggleConfirm,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.badgeRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _field(
            'Current password',
            currentController,
            obscureCurrent,
            onToggleCurrent,
          ),
          const SizedBox(height: 18),
          _field('New password', newController, obscureNew, onToggleNew),
          const SizedBox(height: 18),
          _field(
            'Confirm new password',
            confirmController,
            obscureConfirm,
            onToggleConfirm,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text(
              'Update password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: AppColors.textSecondary,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
