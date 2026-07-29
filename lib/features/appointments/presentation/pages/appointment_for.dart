import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/doctor_summary_card.dart';

class AppointmentForPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String patientId;

  const AppointmentForPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.patientId,
  });

  @override
  State<AppointmentForPage> createState() => _AppointmentForPageState();
}

class _AppointmentForPageState extends State<AppointmentForPage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameController.text.trim().isNotEmpty &&
      _contactController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DoctorSummaryCard(
                name: widget.doctorName,
                specialty: widget.doctorSpecialty,
                imageUrl: widget.doctorImageUrl,
              ),
              const SizedBox(height: 24),
              const Text(
                'Appointment For',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Patient Name'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Contact Number'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(hintText: 'Relationship'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _canContinue
                    ? () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.bookAppointment,
                          arguments: {
                            'doctorId': widget.doctorId,
                            'doctorName': widget.doctorName,
                            'doctorSpecialty': widget.doctorSpecialty,
                            'doctorImageUrl': widget.doctorImageUrl,
                            'patientId': widget.patientId,
                            'patientName': _nameController.text.trim(),
                            'contactNumber': _contactController.text.trim(),
                            'relationship': _relationshipController.text.trim(),
                          },
                        );
                      }
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
