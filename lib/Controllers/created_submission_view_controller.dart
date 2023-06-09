import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/created_submission_detail.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final createdSubmissionViewControllerProvider =
StateNotifierProvider.autoDispose<CreatedSubmissionViewNotifier, AsyncValue<CreatedSubmissionDetail>>((ref) {
  return CreatedSubmissionViewNotifier(ref: ref);
});

class CreatedSubmissionViewNotifier extends StateNotifier<AsyncValue<CreatedSubmissionDetail>> {
  Ref ref;

  CreatedSubmissionViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchCreatedSubmission(int assignmentId) async {
    state = const AsyncLoading();
    try {
      CreatedSubmissionDetail createdSubmissionDetail = await ref.read(apiProvider).getCreatedSubmission(assignmentId);
      state = AsyncData(createdSubmissionDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

  Future<void> saveSubmission(int assignmentId, String content) async {
    state = const AsyncLoading();
    try {
      CreatedSubmissionDetail savedSubmissionDetail = await ref.read(apiProvider).saveSubmission(assignmentId,content);
      state = AsyncData(savedSubmissionDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

  Future<void> submitSubmission(int assignmentId, String content) async {
    state = const AsyncLoading();
    try {
      CreatedSubmissionDetail submittedSubmissionDetail = await ref.read(apiProvider).submitSubmission(assignmentId,content);
      state = AsyncData(submittedSubmissionDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
