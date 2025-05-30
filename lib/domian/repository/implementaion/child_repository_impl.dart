
import '../../../data/fetchchildrendata.dart';
import '../../model/child_model.dart';
import '../interface/child_repository.dart';

class ChildRepositoryImpl implements ChildRepository {
  final ChildrenData supabaseService;

  ChildRepositoryImpl() : supabaseService = ChildrenData();

  @override
  Future<List<ChildModel>> getChildrenByFamilyBookNumber(
    String familyBookNumber,
  ) async {
    try {
      final data = await supabaseService.fetchChildrenByFamilyBookNumber(
        familyBookNumber,
      );
      return data.map((e) => ChildModel.fromMap(e)).toList();
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<ChildModel> getChildBasicInfo(String childId) async {
    try {
      final data = await supabaseService.fetchChildBasicInfo(childId);
      return ChildModel.fromMap(data);
    } on Exception catch (_) {
      rethrow;
    }
  }
 
  @override
  Future<bool> checkFamilyBookExists(String familyBookNumber) async {
    final children = await getChildrenByFamilyBookNumber(familyBookNumber);
    return children.isNotEmpty;
  }
}
