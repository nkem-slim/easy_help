import 'package:equatable/equatable.dart';

enum AnswerResponse { yes, no, notSure }

class ScreeningAnswer extends Equatable {
  final String questionId;
  final AnswerResponse response;

  const ScreeningAnswer({required this.questionId, required this.response});

  @override
  List<Object?> get props => [questionId, response];
}
