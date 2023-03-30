import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/assignment_detail.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final assignmentDetailViewControllerProvider =
StateNotifierProvider.autoDispose<AssignmentDetailViewNotifier, AsyncValue<AssignmentDetail>>((ref) {
  return AssignmentDetailViewNotifier(ref: ref);
});

class AssignmentDetailViewNotifier extends StateNotifier<AsyncValue<AssignmentDetail>> {
  Ref ref;

  AssignmentDetailViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchAssignmentDetail(int assignmentId) async {
    state = const AsyncLoading();
    try {
      AssignmentDetail assignmentDetail = await ref.read(apiProvider).getAssignmentDetail(assignmentId);
      state = AsyncData(assignmentDetail);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
