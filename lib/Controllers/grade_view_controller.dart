import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/grade.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

final gradeViewControllerProvider =
StateNotifierProvider.autoDispose<GradeViewNotifier, AsyncValue<Grade>>((ref) {
  return GradeViewNotifier(ref: ref);
});

class GradeViewNotifier extends StateNotifier<AsyncValue<Grade>> {
  Ref ref;

  GradeViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchGrade(int submissionId) async {
    state = const AsyncLoading();
    try {
      Grade grade = await ref.read(apiProvider).getGrade(submissionId);
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
