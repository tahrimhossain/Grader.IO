import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/summary_of_submissions.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final summaryOfSubmissionsViewControllerProvider =
StateNotifierProvider.autoDispose<SummaryOfSubmissionsViewNotifier, AsyncValue<SummaryOfSubmissions>>((ref) {
  return SummaryOfSubmissionsViewNotifier(ref: ref);
});

class SummaryOfSubmissionsViewNotifier extends StateNotifier<AsyncValue<SummaryOfSubmissions>> {
  Ref ref;

  SummaryOfSubmissionsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchSummaryOfSubmissions(int assignmentId) async {
    state = const AsyncLoading();
    try {
      SummaryOfSubmissions summaryOfSubmissions = await ref.read(apiProvider).getSummaryOfSubmissions(assignmentId);
      state = AsyncData(summaryOfSubmissions);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }

  void setStateToLoading(){
    state = const AsyncLoading();
  }
}
