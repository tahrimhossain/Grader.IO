import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Exceptions/token_expired.dart';
import 'package:grader_io/Services/api.dart';
import '../Exceptions/token_not_found.dart';
import '../Models/joined_classrooms.dart';
import 'auth_state_controller.dart';

final joinedClassroomsViewControllerProvider =
StateNotifierProvider.autoDispose<JoinedClassroomsViewNotifier, AsyncValue<JoinedClassrooms>>((ref) {
  return JoinedClassroomsViewNotifier(ref: ref);
});

class JoinedClassroomsViewNotifier extends StateNotifier<AsyncValue<JoinedClassrooms>> {
  Ref ref;

  JoinedClassroomsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchJoinedClassrooms() async {
    state = const AsyncLoading();
    try {
      JoinedClassrooms joinedClassrooms = await ref.read(apiProvider).getJoinedClassrooms();
      state = AsyncData(joinedClassrooms);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
