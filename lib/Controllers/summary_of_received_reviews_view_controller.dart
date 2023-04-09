import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/summary_of_submission_reviews.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final summaryOfReceivedReviewsViewControllerProvider =
StateNotifierProvider.autoDispose<SummaryOfReceivedReviewsViewNotifier, AsyncValue<SummaryOfSubmissionReviews>>((ref) {
  return SummaryOfReceivedReviewsViewNotifier(ref: ref);
});

class SummaryOfReceivedReviewsViewNotifier extends StateNotifier<AsyncValue<SummaryOfSubmissionReviews>> {
  Ref ref;

  SummaryOfReceivedReviewsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchReceivedReviews(int assignmentId) async {
    state = const AsyncLoading();
    try {
      SummaryOfSubmissionReviews summaryOfSubmissionReviews = await ref.read(apiProvider).getSummaryOfReviewsGottenForCreatedSubmission(assignmentId);
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
