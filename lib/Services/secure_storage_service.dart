import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grader_io/Exceptions/token_not_found.dart';

final secureStorageServiceProvider = Provider((ref) {
  return SecureStorageService();
});


class SecureStorageService{

  late FlutterSecureStorage secureStorage;

  SecureStorageService(){
    secureStorage = const FlutterSecureStorage();
  }

  Future<bool> isAccessTokenPresent() async{
    String ? accessToken = await secureStorage.read(key: 'access',aOptions: const AndroidOptions(encryptedSharedPreferences: true));

    if(accessToken == null){
      return false;
    }else{
      return true;
    }
  }

  Future<String> getAccessToken()async{
    String ? accessToken = await secureStorage.read(key: 'access',aOptions: const AndroidOptions(encryptedSharedPreferences: true));
    if(accessToken == null){
      throw TokenNotFoundException(message: 'token not found');
    }else{
      return accessToken;
    }
  }

  Future<void> deleteAccessToken()async{
    await secureStorage.delete(key: 'access',aOptions:const AndroidOptions(encryptedSharedPreferences: true));
  }

  Future<void> saveAccessToken(String token)async{
    await secureStorage.write(key: 'access', value: token,aOptions: const AndroidOptions(encryptedSharedPreferences: true));
  }
}