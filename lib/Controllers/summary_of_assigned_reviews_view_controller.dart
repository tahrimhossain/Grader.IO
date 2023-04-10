


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/summary_of_assigned_submissions_for_review.dart';
import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final summaryOfAssignedReviewsViewControllerProvider =
StateNotifierProvider.autoDispose<SummaryOfAssignedReviewsViewNotifier, AsyncValue<SummaryOfAssignedSubmissionsForReview>>((ref) {
  return SummaryOfAssignedReviewsViewNotifier(ref: ref);
});

class SummaryOfAssignedReviewsViewNotifier extends StateNotifier<AsyncValue<SummaryOfAssignedSubmissionsForReview>> {
  Ref ref;

  SummaryOfAssignedReviewsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchAssignedReviews(int assignmentId) async {
    state = const AsyncLoading();
    try {
      SummaryOfAssignedSubmissionsForReview summaryOfAssignedSubmissionsForReview = await ref.read(apiProvider).getSummaryOfAssignedSubmissionsForReview(assignmentId);
      state = AsyncData(summaryOfAssignedSubmissionsForReview);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

}
