import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/classroom.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

class CreateClassroomState{}
class ReadyToCreateClassroomState extends CreateClassroomState{}
class SuccessfullyCreatedClassroomState extends CreateClassroomState{
  Classroom classroom;
  SuccessfullyCreatedClassroomState({required this.classroom});
}
class FailedToCreateClassroomState extends CreateClassroomState{
  Exception error;
  FailedToCreateClassroomState({required this.error});
}


final createClassroomViewControllerProvider =
StateNotifierProvider.autoDispose<CreateClassroomViewNotifier, AsyncValue<CreateClassroomState>>((ref) {
  return CreateClassroomViewNotifier(ref: ref);
});

class CreateClassroomViewNotifier extends StateNotifier<AsyncValue<CreateClassroomState>> {
  Ref ref;

  CreateClassroomViewNotifier({required this.ref}) : super(AsyncData(ReadyToCreateClassroomState()));

  Future<void> createClassroom(String name, String description) async {
    state = const AsyncLoading();
    try {
      Classroom createdClassroom = await ref.read(apiProvider).createClassroom(name,description);
      state = AsyncData(SuccessfullyCreatedClassroomState(classroom: createdClassroom));
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }catch (e){
      state = AsyncData(FailedToCreateClassroomState(error: e as Exception));
    }
  }
}
