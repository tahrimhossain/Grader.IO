import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/auth_state_controller.dart';
import 'package:grader_io/Services/secure_storage_service.dart';
import 'package:grader_io/Views/log_in_view.dart';
import '../Services/api.dart';

class LogInState{}
class ReadyToLogInState extends LogInState{}
class FailedToLogInState extends LogInState{
  Exception error;
  FailedToLogInState({required this.error});
}


final logInViewControllerProvider =
StateNotifierProvider.autoDispose<LogInViewNotifier, AsyncValue<LogInState>>((ref) {
  return LogInViewNotifier(ref: ref);
});

class LogInViewNotifier extends StateNotifier<AsyncValue<LogInState>> {
  Ref ref;

  LogInViewNotifier({required this.ref}) : super(AsyncData(ReadyToLogInState()));

  Future<void> logIn(String email, String password) async {
    state = const AsyncLoading();
    try {
     String accessToken = await ref.read(apiProvider).logIn(email, password);
     await ref.read(secureStorageServiceProvider).saveAccessToken(accessToken);
     ref.read(authStateController.notifier).changeStatusToLoggedIn();
    }catch(e){
      state = AsyncData(FailedToLogInState(error: e as Exception));
    }
  }
}
