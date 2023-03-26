import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/auth_state_controller.dart';
import 'package:grader_io/Exceptions/token_expired.dart';
import 'package:grader_io/Exceptions/token_not_found.dart';
import 'package:grader_io/Models/user_info.dart';
import 'package:grader_io/Services/api.dart';

final userProfileViewControllerProvider =
StateNotifierProvider<UserProfileViewNotifier, AsyncValue<UserInfo>>((ref) {
  return UserProfileViewNotifier(ref: ref);
});

class UserProfileViewNotifier extends StateNotifier<AsyncValue<UserInfo>> {
  Ref ref;

  UserProfileViewNotifier({required this.ref}) : super(const AsyncLoading());

  Future<void> fetchUserInfo() async {
    state = const AsyncLoading();
    try {
      UserInfo userInfo = await ref.read(apiProvider).getUserInfo();
      state = AsyncData(userInfo);
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    } catch (e, stacktrace) {
      state = AsyncError(e, stacktrace);
    }
  }
}
