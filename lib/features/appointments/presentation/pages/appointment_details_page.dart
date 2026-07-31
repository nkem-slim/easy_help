import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/fallback_image.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final AppointmentEntity appointment;
  const AppointmentDetailsPage({super.key, required this.appointment});

  @override
  State<AppointmentDetailsPage> createState() =>
      _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  static const _timeSlots = [
    '10:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];
  static const _reminderOptions = [30, 40, 25, 10, 36];

  late AppointmentEntity _appointment;
  bool _editing = false;

  late DateTime _editedDate;
  late String _editedTimeSlot;
  late int _editedReminder;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
    _resetEditFields();
  }

  void _resetEditFields() {
    _editedDate = _appointment.date;
    _editedTimeSlot = _appointment.timeSlot;
    _editedReminder = _appointment.reminderMinutesBefore;
  }

  Color get _statusColor {
    switch (_appointment.status) {
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _editedDate.isBefore(DateTime.now())
          ? DateTime.now()
          : _editedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _editedDate = picked);
  }

  void _saveEdit() {
    final updated = AppointmentEntity(
      id: _appointment.id,
      patientId: _appointment.patientId,
      doctorId: _appointment.doctorId,
      doctorName: _appointment.doctorName,
      doctorSpecialty: _appointment.doctorSpecialty,
      doctorImageUrl: _appointment.doctorImageUrl,
      patientName: _appointment.patientName,
      contactNumber: _appointment.contactNumber,
      relationship: _appointment.relationship,
      date: _editedDate,
      timeSlot: _editedTimeSlot,
      reminderMinutesBefore: _editedReminder,
      status: _appointment.status,
    );
    context.read<AppointmentBloc>().add(AppointmentUpdateRequested(updated));
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete appointment?'),
        content: const Text(
          'This will permanently remove this appointment. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    context.read<AppointmentBloc>().add(
      AppointmentDeleteRequested(
        appointmentId: _appointment.id,
        patientIdAfterDelete: _appointment.patientId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentUpdated &&
            state.appointment.id == _appointment.id) {
          setState(() {
            _appointment = state.appointment;
            _editing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment updated')),
          );
        } else if (state is AppointmentDeleted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment deleted')),
          );
        } else if (state is AppointmentFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(_editing ? 'Edit Appointment' : 'Appointment Details'),
          actions: _editing
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () => setState(() => _editing = true),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: _confirmDelete,
                  ),
                ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _editing ? _buildEditView() : _buildDetailsView(),
        ),
      ),
    );
  }

  Widget _buildDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipOval(
            child: SizedBox(
              width: 88,
              height: 88,
              child: FallbackImage(imagePath: _appointment.doctorImageUrl),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            _appointment.doctorName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Center(
          child: Text(
            _appointment.doctorSpecialty,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _appointment.status,
              style: TextStyle(
                color: _statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _DetailCard(
          children: [
            _DetailRow(
              icon: Icons.calendar_today_rounded,
              label: 'Date',
              value:
                  '${_appointment.date.month}/${_appointment.date.day}/${_appointment.date.year}',
            ),
            _DetailRow(
              icon: Icons.access_time_rounded,
              label: 'Time',
              value: _appointment.timeSlot,
            ),
            _DetailRow(
              icon: Icons.notifications_active_rounded,
              label: 'Reminder',
              value: '${_appointment.reminderMinutesBefore} min before',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DetailCard(
          children: [
            _DetailRow(
              icon: Icons.person_rounded,
              label: 'Patient',
              value: _appointment.patientName,
            ),
            _DetailRow(
              icon: Icons.phone_rounded,
              label: 'Contact',
              value: _appointment.contactNumber,
            ),
            _DetailRow(
              icon: Icons.diversity_1_rounded,
              label: 'Relationship',
              value: _appointment.relationship,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  '${_editedDate.month}/${_editedDate.day}/${_editedDate.year}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Time',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _timeSlots.map((slot) {
            return _SelectablePill(
              label: slot,
              selected: slot == _editedTimeSlot,
              onTap: () => setState(() => _editedTimeSlot = slot),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'Reminder',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _reminderOptions.map((minutes) {
            return _SelectablePill(
              label: '$minutes Min',
              selected: minutes == _editedReminder,
              onTap: () => setState(() => _editedReminder = minutes),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() {
                  _editing = false;
                  _resetEditFields();
                }),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveEdit,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  const _DetailCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Divider(height: 24, color: AppColors.divider),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SelectablePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectablePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
