import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/grade.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final assignmentGradeViewControllerProvider =
StateNotifierProvider.autoDispose<AssignmentGradeViewNotifier, AsyncValue<Grade>>((ref) {
  return AssignmentGradeViewNotifier(ref: ref);
});

class AssignmentGradeViewNotifier extends StateNotifier<AsyncValue<Grade>> {
  Ref ref;

  AssignmentGradeViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchAssignmentGrade(int assignmentId)async{
    state = const AsyncLoading();
    try {
      Grade grade = await ref.read(apiProvider).getAssignmentGrade(assignmentId);
      state = AsyncData(grade);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
