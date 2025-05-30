
import '../../../data/admin_fetch.dart';
import '../../model/HCPLogin_model.dart' show AdminInformRespond, AdminModel;
import '../interface/HCPlogin_repositry.dart';

class HCPloginimp implements HCPLoginRepository {
  //الكلاس يلي شابك مع الداتا بيس
  final AdminFetch supabaseService;

  HCPloginimp() : supabaseService = AdminFetch();

  @override
  Future<AdminInformRespond> login(AdminModel logindata) async {
    //بينادي الميثود تاعت الداتا بيس وبينادي للميثود يلي بدها تحولها ل مودل
    try {
      final data = await supabaseService.fetchHCPLoginMethod(
        logindata.userName,
        logindata.password,
      );
      return AdminInformRespond.fromMap(data);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
