import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Services/api.dart';
import 'package:grader_io/Services/secure_storage_service.dart';

class AuthStateNotifier extends ChangeNotifier {
  Ref ref;
  bool isLoggedIn;
  bool isInitialized;

  AuthStateNotifier(
      {required this.ref,
        required this.isLoggedIn,
        required this.isInitialized});


  Future<void> initialize() async {
      bool tokenPresent = await ref.read(secureStorageServiceProvider).isAccessTokenPresent();
      if(tokenPresent == true){
        changeStatusToLoggedIn();
      }else{
        changeStatusToLoggedOut();
      }
  }

  void changeStatusToLoggedIn() {
    isLoggedIn = true;
    isInitialized = true;
    notifyListeners();
  }

  void changeStatusToLoggedOut(){
    isLoggedIn = false;
    isInitialized = true;
    notifyListeners();
  }
}

final authStateController = ChangeNotifierProvider<AuthStateNotifier>((ref) {
  return AuthStateNotifier(ref: ref, isLoggedIn: false, isInitialized: false);
});