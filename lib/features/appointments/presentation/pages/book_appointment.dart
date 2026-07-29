import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';

class BookAppointmentPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String patientId;
  final String patientName;
  final String contactNumber;
  final String relationship;

  const BookAppointmentPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.patientId,
    required this.patientName,
    required this.contactNumber,
    required this.relationship,
  });

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  int _selectedReminder = 30;

  static const _timeSlots = [
    '10:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];
  static const _reminderOptions = [30, 40, 25, 10, 36];

  bool get _canConfirm => _selectedTimeSlot != null;

  void _confirm() {
    final appointment = AppointmentEntity(
      id: '',
      patientId: widget.patientId,
      doctorId: widget.doctorId,
      doctorName: widget.doctorName,
      doctorSpecialty: widget.doctorSpecialty,
      doctorImageUrl: widget.doctorImageUrl,
      patientName: widget.patientName,
      contactNumber: widget.contactNumber,
      relationship: widget.relationship,
      date: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      reminderMinutesBefore: _selectedReminder,
    );
    context.read<AppointmentBloc>().add(AppointmentBookRequested(appointment));
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: BlocConsumer<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentBooked) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.appointmentConfirmation,
              arguments: state.appointment,
            );
          } else if (state is AppointmentFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AppointmentLoading;

          return SingleChildScrollView(
            child: Column(
              children: [
                _CalendarHeader(
                  focusedMonth: _focusedMonth,
                  selectedDate: _selectedDate,
                  onPrevMonth: () => _changeMonth(-1),
                  onNextMonth: () => _changeMonth(1),
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Available Time',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _timeSlots.map((slot) {
                            return _SelectablePill(
                              label: slot,
                              selected: slot == _selectedTimeSlot,
                              onTap: () =>
                                  setState(() => _selectedTimeSlot = slot),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Reminder Me Before',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _reminderOptions.map((minutes) {
                            return _SelectablePill(
                              label: '$minutes Min',
                              selected: minutes == _selectedReminder,
                              onTap: () =>
                                  setState(() => _selectedReminder = minutes),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: (isLoading || !_canConfirm)
                              ? null
                              : _confirm,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Confirm'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarHeader({
    required this.focusedMonth,
    required this.selectedDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDateSelected,
  });

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdayLabels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(
      focusedMonth.year,
      focusedMonth.month + 1,
      0,
    ).day;
    final firstWeekday = DateTime(
      focusedMonth.year,
      focusedMonth.month,
      1,
    ).weekday;
    final leadingBlanks = firstWeekday - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                ),
                onPressed: onPrevMonth,
              ),
              Text(
                '${_monthNames[focusedMonth.month - 1]} ${focusedMonth.year}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                ),
                onPressed: onNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: _weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: daysInMonth + leadingBlanks,
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = DateTime(
                focusedMonth.year,
                focusedMonth.month,
                index - leadingBlanks + 1,
              );
              final isSelected =
                  day.year == selectedDate.year &&
                  day.month == selectedDate.month &&
                  day.day == selectedDate.day;
              return GestureDetector(
                onTap: () => onDateSelected(day),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
