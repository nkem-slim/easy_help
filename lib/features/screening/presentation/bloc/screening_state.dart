part of 'screening_bloc.dart';

enum ScreeningStatus { inProgress, submitting, success, failure }

class ScreeningState extends Equatable {
  final ScreeningStatus status;
  final int currentIndex;
  final Map<String, AnswerResponse> answers;
  final ScreeningResult? result;
  final String? errorMessage;

  const ScreeningState({
    this.status = ScreeningStatus.inProgress,
    this.currentIndex = 0,
    this.answers = const {},
    this.result,
    this.errorMessage,
  });

  ScreeningQuestion get currentQuestion => screeningQuestionBank[currentIndex];

  double get progress => (currentIndex + 1) / screeningQuestionBank.length;

  ScreeningState copyWith({
    ScreeningStatus? status,
    int? currentIndex,
    Map<String, AnswerResponse>? answers,
    ScreeningResult? result,
    String? errorMessage,
  }) {
    return ScreeningState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentIndex,
    answers,
    result,
    errorMessage,
  ];
}
