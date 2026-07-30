import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/screening_answer.dart';
import '../../domain/entities/screening_question.dart';
import '../bloc/screening_bloc.dart';

class TakeTestPage extends StatelessWidget {
  const TakeTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScreeningBloc>()..add(const StartScreening()),
      child: const _TakeTestView(),
    );
  }
}

class _TakeTestView extends StatelessWidget {
  const _TakeTestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Take Test'),
        leading: BlocBuilder<ScreeningBloc, ScreeningState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if (state.currentIndex == 0) {
                  Navigator.of(context).pop();
                } else {
                  context.read<ScreeningBloc>().add(
                    const GoToPreviousQuestion(),
                  );
                }
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {}, // TODO: link to screening FAQ/help content
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ScreeningBloc, ScreeningState>(
          listener: (context, state) {
            if (state.status == ScreeningStatus.success && state.result != null) {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.screeningResult,
                arguments: state.result,
              );
            }
            if (state.status == ScreeningStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Could not submit the screening.',
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state.status == ScreeningStatus.submitting;
            final question = state.currentQuestion;
            final questionNumber = state.currentIndex + 1;
            final totalQuestions = screeningQuestionBank.length;
            final percentComplete = (state.progress * 100).round();

            void answer(AnswerResponse response) {
              if (isSubmitting) return;
              context.read<ScreeningBloc>().add(
                AnswerQuestion(questionId: question.id, response: response),
              );
              if (questionNumber == totalQuestions) {
                // TODO(multi-child): ties the screening to the authenticated
                // parent's account; revisit if multi-child support is added.
                final authState = context.read<AuthBloc>().state;
                final userId = authState is AuthAuthenticated
                    ? authState.user.id
                    : '';
                context.read<ScreeningBloc>().add(
                  SubmitScreening(userId: userId),
                );
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QUESTION $questionNumber OF $totalQuestions   '
                    '$percentComplete% COMPLETE',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: state.progress,
                      minHeight: 6,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/boy-1.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    question.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Think about everyday situations, like when they are '
                    'playing or eating.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  if (question.order == screeningQuestionBank.length) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Note: this question asks about the behavior itself — '
                      'answer "Yes" if you observe it, "No" if you don\'t.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () => answer(AnswerResponse.yes),
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: const Text('Yes, they do'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () => answer(AnswerResponse.no),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('No, not really'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: isSubmitting
                          ? null
                          : () => answer(AnswerResponse.notSure),
                      child: const Text(
                        "I'm not sure / Sometimes",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  if (isSubmitting) ...[
                    const SizedBox(height: 12),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
