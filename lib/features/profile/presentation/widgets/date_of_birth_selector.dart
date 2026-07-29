import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Day / month / year dropdowns for picking a date of birth.
///
/// The three parts are reported separately because a partly-filled date is not
/// a valid [DateTime] — there is no such day as "the 5th of no month".
///
/// The day list shrinks to match the chosen month and year, so 30 February and
/// 29 February in a non-leap year cannot be selected. If a day is already
/// chosen when the month or year changes to one with fewer days, the day is
/// cleared rather than silently moved to a date the user never picked.
class DateOfBirthSelector extends StatelessWidget {
  /// How many years back the year dropdown offers.
  static const int _yearSpan = 100;

  /// Stand-in year used while the real one is unknown. A leap year, so that
  /// 29 February stays selectable until the user commits to a year.
  static const int _leapYearFallback = 2024;

  static const List<String> _monthNames = [
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

  final int? day;
  final int? month;
  final int? year;
  final ValueChanged<int?> onDayChanged;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  const DateOfBirthSelector({
    super.key,
    required this.day,
    required this.month,
    required this.year,
    required this.onDayChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  /// Number of days in [month] of [year], accounting for leap years.
  ///
  /// Day zero of the following month is the last day of this one, and
  /// [DateTime] normalises both the day and a month value of 13, so this needs
  /// no leap-year arithmetic of its own.
  static int daysInMonth({int? month, int? year}) {
    if (month == null) return 31;
    return DateTime(year ?? _leapYearFallback, month + 1, 0).day;
  }

  /// Clears the chosen day when the incoming month or year cannot hold it.
  void _clearDayIfOutOfRange({int? newMonth, int? newYear}) {
    final currentDay = day;
    if (currentDay == null) return;
    if (currentDay > daysInMonth(month: newMonth, year: newYear)) {
      onDayChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDay = daysInMonth(month: month, year: year);
    // DropdownButtonFormField asserts that its value matches exactly one item,
    // so never hand it a day the current month cannot hold.
    final safeDay = (day != null && day! <= maxDay) ? day : null;

    final currentYear = DateTime.now().year;

    return Row(
      children: [
        Expanded(
          child: _Dropdown<int>(
            hint: 'Day',
            value: safeDay,
            items: [
              for (var d = 1; d <= maxDay; d++)
                DropdownMenuItem(value: d, child: Text('$d')),
            ],
            onChanged: onDayChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Dropdown<int>(
            hint: 'Month',
            value: month,
            items: [
              for (var m = 1; m <= _monthNames.length; m++)
                DropdownMenuItem(value: m, child: Text(_monthNames[m - 1])),
            ],
            // Abbreviated once selected: "September" does not fit in a third of
            // the row, while the open menu has room for the full name.
            selectedItemBuilder: [
              for (final name in _monthNames)
                Text(name.substring(0, 3), style: _valueStyle),
            ],
            onChanged: (value) {
              _clearDayIfOutOfRange(newMonth: value, newYear: year);
              onMonthChanged(value);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Dropdown<int>(
            hint: 'Year',
            value: year,
            items: [
              for (var i = 0; i < _yearSpan; i++)
                DropdownMenuItem(
                  value: currentYear - i,
                  child: Text('${currentYear - i}'),
                ),
            ],
            onChanged: (value) {
              _clearDayIfOutOfRange(newMonth: month, newYear: value);
              onYearChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

const TextStyle _valueStyle = TextStyle(
  fontSize: 15,
  color: AppColors.textPrimary,
);

/// Thin wrapper so the three dropdowns share hint, padding, and text styling.
class _Dropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final List<Widget>? selectedItemBuilder;
  final ValueChanged<T?> onChanged;

  const _Dropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.selectedItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      style: _valueStyle,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      selectedItemBuilder:
          selectedItemBuilder == null ? null : (_) => selectedItemBuilder!,
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
