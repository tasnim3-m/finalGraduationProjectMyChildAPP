
import '../../model/login.dart';

abstract class LoginRepositoryInterface {
  
  Future<bool> loginUser({
    required Login data,
  });
}
