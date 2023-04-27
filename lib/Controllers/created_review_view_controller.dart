import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/created_review_detail.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final createdReviewViewControllerProvider =
StateNotifierProvider.autoDispose<CreatedReviewViewNotifier, AsyncValue<CreatedReviewDetail>>((ref) {
  return CreatedReviewViewNotifier(ref: ref);
});

class CreatedReviewViewNotifier extends StateNotifier<AsyncValue<CreatedReviewDetail>> {
  Ref ref;

  CreatedReviewViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchCreatedReview(int submissionId) async {
    state = const AsyncLoading();
    try {
      CreatedReviewDetail createdReviewDetail = await ref.read(apiProvider).getCreatedReview(submissionId);
      state = AsyncData(createdReviewDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

  Future<void> submitReview(int submissionId, int assignedScore, String content) async {
    state = const AsyncLoading();
    try {
      CreatedReviewDetail submittedReviewDetail = await ref.read(apiProvider).submitReview(submissionId,assignedScore,content);
      state = AsyncData(submittedReviewDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
