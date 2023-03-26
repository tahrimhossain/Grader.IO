import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/auth_state_controller.dart';
import 'package:grader_io/Services/secure_storage_service.dart';

import '../Services/api.dart';

class RegisterState{}

class ReadyToRegisterState extends RegisterState{}
class FailedToRegisterState extends RegisterState{
  Exception error;
  FailedToRegisterState({required this.error});
}


final registerViewControllerProvider =
StateNotifierProvider.autoDispose<RegisterViewNotifier, AsyncValue<RegisterState>>((ref) {
  return RegisterViewNotifier(ref: ref);
});

class RegisterViewNotifier extends StateNotifier<AsyncValue<RegisterState>> {
  Ref ref;

  RegisterViewNotifier({required this.ref}) : super(AsyncData(ReadyToRegisterState()));

  Future<void> register(String email,String name,String password) async {
    state = const AsyncLoading();
    try {
      String accessToken = await ref.read(apiProvider).register(email,name,password);
      await ref.read(secureStorageServiceProvider).saveAccessToken(accessToken);
      ref.read(authStateController.notifier).changeStatusToLoggedIn();
    }catch (e) {
      state = AsyncData(FailedToRegisterState(error: e as Exception));
    }
  }
}
