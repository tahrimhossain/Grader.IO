import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/summary_of_submission_reviews.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final summaryOfSubmissionReviewsViewControllerProvider =
StateNotifierProvider.autoDispose<SummaryOfSubmissionReviewsViewNotifier, AsyncValue<SummaryOfSubmissionReviews>>((ref) {
  return SummaryOfSubmissionReviewsViewNotifier(ref: ref);
});

class SummaryOfSubmissionReviewsViewNotifier extends StateNotifier<AsyncValue<SummaryOfSubmissionReviews>> {
  Ref ref;

  SummaryOfSubmissionReviewsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchSummaryOfSubmissionReviews(int submissionId) async {
    state = const AsyncLoading();
    try {
      SummaryOfSubmissionReviews summaryOfSubmissionReviews = await ref.read(apiProvider).getSummaryOfSubmissionReviews(submissionId);
      state = AsyncData(summaryOfSubmissionReviews);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

}
