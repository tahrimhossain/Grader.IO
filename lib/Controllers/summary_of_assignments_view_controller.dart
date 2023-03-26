import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/summary_of_assignments.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final summaryOfAssignmentsViewControllerProvider =
StateNotifierProvider.autoDispose<SummaryOfAssignmentsViewNotifier, AsyncValue<SummaryOfAssignments>>((ref) {
  return SummaryOfAssignmentsViewNotifier(ref: ref);
});

class SummaryOfAssignmentsViewNotifier extends StateNotifier<AsyncValue<SummaryOfAssignments>> {
  Ref ref;

  SummaryOfAssignmentsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchAssignments(String classroomCode) async {
    state = const AsyncLoading();
    try {
      SummaryOfAssignments summaryOfAssignments = await ref.read(apiProvider).getSummaryOfAssignments(classroomCode);
      state = AsyncData(summaryOfAssignments);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
