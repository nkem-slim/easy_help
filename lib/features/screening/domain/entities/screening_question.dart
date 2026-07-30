import 'package:equatable/equatable.dart';

class ScreeningQuestion extends Equatable {
  final String id;
  final String text;
  final int order;

  const ScreeningQuestion({
    required this.id,
    required this.text,
    required this.order,
  });

  @override
  List<Object?> get props => [id, text, order];
}

/// Fixed local question bank for the take-test flow — not sourced from
/// Firestore, so the order here is the order the caregiver sees.
const List<ScreeningQuestion> screeningQuestionBank = [
  ScreeningQuestion(
    id: 'q1',
    order: 1,
    text: "When your child wants something they can't reach, do they point "
        'at it or bring it to you?',
  ),
  ScreeningQuestion(
    id: 'q2',
    order: 2,
    text: 'Does your child pretend, like feeding a doll or talking on a toy '
        'phone?',
  ),
  ScreeningQuestion(
    id: 'q3',
    order: 3,
    text: 'Does your child seem interested in playing with other children?',
  ),
  ScreeningQuestion(
    id: 'q4',
    order: 4,
    text: 'Does your child repeat the same movement often, like '
        'hand-flapping or rocking, especially when excited or upset?',
  ),
];
