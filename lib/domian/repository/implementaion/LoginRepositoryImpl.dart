
import '../../../data/fetch_login_user.dart';
import '../../model/login.dart';
import '../interface/login_repository_interface.dart';

class LoginRepositoryImpl implements LoginRepositoryInterface {
  final FetchLoginUser dataSource;

  LoginRepositoryImpl(this.dataSource);

  @override
  Future<bool> loginUser({required Login data}) async {
    try {
      final user = await dataSource.getUserByFamilyBookAndPassword(
        familyBookId: data.familyBookNo,
        password: data.password,
      );

      return user != null;
    } catch (e) {
      rethrow;
    }
  }
}
