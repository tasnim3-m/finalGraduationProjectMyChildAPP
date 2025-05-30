
import '../../../data/fetch_return_sign_up.dart';

class SignUpRepositoryImpl {
  final FetchReturnSignUp _dataSource;

  SignUpRepositoryImpl(this._dataSource);

  /// يسجل مستخدم جديد إذا لم يكن موجودًا مسبقًا
  Future<bool> registerUser({
    required String familyBookId,
    required String fatherId,
    required String motherId,
    required String phone,
    required String password,
  }) async {
    final exists = await _dataSource.checkAccountExists(familyBookId);
    if (!exists) {
      await _dataSource.insertPerson(
        familyCardId: familyBookId,
        fatherId: fatherId,
        motherId: motherId,
      );
      await _dataSource.insertUser(
        familyCardId: familyBookId,
        phone: phone,
        password: password,
      );
      return true;
    }
    return false;
  }
}