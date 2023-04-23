import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

class JoinClassroomState{}
class ReadyToJoinClassroomState extends JoinClassroomState{}
class SuccessfullyJoinedClassroomState extends JoinClassroomState{}
class FailedToJoinClassroomState extends JoinClassroomState{
  Exception error;
  FailedToJoinClassroomState({required this.error});
}


final joinClassroomViewControllerProvider =
StateNotifierProvider.autoDispose<JoinClassroomViewNotifier, AsyncValue<JoinClassroomState>>((ref) {
  return JoinClassroomViewNotifier(ref: ref);
});

class JoinClassroomViewNotifier extends StateNotifier<AsyncValue<JoinClassroomState>> {
  Ref ref;

  JoinClassroomViewNotifier({required this.ref}) : super(AsyncData(ReadyToJoinClassroomState()));

  Future<void> joinClassroom(String code) async {
    state = const AsyncLoading();
    try {
      await ref.read(apiProvider).joinClassroom(code);
      state = AsyncData(SuccessfullyJoinedClassroomState());
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }catch (e){
      state = AsyncData(FailedToJoinClassroomState(error: e as Exception));
    }
  }
}
