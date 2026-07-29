import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/appointment_bloc.dart';
import '../widgets/appointment_card.dart';

class BookedAppointmentsPage extends StatefulWidget {
  final String patientId;
  const BookedAppointmentsPage({super.key, required this.patientId});

  @override
  State<BookedAppointmentsPage> createState() => _BookedAppointmentsPageState();
}

class _BookedAppointmentsPageState extends State<BookedAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(
      AppointmentLoadRequested(widget.patientId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AppointmentFailure) {
            return Center(child: Text(state.message));
          }
          if (state is AppointmentLoaded) {
            if (state.appointments.isEmpty) {
              return _EmptyState(patientId: widget.patientId);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.appointments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  AppointmentCard(appointment: state.appointments[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String patientId;
  const _EmptyState({required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              "You haven't booked any appointment yet",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get started with your first checkup',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.bookAppointment,
                    arguments: {
                      'doctorId': '',
                      'doctorName': '',
                      'doctorSpecialty': '',
                      'doctorImageUrl': '',
                      'patientId': patientId,
                    },
                  );
                },
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
