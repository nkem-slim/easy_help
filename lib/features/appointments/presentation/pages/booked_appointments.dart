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

  void _startBooking(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.doctorDetails,
      arguments: {
        'doctorId': '2206489',
        'doctorName': 'Dr. Nshuti',
        'doctorSpecialty': 'Pediatrician',
        'doctorImageUrl': 'https://i.pravatar.cc/150?img=12',
        'patientId': widget.patientId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Booked Appointments')),
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
              return _EmptyState(onBookNow: () => _startBooking(context));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: state.appointments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  AppointmentCard(appointment: state.appointments[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startBooking(context),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBookNow;
  const _EmptyState({required this.onBookNow});

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
            ElevatedButton(onPressed: onBookNow, child: const Text('Book Now')),
          ],
        ),
      ),
    );
  }
}
