import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Day / month / year dropdowns for picking a date of birth.
///
/// The three parts are reported separately because a partly-filled date is not
/// a valid [DateTime] — there is no such day as "the 5th of no month".
///
/// Impossible dates are never offered rather than rejected afterwards. The
/// lists shrink to exclude:
///  * days past the end of a short month (31 April),
///  * 29 February outside a leap year,
///  * any date later than today, since nobody is born in the future.
///
/// When a change makes an already-chosen value impossible it is cleared rather
/// than silently moved, so the user never ends up with a date they did not pick.
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

  /// Overrides "now" when deciding which dates are in the future. Defaults to
  /// [DateTime.now]; injectable so the future-date rules can be tested without
  /// depending on the clock.
  final DateTime? today;

  const DateOfBirthSelector({
    super.key,
    required this.day,
    required this.month,
    required this.year,
    required this.onDayChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
    this.today,
  });

  DateTime get _now => today ?? DateTime.now();

  /// Number of days in [month] of [year], accounting for leap years.
  ///
  /// Day zero of the following month is the last day of this one, and
  /// [DateTime] normalises both the day and a month value of 13, so this needs
  /// no leap-year arithmetic of its own.
  static int daysInMonth({int? month, int? year}) {
    if (month == null) return 31;
    return DateTime(year ?? _leapYearFallback, month + 1, 0).day;
  }

  /// Latest month selectable in [year]: capped at the current month once the
  /// current year is chosen.
  int _maxSelectableMonth(int? year) =>
      year == _now.year ? _now.month : _monthNames.length;

  /// Latest day selectable in [month] of [year] — the shorter of the month's
  /// own length and today, when both parts point at the current month.
  int _maxSelectableDay({int? month, int? year}) {
    final monthLength = daysInMonth(month: month, year: year);
    if (year == _now.year && month == _now.month) {
      return monthLength < _now.day ? monthLength : _now.day;
    }
    return monthLength;
  }

  void _handleMonthChanged(int? newMonth) {
    final currentDay = day;
    if (currentDay != null &&
        currentDay > _maxSelectableDay(month: newMonth, year: year)) {
      onDayChanged(null);
    }
    onMonthChanged(newMonth);
  }

  void _handleYearChanged(int? newYear) {
    final currentMonth = month;
    // Switching to the current year can put an already-chosen month in the
    // future, which in turn changes which days are allowed.
    final monthNowInvalid =
        currentMonth != null && currentMonth > _maxSelectableMonth(newYear);
    if (monthNowInvalid) onMonthChanged(null);

    final effectiveMonth = monthNowInvalid ? null : currentMonth;
    final currentDay = day;
    if (currentDay != null &&
        currentDay > _maxSelectableDay(month: effectiveMonth, year: newYear)) {
      onDayChanged(null);
    }
    onYearChanged(newYear);
  }

  @override
  Widget build(BuildContext context) {
    final maxDay = _maxSelectableDay(month: month, year: year);
    final maxMonth = _maxSelectableMonth(year);

    // DropdownButtonFormField asserts that its value matches exactly one item,
    // so never hand it a value the current lists no longer contain.
    final safeDay = (day != null && day! <= maxDay) ? day : null;
    final safeMonth = (month != null && month! <= maxMonth) ? month : null;

    final latestYear = _now.year;

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
            value: safeMonth,
            items: [
              for (var m = 1; m <= maxMonth; m++)
                DropdownMenuItem(value: m, child: Text(_monthNames[m - 1])),
            ],
            // Abbreviated once selected: "September" does not fit in a third of
            // the row, while the open menu has room for the full name. Must be
            // the same length as items, so it is capped the same way.
            selectedItemBuilder: [
              for (var m = 1; m <= maxMonth; m++)
                Text(_monthNames[m - 1].substring(0, 3), style: _valueStyle),
            ],
            onChanged: _handleMonthChanged,
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
                  value: latestYear - i,
                  child: Text('${latestYear - i}'),
                ),
            ],
            onChanged: _handleYearChanged,
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
