import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/submission_grade.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final submissionGradeViewControllerProvider =
StateNotifierProvider.autoDispose<SubmissionGradeViewNotifier, AsyncValue<SubmissionGrade>>((ref) {
  return SubmissionGradeViewNotifier(ref: ref);
});

class SubmissionGradeViewNotifier extends StateNotifier<AsyncValue<SubmissionGrade>> {
  Ref ref;

  SubmissionGradeViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchSubmissionGrade(int submissionId) async {
    state = const AsyncLoading();
    try {
      SubmissionGrade grade = await ref.read(apiProvider).getSubmissionGrade(submissionId);
      state = AsyncData(grade);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

}
