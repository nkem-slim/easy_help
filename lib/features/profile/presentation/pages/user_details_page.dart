import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/soft_gradient_background.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/date_of_birth_selector.dart';
import '../widgets/gender_selector.dart';
import '../widgets/labeled_field.dart';
import '../widgets/page_back_button.dart';

/// Form for editing the signed-in caregiver's own details.
///
/// Reached from the "Edit Profile" row on the profile screen.
class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  Gender _gender = Gender.male;
  int? _day;
  int? _month;
  int? _year;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.name;
      _emailController.text = authState.user.email;
    }
  }

  @override
  void dispose() {
    // Controllers hold native resources and listeners; not disposing them leaks
    // for as long as the app runs.
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onUpdate() {
    // TODO: persist through a profile repository once one exists. Validation
    // arrives with the Form wiring.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      PageBackButton(),
                      SizedBox(width: 16),
                      Text(
                        'User Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _FormCard(
                    children: [
                      LabeledField(
                        label: "User's Name",
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Mommy Uwineza',
                          ),
                        ),
                      ),
                      LabeledField(
                        label: 'Age',
                        child: DateOfBirthSelector(
                          day: _day,
                          month: _month,
                          year: _year,
                          onDayChanged: (value) => setState(() => _day = value),
                          onMonthChanged: (value) =>
                              setState(() => _month = value),
                          onYearChanged: (value) =>
                              setState(() => _year = value),
                        ),
                      ),
                      LabeledField(
                        label: 'Gender',
                        child: GenderSelector(
                          value: _gender,
                          onChanged: (value) =>
                              setState(() => _gender = value),
                        ),
                      ),
                      LabeledField(
                        label: 'Mobile Number',
                        child: TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '250795019913',
                          ),
                        ),
                      ),
                      LabeledField(
                        label: 'Email',
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'uwineza01@gmail.com',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _onUpdate,
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// White rounded card holding the form fields, evenly spaced.
class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            children[i],
          ],
        ],
      ),
    );
  }
}
