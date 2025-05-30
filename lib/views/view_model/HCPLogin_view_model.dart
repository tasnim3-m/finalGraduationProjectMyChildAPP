

import '../../domian/model/HCPLogin_model.dart';
import '../../domian/repository/implementaion/HCPlogin_imp.dart';
import '../../domian/repository/interface/HCPlogin_repositry.dart';

class HcploginViewModel {
  // the name of inter face class in the backend
  final HCPLoginRepository _hcpLoginRepository;
  HcploginViewModel() : _hcpLoginRepository = HCPloginimp();

  String errorMessage = '';
  //الفيو بيحكي مع المودل فيو وهو بيحكي مع الريبوستري وهو بيحكي مع السوبيا بيس وهذا هو نظام الطبقات

  Future<void> loginHCP(String userName, String password) async {
    try {
      errorMessage = "";
      //عملت ريكوست وهو شغال عشان يرجع لي داتا
      AdminInformRespond AdminInformRespond1 = await _hcpLoginRepository
          .login(AdminModel(userName: userName, password: password));
    } on Exception catch (e) {
      errorMessage = e.toString();
    }
  }
}
