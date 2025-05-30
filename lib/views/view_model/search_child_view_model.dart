

import '../../domian/model/child_model.dart';
import '../../domian/repository/implementaion/child_repository_impl.dart';

class SearchChildViewModel {
  final _repo = ChildRepositoryImpl();

  ChildModel? child;
  String errorMessage = '';

  Future<void> searchByNationalId(String nationalId) async {
    try {
      errorMessage = '';  // Resetting any previous error messages
      child = await _repo.getChildBasicInfo(nationalId);
      if (child == null) {
        errorMessage = 'الطفل غير موجود في النظام.';
      }
    } catch (e) {
      errorMessage = 'لم يتم العثور على الطفل أو حدث خطأ: $e';
      child = null;
    }
  }
}

