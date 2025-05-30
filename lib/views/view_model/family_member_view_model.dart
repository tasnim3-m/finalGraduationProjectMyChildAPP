

import '../../domian/model/child_model.dart';
import '../../domian/repository/implementaion/child_repository_impl.dart';
import '../../domian/repository/interface/child_repository.dart';

class FamilyMemberViewModel {
  final ChildRepository _childRepository;

  FamilyMemberViewModel() : _childRepository = ChildRepositoryImpl();

  bool isLoading = false;
  String errorMessage = '';
  var familyMemberList = <ChildModel>[];

  Future<void> getChildrenByFamilyBookNumber(String familyBookNumber) async {
    try {
      isLoading = true;
      familyMemberList = await _childRepository
          .getChildrenByFamilyBookNumber(familyBookNumber);
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
