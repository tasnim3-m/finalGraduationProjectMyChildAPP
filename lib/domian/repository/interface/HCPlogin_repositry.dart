
import '../../model/HCPLogin_model.dart';

abstract class HCPLoginRepository {
  Future<AdminInformRespond> login(AdminModel loginData);
}
