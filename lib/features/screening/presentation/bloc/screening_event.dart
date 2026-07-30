part of 'screening_bloc.dart';

abstract class ScreeningEvent extends Equatable {
  const ScreeningEvent();

  @override
  List<Object?> get props => [];
}

class StartScreening extends ScreeningEvent {
  const StartScreening();
}

class AnswerQuestion extends ScreeningEvent {
  final String questionId;
  final AnswerResponse response;

  const AnswerQuestion({required this.questionId, required this.response});

  @override
  List<Object?> get props => [questionId, response];
}

class GoToPreviousQuestion extends ScreeningEvent {
  const GoToPreviousQuestion();
}

class SubmitScreening extends ScreeningEvent {
  final String userId;

  const SubmitScreening({required this.userId});

  @override
  List<Object?> get props => [userId];
}
