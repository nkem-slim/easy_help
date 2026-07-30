import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/screening_answer.dart';
import '../../domain/entities/screening_question.dart';
import '../../domain/entities/screening_result.dart';
import '../../domain/usecases/submit_screening_usecase.dart';

part 'screening_event.dart';
part 'screening_state.dart';

class ScreeningBloc extends Bloc<ScreeningEvent, ScreeningState> {
  final SubmitScreeningUseCase submitScreeningUseCase;

  ScreeningBloc({required this.submitScreeningUseCase})
    : super(const ScreeningState()) {
    on<StartScreening>(_onStartScreening);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<GoToPreviousQuestion>(_onGoToPreviousQuestion);
    on<SubmitScreening>(_onSubmitScreening);
  }

  void _onStartScreening(StartScreening event, Emitter<ScreeningState> emit) {
    emit(const ScreeningState());
  }

  void _onAnswerQuestion(AnswerQuestion event, Emitter<ScreeningState> emit) {
    final answers = Map<String, AnswerResponse>.from(state.answers)
      ..[event.questionId] = event.response;
    final isLastQuestion =
        state.currentIndex == screeningQuestionBank.length - 1;

    emit(
      state.copyWith(
        answers: answers,
        currentIndex: isLastQuestion
            ? state.currentIndex
            : state.currentIndex + 1,
      ),
    );
  }

  void _onGoToPreviousQuestion(
    GoToPreviousQuestion event,
    Emitter<ScreeningState> emit,
  ) {
    if (state.currentIndex == 0) return;
    emit(state.copyWith(currentIndex: state.currentIndex - 1));
  }

  Future<void> _onSubmitScreening(
    SubmitScreening event,
    Emitter<ScreeningState> emit,
  ) async {
    emit(state.copyWith(status: ScreeningStatus.submitting));

    final answers = [
      for (final entry in state.answers.entries)
        ScreeningAnswer(questionId: entry.key, response: entry.value),
    ];

    final result = await submitScreeningUseCase(
      SubmitScreeningParams(userId: event.userId, answers: answers),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ScreeningStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (screeningResult) => emit(
        state.copyWith(
          status: ScreeningStatus.success,
          result: screeningResult,
        ),
      ),
    );
  }
}
