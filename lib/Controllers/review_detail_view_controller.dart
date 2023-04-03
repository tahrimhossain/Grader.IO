import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/review_detail.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final reviewDetailViewControllerProvider =
StateNotifierProvider.autoDispose<ReviewDetailViewNotifier, AsyncValue<ReviewDetail>>((ref) {
  return ReviewDetailViewNotifier(ref: ref);
});

class ReviewDetailViewNotifier extends StateNotifier<AsyncValue<ReviewDetail>> {
  Ref ref;

  ReviewDetailViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchReviewDetail(int reviewId) async {
    state = const AsyncLoading();
    try {
      ReviewDetail reviewDetail = await ref.read(apiProvider).getReviewDetail(reviewId);
      state = AsyncData(reviewDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
