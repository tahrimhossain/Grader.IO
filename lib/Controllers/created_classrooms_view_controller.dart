import 'package:grader_io/Exceptions/token_expired.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/created_classrooms.dart';
import 'package:grader_io/Services/api.dart';
import '../Exceptions/token_not_found.dart';
import 'auth_state_controller.dart';

final createdClassroomsViewControllerProvider =
StateNotifierProvider<CreatedClassroomsViewNotifier, AsyncValue<CreatedClassrooms>>((ref) {
  return CreatedClassroomsViewNotifier(ref: ref);
});

class CreatedClassroomsViewNotifier extends StateNotifier<AsyncValue<CreatedClassrooms>> {
  Ref ref;

  CreatedClassroomsViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchCreatedClassrooms() async {
    state = const AsyncLoading();
    try {
      CreatedClassrooms createdClassrooms = await ref.read(apiProvider).getCreatedClassrooms();
      state = AsyncData(createdClassrooms);
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
