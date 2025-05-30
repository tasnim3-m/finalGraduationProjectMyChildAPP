
import '../../../views/sign_up/sign_up.dart';

abstract class SignUpRepositoryInterface {
 

  Future<bool> registerUser({
   required SignUp data
  });
}
