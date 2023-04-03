import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/submission_detail.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final submissionDetailViewControllerProvider =
StateNotifierProvider.autoDispose<SubmissionDetailViewNotifier, AsyncValue<SubmissionDetail>>((ref) {
  return SubmissionDetailViewNotifier(ref: ref);
});

class SubmissionDetailViewNotifier extends StateNotifier<AsyncValue<SubmissionDetail>> {
  Ref ref;

  SubmissionDetailViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchSubmissionDetail(int submissionId) async {
    state = const AsyncLoading();
    try {
      SubmissionDetail submissionDetail = await ref.read(apiProvider).getSubmissionDetail(submissionId);
      state = AsyncData(submissionDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
